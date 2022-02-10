ARG PROJECT=src/App.fsproj
ARG VERSION=1.0.0
ARG CONFIGURATION=Release
ARG FRAMEWORK=net6.0
ARG TRIMMED=true
ARG SELF_EXTRACT=false

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
ARG PROJECT
ARG VERSION
ARG CONFIGURATION
ARG FRAMEWORK
ARG TRIMMED
ARG SELF_EXTRACT

RUN dotnet publish \
    --output publish \
    --configuration ${CONFIGURATION} \
    --framework ${FRAMEWORK} \
    --runtime linux-musl-${TARGETARCH/amd/x} \
    --self-contained \
    -p:Version=${VERSION/v/} \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=${TRIMMED} \
    -p:IncludeNativeLibrariesForSelfExtract=${SELF_EXTRACT} \
    $PROJECT

FROM restore as build-bullseye
ARG TARGETARCH
ARG PROJECT
ARG VERSION
ARG CONFIGURATION
ARG FRAMEWORK
ARG TRIMMED
ARG SELF_EXTRACT

RUN dotnet publish \
    --output publish \
    --configuration ${CONFIGURATION} \
    --framework ${FRAMEWORK} \
    --runtime linux-${TARGETARCH/amd/x} \
    --self-contained \
    -p:Version=${VERSION/v/} \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=${TRIMMED} \
    -p:IncludeNativeLibrariesForSelfExtract=${SELF_EXTRACT} \
    $PROJECT

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.2-bullseye-slim AS bullseye
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_gcServer=1

COPY --from=build-bullseye /build/publish/ /usr/local/share/myapp/
RUN ln -s /usr/local/share/myapp/myapp /usr/local/bin/myapp
ENTRYPOINT [ "myapp" ]

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.2-bullseye-slim AS alpine
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_gcServer=1

COPY --from=build-alpine /build/publish/ /usr/local/share/myapp/
RUN ln -s /usr/local/share/myapp/myapp /usr/local/bin/myapp
ENTRYPOINT [ "myapp" ]
