# Webhooks & REST API Workshop (Satellite, May 2020)

Welcome! Thanks for joining us at our webhooks and REST API workshop. Today we'll be covering [webhooks](https://developer.github.com/webhooks/) and our [REST API](https://developer.github.com/v3/).

# What we're working on

The project that we are going to build together today is a changelog application. The entries will automatically be added when pull requests are merged. The changelog will be hosted by GitHub Pages. Here's an example of the final product: https://githubsatelliteworkshops.github.io/webhooks-with-rest/

![image](https://user-images.githubusercontent.com/3330181/80778977-34e3df80-8b38-11ea-825e-8f427d3acb78.png)

# Getting started

## Fork and clone

To get started you first need to fork this repository

<img src="https://user-images.githubusercontent.com/3330181/80671986-5fbb2e80-8a79-11ea-8c4f-aa12514ea4bc.png" width=1000>

clone your forked repo to your local machine

<img src="https://user-images.githubusercontent.com/3330181/80672075-a1e47000-8a79-11ea-82d7-544c323642b2.png" width=500>

```
git clone git@github.com:<username>/webhooks-with-rest.git --config core.autocrlf=input
```


## Bootstrap

Now that you have the repo locally `cd` into that directory and run

For Unix:

```
script/bootstrap
```

For Windows (in Powershell):

```
.\exe\bootstrap.ps1
```

Be sure you have docker running before attempting that command.

## Credentials

Now that you have the docker image created, we need to setup some credentials.

### Personal access token

Let's generate a personal access token (PAT) for this workshop. First head to https://github.com/settings/tokens/new. Once there, name your token and select the `repo` scope.

<details>
  <summary>Example Configuration</summary>

![image](https://user-images.githubusercontent.com/3330181/81121364-8c999680-8efc-11ea-8a07-77cec8cc5973.png)

</details>

Once you've generated it, be sure to copy it because you won't be able to view it again.

With it copied to your clipboard, open a file called `/changelogger/.env` on your favorite editor and update the value of the environment variable `GITHUB_PERSONAL_ACCESS_TOKEN` to the one that you just copied.

### Webhook secret

When we configure our webhook in a few minutes, we are going to do so with a random secret token. In general, it's best to use a very random string, but for today just pick anything that you can remember for long enough to configure your webhook with. Then follow exactly what we did for the personal access token but this time update the value of the environment variable `GITHUB_WEBHOOK_SECRET` to the one that you just copied.

## Enable GitHub Pages

We will need GitHub Pages to be enabled in order to view the changelog we are creating. Go to the repository settings page

<img src="https://user-images.githubusercontent.com/3330181/79942668-599fcf00-8435-11ea-9381-d889bb06c784.png" width=1000>

Scroll down to the GitHub Pages section, and enable pages for `master branch /docs folder`

<details>
  <summary>Pages Configuration</summary>

![image](https://user-images.githubusercontent.com/3330181/80670658-7f505800-8a75-11ea-9f49-e81a75d04668.png)


</details>

Once selected, it should say that the site is ready to be published and the URL it generated for you. If you click the link, it should take you to a 404 page right now.

# Step 0: Configuring a webhook

Now that we have all of the credentials necessary, we can run

For Unix:

```
script/server
```

For Windows (in Powershell):

```
.\exe\server.ps1
```

This will start the app server as well as a proxy to tunnel requests to your local server. There should be an output that includes a URL.

```
$ script/server

╔═══╦╗─────────────╔╗
║╔═╗║║─────────────║║
║║─╚╣╚═╦══╦═╗╔══╦══╣║╔══╦══╦══╦══╦═╗
║║─╔╣╔╗║╔╗║╔╗╣╔╗║║═╣║║╔╗║╔╗║╔╗║║═╣╔╝
║╚═╝║║║║╔╗║║║║╚╝║║═╣╚╣╚╝║╚╝║╚╝║║═╣║
╚═══╩╝╚╩╝╚╩╝╚╩═╗╠══╩═╩══╩═╗╠═╗╠══╩╝
─────────────╔═╝║───────╔═╝╠═╝║
─────────────╚══╝───────╚══╩══╝

+----------------------------------------------+
| Your public url is: http://044af013.ngrok.io |
+----------------------------------------------+

This is the output of your web app.
===================================

Puma starting in single mode...
* Version 4.3.3 (ruby 2.6.3-p62), codename: Mysterious Traveller
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

Copy the generated URL and navigate to the repo settings page

<img src="https://user-images.githubusercontent.com/3330181/79942668-599fcf00-8435-11ea-9381-d889bb06c784.png" width=1000>

Then find webhooks in the side menu

<img src="https://user-images.githubusercontent.com/3330181/79942740-86ec7d00-8435-11ea-8190-4fa10c76cc8a.png" width=250>

And then select `add webhook`

<img src=https://user-images.githubusercontent.com/3330181/79942860-b3a09480-8435-11ea-9acc-c2d3e7522949.png width=1000>

Which will bring you to the form for creating a new repository webhook.

You will need a webhook with the following configuration:

- URL: paste your ngrok generated URL into the URL field
- Content Type: select json
- Secret: use the secret that you added as part of your credentials
- Events: select only the `Pull Requests` events
- Active: make sure the hook is marked as active

<details>
  <summary>Example Configuration</summary>

![image](https://user-images.githubusercontent.com/3330181/81121611-25c8ad00-8efd-11ea-9658-cdec1607dbf2.png)

</details>

Once you add the event, you should see a ping event in both the logs

<details>
  <summary>Delivery Logs</summary>

![image](https://user-images.githubusercontent.com/3330181/81121703-5ad4ff80-8efd-11ea-842a-0fb43306b9d8.png)

</details>

and in the server output

<details>
  <summary>Server Logs</summary>

```
{
  "zen": "Keep it logically awesome.",
  "hook_id": 208294689,
  "hook": {
    "type": "Repository",
    "id": 208294689,
    "name": "web",
    "active": true,
    "events": [
      "pull_request"
    ],
    "config": {
      "content_type": "json",
      "insecure_ssl": "0",
      "secret": "********",
      "url": "http://738493f3.ngrok.io"
    },
    "updated_at": "2020-05-05T22:21:09Z",
    "created_at": "2020-05-05T22:21:09Z",
    "url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/hooks/208294689",
    "test_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/hooks/208294689/test",
    "ping_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/hooks/208294689/pings",
    "last_response": {
      "code": null,
      "status": "unused",
      "message": null
    }
  },
  "repository": {
    "id": 258584463,
    "node_id": "MDEwOlJlcG9zaXRvcnkyNTg1ODQ0NjM=",
    "name": "webhooks-with-rest",
    "full_name": "githubsatelliteworkshops/webhooks-with-rest",
    "private": false,
    "owner": {
      "login": "githubsatelliteworkshops",
      "id": 64148422,
      "node_id": "MDEyOk9yZ2FuaXphdGlvbjY0MTQ4NDIy",
      "avatar_url": "https://avatars1.githubusercontent.com/u/64148422?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/githubsatelliteworkshops",
      "html_url": "https://github.com/githubsatelliteworkshops",
      "followers_url": "https://api.github.com/users/githubsatelliteworkshops/followers",
      "following_url": "https://api.github.com/users/githubsatelliteworkshops/following{/other_user}",
      "gists_url": "https://api.github.com/users/githubsatelliteworkshops/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/githubsatelliteworkshops/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/githubsatelliteworkshops/subscriptions",
      "organizations_url": "https://api.github.com/users/githubsatelliteworkshops/orgs",
      "repos_url": "https://api.github.com/users/githubsatelliteworkshops/repos",
      "events_url": "https://api.github.com/users/githubsatelliteworkshops/events{/privacy}",
      "received_events_url": "https://api.github.com/users/githubsatelliteworkshops/received_events",
      "type": "Organization",
      "site_admin": false
    },
    "html_url": "https://github.com/githubsatelliteworkshops/webhooks-with-rest",
    "description": "Building GitHub integrations with webhooks and REST",
    "fork": false,
    "url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest",
    "forks_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/forks",
    "keys_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/teams",
    "hooks_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/hooks",
    "issue_events_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/issues/events{/number}",
    "events_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/events",
    "assignees_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/assignees{/user}",
    "branches_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/branches{/branch}",
    "tags_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/tags",
    "blobs_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/languages",
    "stargazers_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/stargazers",
    "contributors_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/contributors",
    "subscribers_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/subscribers",
    "subscription_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/subscription",
    "commits_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/issues/comments{/number}",
    "contents_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/contents/{+path}",
    "compare_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/merges",
    "archive_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/downloads",
    "issues_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/issues{/number}",
    "pulls_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/labels{/name}",
    "releases_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/releases{/id}",
    "deployments_url": "https://api.github.com/repos/githubsatelliteworkshops/webhooks-with-rest/deployments",
    "created_at": "2020-04-24T17:55:13Z",
    "updated_at": "2020-05-05T22:08:56Z",
    "pushed_at": "2020-05-05T22:10:16Z",
    "git_url": "git://github.com/githubsatelliteworkshops/webhooks-with-rest.git",
    "ssh_url": "git@github.com:githubsatelliteworkshops/webhooks-with-rest.git",
    "clone_url": "https://github.com/githubsatelliteworkshops/webhooks-with-rest.git",
    "svn_url": "https://github.com/githubsatelliteworkshops/webhooks-with-rest",
    "homepage": "",
    "size": 27401,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": "Ruby",
    "has_issues": true,
    "has_projects": false,
    "has_downloads": true,
    "has_wiki": false,
    "has_pages": true,
    "forks_count": 2,
    "mirror_url": null,
    "archived": false,
    "disabled": false,
    "open_issues_count": 1,
    "license": null,
    "forks": 2,
    "open_issues": 1,
    "watchers": 0,
    "default_branch": "master"
  },
  "sender": {
    "login": "janester",
    "id": 3330181,
    "node_id": "MDQ6VXNlcjMzMzAxODE=",
    "avatar_url": "https://avatars1.githubusercontent.com/u/3330181?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/janester",
    "html_url": "https://github.com/janester",
    "followers_url": "https://api.github.com/users/janester/followers",
    "following_url": "https://api.github.com/users/janester/following{/other_user}",
    "gists_url": "https://api.github.com/users/janester/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/janester/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/janester/subscriptions",
    "organizations_url": "https://api.github.com/users/janester/orgs",
    "repos_url": "https://api.github.com/users/janester/repos",
    "events_url": "https://api.github.com/users/janester/events{/privacy}",
    "received_events_url": "https://api.github.com/users/janester/received_events",
    "type": "User",
    "site_admin": true
  }
}
HTTP_USER_AGENT: GitHub-Hookshot/7431eee
CONTENT_TYPE: application/json
HTTP_X_GITHUB_EVENT: ping
HTTP_X_GITHUB_DELIVERY: b82d7880-8f1e-11ea-8f58-aae643ef5b38
HTTP_X_HUB_SIGNATURE: sha1=8e0edbf5f09e88602898c24430008150a1934fdc
method=POST path=/ format=*/* controller=WebhooksController action=create status=204 duration=5.26 view=0.00
```

</details>

Congrats! You just recieved your first webhook! 🎉

# Step 1: Filter events

The next step is to filter the events that we recieve to only act upon the ones that we care about. Use the payload's fields to determine which ones we want. For this project we care only about the pull requests that:

- the action is closed
- the PR's state is merged and not just closed
- have the special changelog label

We'll work on adding this code together, but if you fall behind, feel free to check out the `filter-events` branch, which has this step complete already.

```
git checkout filter-events
```

Diff: https://github.com/githubsatelliteworkshops/webhooks-with-rest/compare/master...filter-events

# Step 2: Octokit

Now that we know we are only acting on the events we care about, we need to _do something_ with this data. For this project, we are doing to parse the webhook payload for information and then POST it back to the repo in the form of a changelog entry. In order to do the POSTing, we need to setup our SDK client: Octokit.

We'll work on adding and testing this client together, but if you fall behind, feel free to check out the `octokit` branch, which has this step complete already.

```
git checkout octokit
```

Diff: https://github.com/githubsatelliteworkshops/webhooks-with-rest/compare/filter-events...octokit

# Step 3: REST API calls

Since we can make API calls now, let's add the logic of adding the changelog entry. We need to determine if the `docs/index.md` file exists already and if it does, we'll append a new entry. If it doesn't, we'll need to create a default one and add the new entry. We are going to be using the [Contents API](https://developer.github.com/v3/repos/contents/) to do this, but we are going to use the octokit methods to help us out.

This is our biggest step, so if you fall behind, feel free to check out the `add-changelog-entries` branch, which has this step complete already.

```
git checkout add-changelog-entries
```

Diff: https://github.com/githubsatelliteworkshops/webhooks-with-rest/compare/octokit...add-changelog-entries

# Step 4: Verify webhooks

The project is technically feature complete at this point, but we want to go over some webhook best practices. So, we are also going to add logic to verify that the payload came from GitHub. The way we do that is by generating a checksum of the payload and webhook secret, and comparing it with the one sent to us by GitHub in the `X-Hub-Signature` header. More information can be found in the docs: https://developer.github.com/webhooks/securing/

This is our most technically complext step, so if you fall behind, feel free to check out the `verify-webhooks` branch, which has this step complete already.

```
git checkout verify-webhooks
```

Diff: https://github.com/githubsatelliteworkshops/webhooks-with-rest/compare/add-changelog-entries...verify-webhooks
