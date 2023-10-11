FROM ubuntu:22.04 

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
	gosu --version; \
	gosu nobody true; \
    rm -rf /var/lib/apt/lists/* ;

Copy root/ /

RUN set -eux; \
    groupadd -r frp && useradd -r -g frp frp; \
    chown frp.frp /opt/frp -R

# 設置環境變量
ENV \
    # * c|C 運行 frpc
    # * s|S|* 運行 frps
	FRP_APP=s 

WORKDIR /opt/frp
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["default-command"]