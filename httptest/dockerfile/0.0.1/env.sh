DockerVarName="test-httptest-0.0.1"
DockerVarUser="dev"
function before_build
{
    cp "$ProjectDir/httptest" httptest.temp
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
        -e BIND_ADDR=0.0.0.0:9000 \
        --network host \
        -it "$1" sh
        # -d "$1"
}