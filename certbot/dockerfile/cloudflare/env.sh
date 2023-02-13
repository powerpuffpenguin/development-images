DockerVarName="test-certbot-cloudflare"
DockerVarUser="root"

# * $1 images
# * $2 name
function docker_run
{
    local dir=$(cd `dirname $BASH_SOURCE` && pwd)
    # sudo docker run --rm \
    #     --name "$2" \
    #     -e LANG=C.UTF-8 \
    #     -e LC_ALL=C.UTF-8 \
    #     -v "$ProjectDir/dockerfile/cloudflare/root/scripts:/scripts" \
    #     --network host \
    #     -it  "$1" bash

    sudo docker run --rm \
        --name "$2" \
        -e LANG=C.UTF-8 \
        -e LC_ALL=C.UTF-8 \
        -e EMAIL="$EMAIL" \
        -e API_TOKEN="$API_TOKEN" \
        -e CERTBOT_DOMAIN="$CERTBOT_DOMAIN" \
        -v "$dir/data:/data" \
        -v "$dir/letsencrypt:/etc/letsencrypt" \
        --network host \
        "$1" auth.sh
}