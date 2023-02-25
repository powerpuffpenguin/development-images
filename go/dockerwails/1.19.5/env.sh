DockerVarName="test-dev-wails-1.19.5"
DockerVarUser="dev"

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        --name "$2" \
        -e TZ=Asia/Shanghai \
        -e LANG=C.UTF-8 \
        -e LC_ALL=C.UTF-8 \
        -e PUID=1000 \
        -e PGID=1000 \
        -e AUTH=none \
        -e BIND_ADDR=0.0.0.0:9000 \
        -v /home/king/project:/home/dev/project \
        --network host \
        -u dev \
        -it "$1" bash
}