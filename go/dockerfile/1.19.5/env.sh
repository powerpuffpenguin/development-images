DockerVarName="test-dev-go-1.19.5"
DockerVarUser="dev"
function before_build
{
    cp "$ProjectDir/data/docker-entrypoint.sh" docker-entrypoint.temp
}

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run -it --rm \
        --name "$2" \
        -e TZ=Asia/Shanghai \
        -e LANG=C.UTF-8 \
        -e LC_ALL=C.UTF-8 \
        -e PUID=1001 \
        -e PGID=1002 \
        -e AUTH=none \
        -e BIND_ADDR=0.0.0.0:80 \
        -d "$1"
}