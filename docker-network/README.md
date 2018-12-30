
Read [official docker article](https://success.docker.com/article/networking)

== macvlan

image::https://success.docker.com/api/images/.%2Frefarch%2Fnetworking%2Fimages%2Fmacvlanarch.png[]

[source,bash]
----
docker network create -d macvlan --subnet 192.168.0.0/24 --gateway 192.168.0.1 -o parent=eth0 mvnet

docker run -itd --name c1 --net mvnet --ip 192.168.0.33 busybox sh

docker run -it --name c2 --net mvnet --ip 192.168.0.44 busybox sh
ping 192.168.0.33

docker rm -f -v c1 c2
docker network rm mvnet
----
