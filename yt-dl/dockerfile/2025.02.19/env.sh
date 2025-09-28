DockerVarName="test-yt-dl-22.04"
DockerVarUser="dev"

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        -itu "$DockerVarUser" \
        --name "$2" \
        -e TZ=Asia/Shanghai \
        -v /home/king/project:/home/abc/project \
        "$1" bash
}