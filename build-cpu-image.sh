IMAGE_NAME=$1

if [ -z ${IMAGE_NAME} ]; then
	IMAGE_NAME="cpu-base"
fi

CPU_BASE_INSTANCE_NAME=${IMAGE_NAME}-temporary-image-build

echo Creating instance ${CPU_BASE_INSTANCE_NAME} ...
gcloud compute instances create ${CPU_BASE_INSTANCE_NAME} \
	--machine-type n1-standard-2  --image-project ubuntu-os-cloud \
	--image-family=ubuntu-1604-lts --maintenance-policy=TERMINATE

sh create-gpu-instance.sh ${CPU_BASE_INSTANCE_NAME} ubuntu-os-cloud ubuntu-1604-lts

echo 'Waiting for sshd to start ..'
until gcloud compute --verbosity error ssh ${CPU_BASE_INSTANCE_NAME} -- echo ' instance started'; do
	echo -n .
done

echo Running setup script ...
gcloud compute scp init/host-setup-cpu.sh ${CPU_BASE_INSTANCE_NAME}:~
gcloud compute ssh ${CPU_BASE_INSTANCE_NAME} -- sh host-setup-cpu.sh

echo Stopping instance ...
gcloud compute instances stop ${CPU_BASE_INSTANCE_NAME}

echo Creating image ...
gcloud compute images create ${IMAGE_NAME} --source-disk=${CPU_BASE_INSTANCE_NAME}

echo Deleting instance ...
gcloud compute instances delete ${CPU_BASE_INSTANCE_NAME}
