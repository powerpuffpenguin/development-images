#!/usr/bin/env bash
set -e

if [[ "$Command" == "" ]];then
    Command=`basename "$BASH_SOURCE"`
fi

function print_flag
{
    printf "  %-20s %s\n" "$1" "$2"
}
command_help(){
    echo "certbot docker auto scripts"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo
    echo "Flags:"
    print_flag "    --renew bool" "renew or init" 
    print_flag "-s, --save string" "certificate storage folder"
    print_flag "-d, --domain string" "domain name to apply for certificate"
    print_flag "    --token string" "cloudflare api token"
    print_flag "    --email string" "cloudflare api email"
    print_flag "    --image string" "docker image (default \"king011/certbot:cloudflare\")" 
    print_flag "-n, --name bool" "docker run name prefix (default \"letsencrypt-cloudflare\")"
    print_flag "-t, --test bool" "prints the instructions to be executed, but does not execute them"
    print_flag "-h, --help bool" "help for $Command"
}


main(){
    local args=`getopt -o hts:d:n: --long help,test,renew,image:,email:,token:,save:,domain:,name: -n "$Command" -- "$@"`
    eval set -- "${args}"
    local test=0
    local renew=0
    local image='king011/certbot:cloudflare'
    local email=""
    local token=""
    local save=""
    local domain=""
    local name="letsencrypt-cloudflare"
    while true
    do
        case "$1" in
            -h|--help)
                command_help
                return $?
            ;;
            -t|--test)
                test=1
                shift
            ;;
            --renew)
                renew=1
                shift
            ;;
            --image)
                image=$2
                shift 2
            ;;
            --email)
                email=$2
                shift 2
            ;;
            --token)
                token=$2
                shift 2
            ;;
            -s|--save)
                save=$2
                shift 2
            ;;
            -d|--domain)
                domain=$2
                shift 2
            ;;
            -n|--name)
                name=$2
                shift 2
            ;;
            --)
                shift
                break
            ;;
            *)
                echo Error: unknown flag "'$1'" for "$Command"
                echo "Run '$Command --help' for usage."
                return 1
            ;;
        esac
    done
    if [[ "$domain" == "" ]];then
        echo "$Command -d, --domain must be specified"
        return 2
    fi
    if [[ "$save" == "" ]];then
        echo "$Command -s, --save must be specified"
        return 2
    fi
    if [[ "$email" == "" ]];then
        echo "$Command --email must be specified"
        return 2
    fi
    if [[ "$token" == "" ]];then
        echo "$Command --token must be specified"
        return 2
    fi
    if [[ "$name" == "" ]];then
        name="letsencrypt-cloudflare"
    fi

    # print
    if [[ `id -u` == 0 ]];then
        if [[ $renew == 1 ]];then
            echo "docker run --rm \\"
            echo "  --name \"$name-renew\" \\"
            echo "  -e EMAIL=\"$email\" \\"
            echo "  -e API_TOKEN=\"$token\" \\"
            echo "  -e CERTBOT_DOMAIN=\"$domain\" \\"
            echo "  -v  \"$save/data:/data\" \\"
            echo "  -v  \"$save/letsencrypt:/etc/letsencrypt\" \\"
            echo "  -v  \"$save/log:/var/log/letsencrypt\" \\"
            echo "  \"$image\" renew"
        else
            echo "docker run --rm \\"
            echo "  --name \"$name-auth\" \\"
            echo "  -e EMAIL=\"$email\" \\"
            echo "  -e API_TOKEN=\"$token\" \\"
            echo "  -e CERTBOT_DOMAIN=\"$domain\" \\"
            echo "  -v  \"$save/data:/data\" \\"
            echo "  -v  \"$save/letsencrypt:/etc/letsencrypt\" \\"
            echo "  -v  \"$save/log:/var/log/letsencrypt\" \\"
            echo "  \"$image\" auth.sh"
        fi
    else
        if [[ $renew == 1 ]];then
            echo "sudo docker run --rm \\"
            echo "  --name \"$name-renew\" \\"
            echo "  -e EMAIL=\"$email\" \\"
            echo "  -e API_TOKEN=\"$token\" \\"
            echo "  -e CERTBOT_DOMAIN=\"$domain\" \\"
            echo "  -v  \"$save/data:/data\" \\"
            echo "  -v  \"$save/letsencrypt:/etc/letsencrypt\" \\"
            echo "  -v  \"$save/log:/var/log/letsencrypt\" \\"
            echo "  \"$image\" renew"
        else
            echo "sudo docker run --rm \\"
            echo "  --name \"$name-auth\" \\"
            echo "  -e EMAIL=\"$email\" \\"
            echo "  -e API_TOKEN=\"$token\" \\"
            echo "  -e CERTBOT_DOMAIN=\"$domain\" \\"
            echo "  -v  \"$save/data:/data\" \\"
            echo "  -v  \"$save/letsencrypt:/etc/letsencrypt\" \\"
            echo "  -v  \"$save/log:/var/log/letsencrypt\" \\"
            echo "  \"$image\" auth.sh"
        fi
    fi
    if [[ $test == 1 ]];then
        return 0
    fi
    # exec
    if [[ `id -u` == 0 ]];then
        if [[ $renew == 1 ]];then
            docker run --rm \
              --name "$name-renew" \
              -e EMAIL="$email" \
              -e API_TOKEN="$token" \
              -e CERTBOT_DOMAIN="$domain" \
              -v  "$save/data:/data" \
              -v  "$save/letsencrypt:/etc/letsencrypt" \
              -v  "$save/log:/var/log/letsencrypt" \
              "$image" renew
        else
            docker run --rm \
              --name "$name-auth" \
              -e EMAIL="$email" \
              -e API_TOKEN="$token" \
              -e CERTBOT_DOMAIN="$domain" \
              -v  "$save/data:/data" \
              -v  "$save/letsencrypt:/etc/letsencrypt" \
              -v  "$save/log:/var/log/letsencrypt" \
              "$image" auth.sh
        fi
    else
         if [[ $renew == 1 ]];then
            sudo docker run --rm \
              --name "$name-renew" \
              -e EMAIL="$email" \
              -e API_TOKEN="$token" \
              -e CERTBOT_DOMAIN="$domain" \
              -v  "$save/data:/data" \
              -v  "$save/letsencrypt:/etc/letsencrypt" \
              -v  "$save/log:/var/log/letsencrypt" \
              "$image" renew
        else
            sudo docker run --rm \
              --name "$name-auth" \
              -e EMAIL="$email" \
              -e API_TOKEN="$token" \
              -e CERTBOT_DOMAIN="$domain" \
              -v  "$save/data:/data" \
              -v  "$save/letsencrypt:/etc/letsencrypt" \
              -v  "$save/log:/var/log/letsencrypt" \
              "$image" auth.sh
        fi
    fi
}
main "$@"
