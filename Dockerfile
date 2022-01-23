ARG CONFIGURATION=Release
ARG FRAMEWORK=net6.0
ARG TRIMMED=true
ARG SELF_EXTRACT=true
ARG PROJECT=src/App.fsproj

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0.101-alpine3.14 as restore
WORKDIR /build

COPY .config/ .config/
RUN dotnet tool restore

COPY paket.dependencies paket.dependencies
COPY paket.lock paket.lock
RUN dotnet paket restore

COPY src/ src/

FROM restore as build-alpine
ARG TARGETARCH
ARG CONFIGURATION
ARG FRAMEWORK
ARG TRIMMED
ARG SELF_EXTRACT
ARG PROJECT

RUN dotnet publish \
    --output publish \
    --configuration $CONFIGURATION \
    --framework $FRAMEWORK \
    --runtime linux-musl-${TARGETARCH/amd/x} \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=$TRIMMED \
    -p:IncludeNativeLibrariesForSelfExtract=$SELF_EXTRACT \
    $PROJECT

FROM restore as build-bullseye
ARG TARGETARCH
ARG CONFIGURATION
ARG FRAMEWORK
ARG TRIMMED
ARG SELF_EXTRACT
ARG PROJECT

RUN dotnet publish \
    --output publish \
    --configuration $CONFIGURATION \
    --framework $FRAMEWORK \
    --runtime linux-${TARGETARCH/amd/x} \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=$TRIMMED \
    -p:IncludeNativeLibrariesForSelfExtract=$SELF_EXTRACT \
    $PROJECT

FROM debian:11.2-slim AS bullseye
RUN apt-get update && apt-get install -y --no-install-recommends libicu67 && rm -rf /var/lib/apt/lists/*
COPY --from=build-bullseye /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]

FROM alpine:3.15 AS alpine
RUN apk add --update --no-cache libgcc libstdc++ icu
COPY --from=build-alpine /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]
