# Testing GitHub Actions

[![GitHub release](https://img.shields.io/github/release/peterhirn/testing-actions.svg?logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/releases/latest)
[![Docker workflow](https://img.shields.io/github/workflow/status/peterhirn/testing-actions/docker?label=docker%20action&logo=github&style=flat-square)](https://github.com/peterhirn/testing-actions/actions?workflow=docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/peter87623/tmp.svg?logo=docker&style=flat-square)](https://hub.docker.com/r/peter87623/tmp)

Build

    docker build --target alpine -t tmp .

Build specific platform

    docker buildx build --platform linux/arm/v7 --target alpine -t tmp --load .

Bake

    docker buildx bake -f docker-bake.hcl
