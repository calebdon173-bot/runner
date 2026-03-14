# GitHub Actions Runner Image

A custom, optimized GitHub Actions runner image with essential tools pre-installed and automated slimming.

## Features

- **Base Image**: `summerwind/actions-runner:latest`
- **Pre-installed Tools**:
  - AWS CLI, Azure CLI, GitHub CLI
  - Terraform, Ansible
  - Node.js 20 (LTS)
  - Go 1.23.0
  - Java (OpenJDK 8, 11, 17, 21)
  - Essential build tools (`curl`, `git`, `jq`, `unzip`, etc.)
- **Automated Builds**:
  - **Freshness**: Uses a `CACHE_DATE` build argument to force `apt-get upgrade` on every build.
  - **Optimization**: Uses [Docker-Slim](https://github.com/slimtoolkit/slim) to drastically reduce image size.
  - **Scheduling**: Rebuilds automatically every Monday via GitHub Actions.

## Image Tags

- `ghcr.io/${{ github.repository }}/custom-runner:latest`: The full, un-slimmed image.
- `ghcr.io/${{ github.repository }}/custom-runner:slim`: The optimized, slimmed version (recommended for faster pulls).

## Usage in Workflows

To use this runner in your GitHub Actions, set `runs-on` to the self-hosted label associated with this runner after deploying it.

```yaml
jobs:
  my-job:
    runs-on: self-hosted
    container:
      image: ghcr.io/YOUR_ORG/YOUR_REPO/custom-runner:slim
```

## Maintenance

The image is built and maintained via the workflow in `.github/workflows/runner.yaml`.
