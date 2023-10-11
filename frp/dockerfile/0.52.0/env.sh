DockerVarName="test-frp"
DockerVarUser="frp"
function before_build
{
    local dir="root/opt/frp"
    if [[ ! -d "$dir" ]];then
        mkdir root/opt -p
        tar -zxvf ../../data/frp_0.52.0_linux_amd64.tar.gz -C "../../data/"
        mv ../../data/frp_0.52.0_linux_amd64 "$dir"
    fi
}
# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        --name "$2" \
        -e FRP_APP=s \
        -d "$1"
}