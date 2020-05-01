---
layout: default
title: Home
nav_order: 1
description: "The Changelog"
permalink: /
---

# 2020-04-30 23:55:44 UTC

By: ![avatar](https://avatars1.githubusercontent.com/u/3330181?v=4&s=50) [janester](https://github.com/janester)

## Step 0: Receive Webhooks

This change allows us to to receive webhook payloads and display them and the relevant headers in the server logs.

[[diff](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/1.diff)][[pull request](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/1)]
* * *

# 2020-05-01 00:01:07 UTC

By: ![avatar](https://avatars1.githubusercontent.com/u/3330181?v=4&s=50) [janester](https://github.com/janester)

## Step 1: Filter Events

We now drop any event that we receive that isn't a PR being merged with the `documentation` label.

[[diff](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/2.diff)][[pull request](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/2)]
* * *

# 2020-05-01 00:06:15 UTC

By: ![avatar](https://avatars1.githubusercontent.com/u/3330181?v=4&s=50) [janester](https://github.com/janester)

## Step 2: Octokit

Added an octokit client for making REST API calls.

[[diff](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/3.diff)][[pull request](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/3)]
* * *

# 2020-05-01 02:54:13 UTC

By: ![avatar](https://avatars1.githubusercontent.com/u/3330181?v=4&s=50) [janester](https://github.com/janester)

## Step 3: Create Changelog Entries

Now we can add new entries to a `doc/index.md`. If one doesn't exist already, we create one with default frontmatter and the new entry.

[[diff](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/4.diff)][[pull request](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/4)]
* * *

# 2020-05-01 02:59:01 UTC

By: ![avatar](https://avatars1.githubusercontent.com/u/3330181?v=4&s=50) [janester](https://github.com/janester)

## Step 4: Verify Webhooks

We now reject any payloads that aren't verified to be from GitHub based on the `X-Hub-Signature` header.

[[diff](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/5.diff)][[pull request](https://github.com/githubsatelliteworkshops/webhooks-with-rest/pull/5)]
* * *

