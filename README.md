These are just some scripts I've been using to automate gcloud server creation.

## Creating a server image:

`start-image-host.sh` is a basic script to create an instance from public base
images to use as a base to make your own custom images.

For example:

````
sh host/start-image-host.sh [instance-name]
gcloud compute scp host/centos7-*.sh instance:~
gcloud compute ssh instance
````
Then on the instance:

````
sh ./centos7-cuda.sh
sh ./centos7-docker-ce.sh
sh ./centos7-nvidia-docker.sh

````

You now have system capable of running GPU enabled docker images! You can test this 
by running: 

````
nvidia-docker run --rm nvidia/cuda nvidia-smi
````

You can create an image from that instance (after stopping it) by running:

````
gcloud compute images create <image-name> --source-disk <instance-name>
````

And now you are ready to start on demand docker instances with GPU support!
