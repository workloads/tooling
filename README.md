# Tooling

> This repository manages common tooling for [@workloads](https://github.com/workloads).

## Table of Contents

<!-- TOC -->
* [Tooling](#tooling)
  * [Table of Contents](#table-of-contents)
  * [Requirements](#requirements)
  * [Usage](#usage)
  * [Notes](#notes)
    * [Sensitive Data](#sensitive-data)
    * [Scoping Operations](#scoping-operations)
    * [Colorized Output](#colorized-output)
  * [Contributors](#contributors)
  * [License](#license)
<!-- TOC -->

## Requirements

* `make` `3.80` or newer
* `checkmake` `0.2.2` or [newer](https://github.com/mrtazz/checkmake#installation)
* `terraform-docs` `0.17.0` or [newer](https://terraform-docs.io/user-guide/installation/)
* 1Password CLI `2.0.0` or [newer](https://1password.com/downloads/command-line/)
* GitHub CLI `2.32.0` or [newer](https://cli.github.com/)
* OpenSSF Scorecard CLI `4.10.0` or [newer](https://github.com/ossf/scorecard#scorecard-command-line-interface)

## Usage

This repository provides a [Makefile](./Makefile)-based workflow.

Running `make` without commands will print out the following help information:

```text
🔧 MAINTENANCE

Target              Description                                                 Usage
init                initialize and upgrade code for all workspaces              `make init repository=<repository>`
lint                format, validate, and lint code in all workspaces           `make lint repository=<repository>`
docs                generate documentation for all workspaces                   `make docs repository=<repository>`
checkout            check out all (public and private) repositories             `make checkout`
pull                pull latest changes for all repositories                    `make pull`
scorecards          generate OpenSSF Scorecards                                 `make scorecards target=<repository>`
delete-gha-logs     delete GitHub Actions Logs for all repositories             `make delete-gha-logs repository=<repository>`
get-gh-rate-limit   get GitHub API rate limit status                            `make get-gh-rate-limit`
request-cert        request a wildcard certificate from Let's Encrypt           `make request-cert domain=<domain>`
get-cert            retrieve a wildcard certificate from Vault                  `make get-cert domain=<domain>`
put-cert            store a wildcard certificate from Let's Encrypt in Vault    `make store-cert domain=<domain>`
help                display a list of Make Targets                              `make help`
_listincludes       list all included Makefiles and *.mk files                  `make _listincludes`
_selfcheck          lint Makefile                                               `make _selfcheck`
```

## Notes

### Sensitive Data

Terraform state may contain [sensitive data](https://developer.hashicorp.com/terraform/language/state/sensitive-data). This workspace uses [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs) to safely store state, and encrypt the data at rest.

### Scoping Operations

The `init`, `lint`, `docs`, `scorecards`, and `delete-gha-logs` targets support both global and scoped operations.

By default, all repositories (as defined in [github.mk](./make/configs/github.mk)) will be targeted.

An operation may be scoped to a single repository by setting the `repository` argument:

```shell
make init repository=<repository>
```

### Colorized Output

Colorized CLI output may be disabled by setting the `NO_COLOR` environment variable to any non-empty value.

```shell
export NO_COLOR=1 && make
```

## Contributors

For a list of current (and past) contributors to this repository, see [GitHub](https://github.com/workloads/tooling/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may download a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

See the License for the specific language governing permissions and limitations under the License.
