# Cluedin in Docker

This repo allows you to run CluedIn locally using Docker

## Requirements

- Windows version 1903 or greater
- Latest version of [Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows) (> 19.03.2)
- Docker [experimental features](https://docs.docker.com/docker-for-windows/#daemon) turned on 
- Docker set up to run [Windows containers](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers)
- Access to the private repositories inside the  [cluedin](https://hub.docker.com/u/cluedin/) DockerHub organization. You will require a Docker Hub account and request access from CluedIn; then use this account to do a ```docker login```.

## Setup with latest

If you want to run with the latest release, do not forget to pull the latest images from docker hub.

Run:

- `docker-compose pull`

## Usage

The *first time* you run the application you need to create some SSL certificates. As **administrator**, run ```./pki/Create-Certificates.ps1 -Trust```.

The application is run doing a via docker-compose You can then bring the application up doing

```
docker-compose up -d
```

The app should be available under [http://app.127.0.0.1.xip.io](http://app.127.0.0.1.xip.io).

You can then stop and start the stack, using the usual docker-compose commands

```
docker-compose stop # containers are turned off, state is maintained
docker-compose down # containers are removed, state is lost
```

You can remove the certificates running

```powershell
./pki/Remove-Certificates.ps1
```

### FAQ

#### How can I report a bug?

Please [create an issue in this repository](https://github.com/CluedIn-io/Simple-Docker-Deployment/issues/new). Ideally with a screenshot and/or an error message.

#### How can I be sure if I have access to private repositories inside the CluedIn DockerHub?

1. Visit the website: https://hub.docker.com/u/cluedin/.
2. Login to docker hub.
3. Verify if you can see `cluedin/cluedin-server`

If you do see  `cluedin/cluedin-server` ? All good.

If you do not see the repository `cluedin/cluedin-server` and you are a certified developers or a CluedIn employee, please contact [Raul](mailto:rjz@cluedin.net) or [Pierre](mailto:pid@cluedin.net).

### As a back-end developer guy, I want to test my local changes using the Simple Docker Deployment?

This repository is *NOT* meant to be used when working with the Back-End. The existing [CluedIn repo](https://github.com/CluedIn-io/CluedIn) already supports that scenario.

### As a front-end developer guy, I want to test local UI changes using the Simple Docker Deployment?

This is not the main premise of this repository, however, since the webapp when running natively usually works over port 3000, and the docker container is exposing port 80, there should not be any clash on your workstation.

For more information, please refer to the [CluedIn UI repository](https://github.com/CluedIn-io/CluedIn.Widget) on how to setup env variables correctly.

### Problem with networking (such as Windows container does not talk to Linux containers?)

If you have multiple active network, make sure to disable the unused one. It seems, for some reason, Docker seems to give a higher value to cable network (even if network cable is not plugged in) over Wifi.

On Win10 Pro: Control Panel\Network and Internet\Network Connections and disable the ones that are not used.

NOTE: Do not disable the 'vEthernet' and the 'vEthernet (Docker NAT)', those are virtual switch created by Hyper V to let your windows container talk to the outside world.
