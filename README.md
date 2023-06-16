# ATIPO github workflows

This repository serves as a centralized location for storing [reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows) used to run CI processes for Armory-ATIPO team's projects.

## Table of Contents

- [ATIPO github workflows](#atipo-github-workflows)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Usage](#usage)
    - [Calling a reusable workflow](#calling-a-reusable-workflow)
  - [List of available Workflows](#list-of-available-workflows)
    - [create-release](#create-release)
    - [generate-manifests](#generate-manifests)
    - [patch-manifest](#patch-manifest)
    - [pre-commit](#pre-commit)
    - [rollback-release](#rollback-release)
  - [Development](#development)

## Introduction

Reusable workflows are predefined sequences of CI steps or tasks that can be easily shared and reused across different projects or repositories. By centralizing and sharing common workflows, this repository promotes code reusability, standardization, and efficiency.

## Usage

### Calling a reusable workflow

You call our reusable workflow by using the `uses` keyword. Unlike when you are using actions within a workflow, you call reusable workflows directly within a job, and not from within job steps.

> jobs.<job_id>.uses

You reference reusable workflow files using the following syntax:

> `armory-io/atipo-github-workflows/.github/workflows/{filename}@{ref}`

{ref} can be a SHA, a release tag, or a branch name. Using the commit SHA is the safest for stability and security. For more information, see [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#reusing-third-party-workflows).

You can call multiple workflows, referencing each in a separate job.

```yaml
jobs:
  # Reference using release tag
  generate-manifests:
    uses: armory-io/atipo-github-workflows/.github/workflows/generate-manifests.yml@v1
    secrets: inherit
    with:
      kustomize_version: "5.0.3"
      kustomize_overlay_paths: "tests/generate-manifests/kustomize/dev,tests/generate-manifests/kustomize/prod"
  # Reference using branch name
  create-release:
    uses: armory-io/atipo-github-workflows/.github/workflows/create-release.yml@main
    secrets: inherit
    with:
      is_prerelease: false
      is_draft: false
  # Reference using SHA
  rollback-release:
    uses: armory-io/atipo-github-workflows/.github/workflows/rollback-release.yml@4b6ff9de46240299430a28d52277d4071fdc1d78
    secrets: inherit
    with:
      is_prerelease: false
      is_draft: false
```

## List of available Workflows

You should only use the workflows listed below.

Please note that workflows located in the [.github/workflows/](.github/workflows/) folder that are not listed below are specific CI workflows intended only for this repository. You cannot use them as reusable workflows in your own project.

### create-release

This workflows automatically calculates next release tag (base on [semver](https://semver.org/)), generates changelog and creates a release for your project.

Please note that this workflow will increase the patch version after each run. For example, if your latest release version is v1.0.0, the release version generated by this workflow after the next run will be v1.0.1.

As for prerelease versions, v1.0.0-beta0 will become v1.0.0-beta1.

**Inputs & Outputs**:

See [create-release.yml](.github/workflows/create-release.yml) for more details.

**Example Usage**:

```yaml
name: Create Release

on:
  push:
    branches:
      - main

jobs:
  create-release:
    uses: armory-io/atipo-github-workflows/.github/workflows/create-release.yml@main
    secrets: inherit
    with:
      is_prerelease: false
      is_draft: false
```

### generate-manifests

This workflow will help you render Kustomize manifests and compare the changes of the rendered files with what is currently present in the default branch. It will then send these changes as a comment on your pull request.

Please note that this workflow is designed to run with the event `on.pull_request`.

**Inputs & Outputs**:

See [generate-manifests.yml](.github/workflows/generate-manifests.yml) for more details.

**Example Usage**:

```yaml
name: Generate manifests

on:
  pull_request:
    branches:
      - main

jobs:
  generate-manifests:
    uses: armory-io/atipo-github-workflows/.github/workflows/generate-manifests.yml@main
    secrets: inherit
    with:
      kustomize_version: "5.0.3"
      kustomize_overlay_paths: "kustomize/dev,kustomize/prod"
```

### patch-manifest

This workflow will help you patch a YAML manifest in your project based on the input it receives.

**Inputs & Outputs**:

See [patch-manifest.yml](.github/workflows/patch-manifest.yml) for more details.

**Example Usage**:

```yaml
name: Patch manifest

on:
  repository_dispatch:
    types:
      - PatchManifest

jobs:
  update_versions:
    uses: armory-io/atipo-github-workflows/.github/workflows/patch-manifest.yml@main
    secrets: inherit
    with:
      kustomize_version: "5.0.3"
      kustomize_overlay_paths: "tests/generate-manifests/kustomize/dev"
      manifest_file_path: "tests/generate-manifests/kustomize/dev/deploy.yaml"
      default_ref: "main"
      patch_manifest: |
        ${{ toJson(github.event.client_payload.patch_content) }}
```

### pre-commit

A workflow to run `pre-commit`.

**Inputs & Outputs**:

See [pre-commit.yml](.github/workflows/pre-commit.yml) for more details.

**Example Usage**:

```yaml
name: Pre Commit

on:
  pull_request:
    branches:
      - main

jobs:
  precommit:
    uses: armory-io/atipo-github-workflows/.github/workflows/pre-commit.yml@main
```

### rollback-release

This action will rollback/delete a Github release.

**Inputs & Outputs**:

See [rollback-release.yml](.github/workflows/rollback-release.yml) for more details.

**Example Usage**:

```yaml
name: Rollback Github (Pre)Release

on:
  workflow_dispatch:
    inputs:
      version:
        description: '(Pre)Release to revert; This will cause a deploy to the previous stable version'
        type: string
        required: true

jobs:
  precommit:
    uses: armory-io/atipo-github-workflows/.github/workflows/rollback-release.yml@main
    secrets: inherit
    with:
      version: ${{ inputs.version }}
```

## Development

For development details, see the [contributing guide](./CONTRIBUTING.md).
