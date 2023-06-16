# Contributing

## Adding Workflows

Copy any workflow that is similar to what you'd like to add. If you don't know which to pick, try the [create-release.yml](.github/workflows/create-release.yml).

1. Update the [repo readme](README.md).
2. Add a testing workflow (see: [testing guide](#testing))
3. Send a pull request and wait for reviews from ATIPO team.

## Testing

### Testing workflow

All actions you develop must be tested. Please create a workflow to test the workflow you just developed in the [.github/workflows](.github/workflows/) folder with the name `test-<action-name>` or add your test logic to [this workflow (test.yaml)](.github/workflows/test.yaml).

Then create a rule to trigger this workflow every time you make changes to the file and create a PR to the main branch.

For an example testing workflow, please see: [.github/workflows/test.yaml](.github/workflows/test.yaml).

### Testing locally

If possible, we encourage you to create a folder under the [test folder](./tests/) with the name of your workflow and place the test manifests in it. Then, create a bash file named `test.sh` and use the [act CLI](https://github.com/nektos/act) to run your workflow locally. You can follow the pre-existing test we have provided in [test/generate-manifests](tests/generate-manifests/).

> :warning:
>
> Please note that currently, [act](https://github.com/nektos/act) only works with inputs of type **workflow_dispatch**. Since all the inputs for the reusable workflows written in this repository are of type **workflow_call**, you need to change all instances of `on.workflow_call` to `on.workflow_dispatch` for local testing to work correctly.
>
> We have found [an issue](https://github.com/nektos/act/issues/1542) and [a pull request](https://github.com/nektos/act/pull/1845) in the [act](https://github.com/nektos/act) repository to address this issue, but it seems they have not been merged yet. Despite the inconvenience, we think that this is currently the only way for us to test the workflow locally.

To install `act` on MacOS:

```bash
brew install --HEAD act
```

Navigate to `test` folder:

```bash
cd ./test/<workflow-name>
```

Setup required environment variables:

```bash
cp example.env .env
# Edit .env to add any required environment variables.
```

Setup required input to run the workflow:

```bash
cp example.input .input
```

Then run the test script:

```bash
./test.sh
```
