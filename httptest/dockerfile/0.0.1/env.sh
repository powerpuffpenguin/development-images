DockerVarName="test-httptest-0.0.1"
DockerVarUser="dev"
function before_build
{
    if  [[ -d root ]];then
        rm root -rf
    fi
    mkdir root/usr/local/bin -p
    cp "$ProjectDir/httptest" root/usr/local/bin/
    cp "$ProjectDir/test.crt" root/
    cp "$ProjectDir/test.key" root/
    
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
        -p 9000:80 \
        -p 9001:443 \
        -d "$1"
}