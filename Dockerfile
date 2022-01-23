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

FROM restore as build-alpine-runtime
ARG TARGETARCH
ARG CONFIGURATION
ARG FRAMEWORK
ARG PROJECT

RUN dotnet publish \
    --output publish \
    --configuration $CONFIGURATION \
    --framework $FRAMEWORK \
    --runtime linux-musl-${TARGETARCH/amd/x} \
    --no-self-contained \
    $PROJECT

FROM restore as build-bullseye-runtime
ARG TARGETARCH
ARG CONFIGURATION
ARG FRAMEWORK
ARG PROJECT

RUN dotnet publish \
    --output publish \
    --configuration $CONFIGURATION \
    --framework $FRAMEWORK \
    --runtime linux-${TARGETARCH/amd/x} \
    --no-self-contained \
    $PROJECT

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.1-bullseye-slim AS bullseye
COPY --from=build-bullseye /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.1-alpine3.14 AS alpine
COPY --from=build-alpine /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]

FROM mcr.microsoft.com/dotnet/runtime:6.0.1-bullseye-slim AS bullseye-runtime
COPY --from=build-bullseye-runtime /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]

FROM mcr.microsoft.com/dotnet/runtime:6.0.1-alpine3.14 AS alpine-runtime
COPY --from=build-alpine-runtime /build/publish/* /usr/local/bin/
ENTRYPOINT [ "App" ]
