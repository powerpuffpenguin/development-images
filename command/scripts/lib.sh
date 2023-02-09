# * $1 flag
# * $2 message
function my_PrintFlag
{
    printf "  %-20s %s\n" "$1" "$2"
}

# * $1 dirname
function my_CheckDockerfile
{
    local file
    for file in ${dockerfile[@]}
    do
        if [[ "$1" == "$file" ]];then
            return 0
        fi
    done
    echo "not found version $1"
    return 1
}
TEST=0
# * $1 dirname
function my_LoadENV {
    TAG="$1"
    
    # docker run name
    DockerVarName=""
    # docker run shell
    DockerVarShell="bash"
    # docker exec user
    DockerVarUser="root"
    if [[ -f "$Dockerfile/$1/env.sh" ]];then
        source "$Dockerfile/$1/env.sh"
    fi

    if [[ "$DockerVarName" == "" ]];then
        DockerVarName="test-$Docker"
    fi
}
function before_build
{
    _s="before_build"
}
function after_build {
    _s="after_build"
}

# * $1 dirname
function my_DockerBuild
{
    my_CheckDockerfile "$1"

    echo build "$1"
    my_LoadENV "$1"

    cd "$Dockerfile/$1"
    before_build
    echo  ' ! sudo docker build \'
    echo '      --network host \'
    echo "      -t '$Docker:$TAG' \\"
    echo "      '$Dockerfile/$1' \\"

    if [[ $TEST == 0 ]];then
        sudo docker build \
            --network host \
            -t "$Docker:$TAG" \
            .
    fi
    after_build
}

function my_DockerImages
{
    if [[ "$1" == "" ]];then
        echo "sudo docker images | grep -w \"$Docker\""
        if [[ $TEST == 0 ]];then
            sudo docker images | grep -w "$Docker "
        fi
    else
        echo "sudo docker images | grep -w \"$Docker \" | egrep -w \"$1\""
        if [[ $TEST == 0 ]];then
            sudo docker images | grep -w "$Docker " | egrep -w "$1"
        fi
    fi
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
        "$1"
}