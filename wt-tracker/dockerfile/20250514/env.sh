DockerVarName="test-wt-tracker-20250514"
DockerVarUser="dev"
function before_build
{
    local dir="$ProjectDir/temp/20250514"
    if [ ! -d "$dir" ];then
        mkdir "$dir" -p
    fi
    mkdir root -p
    if [ ! -f root/app/package.json ];then

        local app="$dir/app"
        if [ ! -f "$app/package.json" ];then
            local source="$dir/app.zip"
            if [ ! -f "$source" ];then
                curl -#Lo "$source" 'https://github.com/Novage/wt-tracker/archive/refs/heads/main.zip'
            fi
            unzip -o "$source" -d "$dir"
            mv "$dir/wt-tracker-main" "$app"
        fi
        mv "$app" root/
    fi

    if [ ! -f root/app/config.json ];then
        cp "$ProjectDir/config.json" root/app/config.json
    fi
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
        --network host \
        "$1" -d
}