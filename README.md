# Testing GitHub Actions

[![GitHub release](https://img.shields.io/github/release/peterhirn/testing-actions.svg?logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/releases/latest)
[![Docker workflow](https://img.shields.io/github/actions/workflow/status/peterhirn/testing-actions/.github/workflows/docker.yaml?label=docker&logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/actions?workflow=docker)
[![Assets workflow](https://img.shields.io/github/actions/workflow/status/peterhirn/testing-actions/.github/workflows/assets.yaml?label=assets&logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/actions?workflow=assets)
[![Tests workflow](https://img.shields.io/github/actions/workflow/status/peterhirn/testing-actions/.github/workflows/tests.yaml?label=tests&logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/actions?workflow=tests)
[![Docker pulls](https://img.shields.io/docker/pulls/peter87623/testing-actions.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/peter87623/testing-actions)

Build

    docker build --target alpine -t tmp .

Build specific platform

    docker buildx build --platform linux/arm64 --target alpine -t tmp --load .

Bake

    docker buildx bake -f docker-bake.hcl

Release

    gh release create v1.0.12-alpha.1 --prerelease --generate-notes
    gh release create v1.0.12-rc.1 --prerelease --generate-notes
    gh release create v1.0.12 --generate-notes

Run

    docker run -it --rm peter87623/testing-actions -a -b -c
    docker run -it --rm --platform linux/arm64 peter87623/testing-actions
