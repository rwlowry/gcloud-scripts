These are just some scripts I've been using to automate gcloud server creation. They are
really just for conveniece, because gcloud commands can get very verbose! They are really very simple,
and I have tried my best to keep variables at the top of each file to change common parameters
Just read the scripts before you run them! You can change the zone and machine types in
the scripts. Generally, the only options they take are instance and image names.

The scripts for starting instances default to preemptible instances. My main use case is starting up 
cloud GPU servers on the cheap for machine learning studies. I generally keep a small persistent disk
with any data I need to keep around and attach it to these instances, so I won't lose any data if they
do get preempted.

# Creating a server image:

`start-image-host.sh` is a basic script to create an instance from public base
images to use as a base to make your own custom images.

For example:

### On your local host run:

````
sh host/start-image-host.sh [instance-name]
gcloud compute scp host/centos7-*.sh instance:~
gcloud compute ssh instance
````
### Then on the new instance run:

````
sh ./centos7-cuda-drivers.sh
sh ./centos7-docker-ce.sh
sh ./centos7-nvidia-docker.sh
````

NOTE: to make a cpu only docker image, just run `centos7-docker-ce.sh`

You now have system capable of running GPU enabled docker images! You can test this 
by running: 

````
nvidia-docker run --rm nvidia/cuda nvidia-smi
````

At this point you could add more packages, clean up the package files, maybe remove that docker image, and anything else you want default on your machines. Then shut down the instances and create an image file to start servers from:

````
gcloud compute images create <image-name> --source-disk <instance-name>
````

And now you are ready to start on demand docker instances with GPU support!

I included a couple more scripts `start-gpu-instance.sh` and `start-cpu-instance.sh` as examples. They just start a preemptible instance from an image file and then keep checking ssh until the instance is started. I generally have a persistent partition that I store my data on and attach to the instance when it starts up.