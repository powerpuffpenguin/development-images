DockerVarName="test-baidudisk-4.17.7"
DockerVarUser="dev"

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        --name "$2" \
        -itudev \
        -e TZ=Asia/Shanghai \
        -e LANG=C.UTF-8 \
        -e LC_ALL=C.UTF-8 \
        -e PUID=1000 \
        -e PGID=1000 \
        -e "DISPLAY=$DISPLAY" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/king/project:/home/dev/project \
        "$1" bash
}