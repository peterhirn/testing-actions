
$IMAGE="peter87623/tmp"

#docker buildx build --no-cache --progress plain --platform linux/amd64,linux/arm64,linux/arm/v7 -t ph/test:latest .
#docker buildx bake --progress plain -f docker-bake.hcl alpine bullseye
docker buildx bake --progress plain -f docker-bake.hcl

#docker buildx imagetools inspect ph/test:latest

#docker buildx build --no-cache --progress plain --platform linux/amd64 -t ph/test:latest .
#docker buildx build --no-cache --progress plain --platform linux/arm/v7 -t ph/test:latest .

