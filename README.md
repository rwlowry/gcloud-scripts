These are just some scripts I've been using to automate gcloud server creation. They are
really just for conveniece, because gcloud commands can get very verbose! They are really very simple,
and I have tried my best to keep variables at the top of each file to change common parameters.

Just read the scripts before you run them! You can change the zone and machine types and all that in
the scripts. Just about the only options they take are instance names.

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
sh ./centos7-cuda-drivers.sh
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
