DockerVarName="test-ubuntu-22.04"
DockerVarUser="abc"

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        -it \
        --name "$2" \
        -e TZ=Asia/Shanghai \
        -e LANG=C.UTF-8 \
        -e LC_ALL=C.UTF-8 \
        -e SCREEN_MODE=1024x768x24 \
        -v /home/king/project:/home/abc/project \
        -p 8080:80 \
        "$1"
}