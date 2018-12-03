# Cluedin in Docker

This repo allows you to run CluedIn locally using Docker

## Requirements

- [Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows)
- Access to the private repositories inside the  [cluedin](https://hub.docker.com/u/cluedin/) DockerHub organization. You will require a Docker Hub account and request access from CluedIn; then use this account to do a ```docker login```.

## Usage

As administrator, run ```create.ps1```. The app should be available under [http://app.cluedin.test](http://app.cluedin.test).

You can then stop and start the stack, using the ```start.ps1``` and ```stop.ps1``` scripts. Data is persisted.

You can remove all traces of cluedin, including all the data, invoking the ```remove.ps1``` script.

### Extra info
The ```create.ps1``` script will:

1. Crate a self-signed cert for https communication and add it as a trusted cert
1. Switch to Linux Containers
1. Start up all the depdencies (redis, neo4j, elasticsearch, sqlserver) and the CluedIn webapp
1. Switch to Windows Containers
1. Start up the CluedIn backend Server
1. Add two entries to your hosts file: 
    1. Add 'app.cluedin.test' and 'cluedin.cluedin.test' mapped to 127.0.0.1
    1. Add 'server.cluedin.test' to the IP of the docker container running the CluedIn backend server

The script takes two optional parameters: 

- -ServerImageTag: Override the image tag for the CluedIn backend server
- -EnvVarsFile: Pass a different file with environment variables for the backend server

### FAQ

#### How can I report a bug?

Please [create an issue in this repository](https://github.com/CluedIn-io/Simple-Docker-Deployment/issues/new). Ideally with a screenshot and/or an error message.

#### How can I be sure if I have access to private repositories inside the CluedIn DockerHub?

1. Visit the website: https://hub.docker.com/u/cluedin/.
2. Login to docker hub.
3. Verify if you can see `cluedin/cluedin-server`

If you do see  `cluedin/cluedin-server` ? All good.

If you do not see the repository `cluedin/cluedin-server` and you are a certified developers or a CluedIn employee, please contact [Raul](mailto:rjz@cluedin.net) or [Pierre](mailto:pid@cluedin.net).

