# fastdfs_storage
fastdfs_storage, base on fastdfs_base image. 

FastDFS version:5.08

It have config the storage.conf, which is tracker server is 172.17.0.2. If you want to modify this address. enter container by TTY. 

### Run 
````bash
docker run -p 8888:80 --name storage1 johndric/fastdfs-storage
````
### attach
````bash
docker attach storage1
vi /etc/fdfs/storage.conf
````
change tracker_server
````
tracker_server={your tracker server ip address}
````
