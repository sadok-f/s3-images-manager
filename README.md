s3-images-manager
=================

A Symfony application bases on FMElfinder Bundle (provides ElFinder integration) to manage images on S3 bucket.


# Installation and setup

## Instalation

Clone the project into your server.

```sh
    $ git clone https://github.com/sadok-f/s3-images-manager.git
```

CD into the folder and to build the image run:

```sh
    $ docker build -t s3-im .
```


Then run the container:

```sh
    $ docker run -t -d -i -p 8080:80 -v ~/s3-images-manager:/var/www/html --name s3-im-c s3-im
```


Now, only for the first time you need to run composer install inside the container (it'll ask you for AWS credentials, bucket name and region):

```sh
    $ docker exec -it s3-im-c composer install
```


Now you can navigate to your machine's IP in port 8080 (ex: http://192.168.99.100:8080/ ), default credentials is admin / admin