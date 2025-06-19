DockerVarName="test-signal-20250618"
DockerVarUser="dev"

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        -itu "$DockerVarUser" \
        --name "$2" \
        -e TZ=Asia/Shanghai \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        -e USE_PROXY="socks5	127.0.0.1	1080" \
        --cap-add=SYS_ADMIN \
        "$1" bash
}