# Tooling

> This directory manages common tooling for [@workloads](https://github.com/workloads).

## Table of Contents

<!-- TOC -->
* [Tooling](#tooling)
  * [Table of Contents](#table-of-contents)
  * [Requirements](#requirements)
  * [Usage](#usage)
  * [Notes](#notes)
    * [Scoping Operations](#scoping-operations)
    * [Colored Output](#colored-output)
  * [Author Information](#author-information)
  * [License](#license)
<!-- TOC -->

## Requirements

* `make` `3.80` or newer
* `checkmake` `0.2.2` or [newer](https://github.com/mrtazz/checkmake#installation)
* `terraform-docs` `0.16.0` or [newer](https://terraform-docs.io/user-guide/installation/)
* 1Password CLI `2.0.0` or [newer](https://1password.com/downloads/command-line/)
* GitHub CLI `2.32.0` or [newer](https://cli.github.com/)
* OpenSSF Scorecard CLI `4.10.0` or [newer](https://github.com/ossf/scorecard#scorecard-command-line-interface)

## Usage

This repository provides a workflow that is wrapped through a [Makefile](./Makefile).

Running `make` without commands will print out the following help information:

```text
🔧 MAINTENANCE

Target              Description                                          Usage
init                initialize and upgrade code for all workspaces       `make init`
lint                format, validate, and lint code in all workspaces    `make lint`
docs                generate documentation for all workspaces            `make docs`
pull                pull latest changes for all repositories             `make pull`
scorecards          generate OpenSSF Scorecards                          `make scorecards target=<repository>`
delete-gha-logs     delete GitHub Actions Logs for all repositories      `make delete-gha-logs target=<repository>`
get-gh-rate-limit   get GitHub API rate limit status                     `make get-gh-rate-limit`
help                display a list of Make Targets                       `make help`
_listincludes       list all included Makefiles and *.mk files           `make _listincludes`
_selfcheck          lint Makefile                                        `make _selfcheck`
```

## Notes

### Scoping Operations

The `init`, `lint`, `docs`, `scorecards`, and `delete-gha-logs` targets support both global and scoped operations.

By default, all repositories (as defined in [github.mk](./make/configs/github.mk)) will be targeted.

An operation may be scoped to a single repository by setting the `repository` argument:

```shell
make init repository=<repository>
```

### Colored Output

Colorized CLI output may be disabled by setting the `NO_COLOR` environment variable to any non-empty value.

```shell
export NO_COLOR=1 && make
```

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/workloads/tooling/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
