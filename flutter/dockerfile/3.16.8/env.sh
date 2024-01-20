DockerVarName="test-dev-flutter-3.16.8"
DockerVarUser="dev"
function before_build
{
    cp "$ProjectDir/data/docker-entrypoint.sh" docker-entrypoint.temp
}

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
        --privileged \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        --network host \
        -p 9000:9000 \
        -d "$1"

        
        # -v /home/king/Android/Sdk:/data/android:ro \
        
}