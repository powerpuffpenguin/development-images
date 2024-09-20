DockerVarName="test-phantun"
function before_build
{
    local dir="$ProjectDir/data/0.6.0"
    if [ ! -d "$dir" ];then
        mkdir "$dir" -p
    fi
    local phantun="$dir/phantun"
    if [ ! -d "$phantun" ];then
        mkdir "$phantun" -p
    fi
    local z="$dir/z.zip"
    local url="https://github.com/dndx/phantun/releases/download/v0.6.0/phantun_x86_64-unknown-linux-musl.zip"

    local server="$phantun/phantun_server"
    if [ ! -f "$server" ];then
        if [ ! -f "$z" ];then
              curl -#Lo "$z" "$url"
        fi
        unzip -o "$z" -d "$phantun"
    fi
    local client="$phantun/phantun_server"
    if [ ! -f "$client" ];then
        if [ ! -f "$z" ];then
              curl -#Lo "$z" "$url"
        fi
        unzip -o "$z" -d "$phantun"
    fi
    pwd
    if [ -d phantun ];then
        rm phantun -rf
    fi
    cp "$phantun" phantun -r
}

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        --name "$2" \
        -d "$1"
}