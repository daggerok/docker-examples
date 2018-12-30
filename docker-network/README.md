# docker network
Read [official docker article](https://success.docker.com/article/networking)

## macvlan

![](https://success.docker.com/api/images/.%2Frefarch%2Fnetworking%2Fimages%2Fmacvlanarch.png)

```bash
docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 mvnet

docker run -itd --name c1 --net mvnet --ip 192.168.0.3 busybox sh

docker run -it --name c2 --net mvnet --ip 192.168.0.4 busybox sh
ping 192.168.0.3

docker rm -f -v c1 c2
docker network rm mvnet
```

## vlan trunking with macvlan

![](https://success.docker.com/api/images/.%2Frefarch%2Fnetworking%2Fimages%2Ftrunk-macvlan.png)

```bash
docker network create -d macvlan --subnet 192.168.10.0/24 --gateway 192.168.10.1 -o parent=eth0.10 mvnet10
docker network create -d macvlan --subnet 192.168.20.0/24 --gateway 192.168.20.1 -o parent=eth0.20 mvnet20

docker run -itd --name c1 --net mvnet10 --ip 192.168.10.2 busybox sh

docker run -it --name c2 --net mvnet20 --ip 192.168.20.2 busybox sh

docker rm -f -v c1 c2
docker network rm mvnet10 mvnet20
```
