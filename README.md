<h1 align="center">Building GitHub integrations with webhooks and REST</h1>
<h5 align="center">@bswinnerton, @janester, and @nronas</h3>

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

Webhooks are valuable tools for powering real-time integrations and workflows in your project’s existing tools. This session will walk through an approach of building a webhook-powered application that acts on events as they take place on GitHub. You will also learn how to use the GitHub REST API through the Octokit SDK to call for additional resources after receiving an event.

## :mega: Prerequisites
- A GitHub account
- A personal access token
- A working installation of Docker
- Some familiarity with coding (preferrably in ruby)
- Some familiarity with git
- Some familiarity with GitHub

## :books: Resources
- [GitHub Account Creation](https://github.com/join)
- [Create an Access Token](https://github.com/settings/tokens/new)
- [Ruby-lang](https://www.ruby-lang.org/en/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Docker installation](https://www.docker.com/products/docker-desktop)

# Getting Started

## Setup

Once you have all of the above prerequisites installed, please fork this repo:

```
$ git clone git@github.com:github/satelite-2020-webhooks.git
```

and then build the docker image that will bootstrap the app components and it's dependencies

```
$ docker build -t changelogger .
```

Now that you have all of the necessary tools, let's get started!

## Ngrok

The app is configured to use a tunnel that routes public urls to a configured port in localhost.

In order to get the public url simply run `$ script/whats_my_url`

You should see something like this on your screen:

```
+----------------------------------------------+
| Your public url is: http://a4f49105.ngrok.io |
+----------------------------------------------+
```

Please note that if you kill the ngrok container, you will lose these URLs forever. If you need to kill the ngrok container you can do it by executing `$ docker stop proxy`

## Setup a webhook on your repo

Now that you have a URL to send webhooks to, let's configure one in the repo settings page

1. Click Settings on the top right of the repo page

![image](https://user-images.githubusercontent.com/3330181/79942668-599fcf00-8435-11ea-9381-d889bb06c784.png)

2. Select webhooks from the side menu

![image](https://user-images.githubusercontent.com/3330181/79942740-86ec7d00-8435-11ea-8190-4fa10c76cc8a.png)

3. Select add new webhook on the top right of that page

![image](https://user-images.githubusercontent.com/3330181/79942860-b3a09480-8435-11ea-9acc-c2d3e7522949.png)

4. Add a new webhook

![image](https://user-images.githubusercontent.com/3330181/79943021-db8ff800-8435-11ea-88c4-8192e9ce182e.png)

On that page, create a new webhook by:

1. pasting your ngrok generated URL into the URL field
2. Updating the `Content type` drop down to use json
3. Selecting the `Let me select individual events.` radio button
4. Uncheck `Pushes` checkbox and check `Pull requests` instead
5. Make sure the `Active` checkbox is still checked
6. Press `Add Webhook`

This will take you back to view all webhooks configured for the repo and you should see your new one listed. Click back into it and you should see a delivery log entry for a `ping` event

![image](https://user-images.githubusercontent.com/3330181/79943927-3d516180-8438-11ea-906e-e38c000a2b9a.png)

You should also be able to see the request come into your ngrok via their web UI, via running `$ script/request_log`

# Workshop

Let's get started on the workshop! Today we are going to be building an automatic changelog powered by Webhooks, REST API, and GitHub Pages.

## Step 0: Receive Webhook

If you navigate to the webhooks controller, you should see that the action will just print contents of any payload that it recieves.

## Step 1: Filter Events

Diff: https://github.com/github/satelite-2020-webhooks/compare/master...filter-events

If you fall behind, feel free to checkout the `filter-events` branch to get caught up

```
$ git checkout filter-events
```

Now that we are able to verify that the payload is legitimate, we should filter them to be the ones we care about. For this exercise we only care about `pull_request` events and even more specifically, we only care when a PR is _merged_ with a specific label.

## Step 2: Octokit

Diff: https://github.com/github/satelite-2020-webhooks/compare/filter-events...octokit

If you fall behind, feel free to checkout the `octokit` branch to get caught up

```
$ git checkout octokit
```

Now that we've filtered down to the webhooks that we care about, we need to start accessing more data via the REST API. To do that, we are going to use the ruby SDK, [octokit](https://github.com/octokit/octokit.rb). Let's setup a client with our personal access tokens.

## Step 3: Enable GitHub Pages

Diff: https://github.com/github/satelite-2020-webhooks/compare/octokit...enable-pages

If you fall behind, feel free to checkout the `enable-pages` branch to get caught up

```
$ git checkout enable-pages
```

Now that we have an API client, let's check to make sure that GitHub Pages is enabled for the repository. If it isn't, let's enable it through the API.

## Step 4: Add New Changelog Entry

Diff:
https://github.com/github/satelite-2020-webhooks/compare/enable-pages...add-changelog-entries

If you fall behind, feel free to checkout the `add-changelog-entries` branch to get caught up

```
$ git checkout add-changelog-entries
```

Now that we know GitHub Pages is enabled, let's generate a changelog entry and update the changelog through the API.

## Step 5: Verify Webhook Payload

Diff: https://github.com/github/satelite-2020-webhooks/compare/add-changelog-entries...verify-webhooks

If you fall behind, feel free to checkout the `verify-webhooks` branch to get caught up

```
$ git checkout verify-webhooks
```

Now that we are able to receive payloads to our endpoint, we want to make sure that we are only receiving them from GitHub. Since we configured our secret on the webhook settings, we can use that to compare checksums. The `X-Hub-Signature` header will come in with any payload from GitHub and will be a SHA1 checksum of the payload with your configured secret. We can regenerate our own and compare them to make sure the request is legitimate.

Docs: https://developer.github.com/webhooks/securing/
