DockerVarName="test-phantun"
function before_build
{
    local dir="$ProjectDir/data/20230206.0"
    if [ ! -d "$dir" ];then
        mkdir "$dir" -p
    fi
    local udp2raw="$dir/udp2raw"
    if [ ! -d "$udp2raw" ];then
        mkdir "$udp2raw" -p
    fi
    local z="$dir/z.tar.gz"
    local url="https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz"

    local file="$udp2raw/udp2raw_amd64"
    if [ ! -f "$file" ];then
        if [ ! -f "$z" ];then
              curl -#Lo "$z" "$url"
        fi
        tar -zxvf "$z" -C "$udp2raw"
    fi
    cp "$file" udp2raw_amd64
}

# * $1 images
# * $2 name
function docker_run
{
    sudo docker run --rm \
        --name "$2" \
        -d "$1"
}