DockerVarName="test-wine-22.04"
DockerVarUser="dev"

# * $1 images
# * $2 name
function docker_run
{
    #   --privileged 
    
    sudo docker run --rm \
        -it \
        -u dev \
        --name "$2" \
        --cpus 2 \
        -m 2g \
        -e "DISPLAY=$DISPLAY" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /dev/dri:/dev/dri \
        -v /home/king/project:/home/dev/project \
        "$1" bash
}