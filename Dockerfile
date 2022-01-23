FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0.101-alpine3.14 as restore
WORKDIR /build

COPY .config/ .config/
RUN dotnet tool restore

COPY paket.dependencies paket.dependencies
COPY paket.lock paket.lock
RUN dotnet paket restore

COPY src/ src/

FROM restore as build-alpine-amd64
RUN dotnet publish \
    --output Publish \
    --configuration Release \
    --framework net6.0 \
    --runtime linux-musl-x64 \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=true \
    -p:IncludeNativeLibrariesForSelfExtract=true \
    src/App.fsproj

FROM restore as build-bullseye-amd64
RUN dotnet publish \
    --output Publish \
    --configuration Release \
    --framework net6.0 \
    --runtime linux-x64 \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=true \
    -p:IncludeNativeLibrariesForSelfExtract=true \
    src/App.fsproj

FROM restore as build-alpine-arm64
RUN dotnet publish \
    --output Publish \
    --configuration Release \
    --framework net6.0 \
    --runtime linux-arm64 \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=true \
    -p:IncludeNativeLibrariesForSelfExtract=true \
    src/App.fsproj

FROM build-alpine-arm64 as build-bullseye-arm64

FROM restore as build-alpine-arm
RUN dotnet publish \
    --output Publish \
    --configuration Release \
    --framework net6.0 \
    --runtime linux-arm \
    --self-contained \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=true \
    -p:IncludeNativeLibrariesForSelfExtract=true \
    src/App.fsproj

FROM build-alpine-arm as build-bullseye-arm

FROM build-bullseye-$TARGETARCH as build-bullseye
FROM build-alpine-$TARGETARCH as build-alpine

FROM debian:11.2-slim AS bullseye
RUN apt-get update && apt-get install -y --no-install-recommends libicu67 && rm -rf /var/lib/apt/lists/*
COPY --from=build-bullseye /build/Publish/App /usr/local/bin/App
ENTRYPOINT [ "App" ]

FROM alpine:3.15 AS alpine
RUN apk add --update --no-cache libgcc libstdc++ icu
COPY --from=build-alpine /build/Publish/App /usr/local/bin/App
ENTRYPOINT [ "App" ]
