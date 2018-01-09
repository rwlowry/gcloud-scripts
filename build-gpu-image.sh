IMAGE_NAME=$1

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME="gpu-base"
fi

GPU_BASE_INSTANCE_NAME=${IMAGE_NAME}-temporary-image-build

echo Creating instance ${GPU_BASE_INSTANCE_NAME} ...
gcloud beta compute instances create ${GPU_BASE_INSTANCE_NAME} \
--accelerator=type=nvidia-tesla-k80,count=1 --machine-type=n1-highmem-4 \
--image-project ubuntu-os-cloud --image-family ubuntu-1604-lts \
--maintenance-policy=TERMINATE

echo' Waiting for sshd to start... '
until gcloud compute --verbosity error ssh ${GPU_BASE_INSTANCE_NAME} -- echo ' instance started'; do
	echo -n .
done

echo Running setup script \'host-setup-gpu.sh\' ...
gcloud compute scp init/host-setup-gpu.sh ${GPU_BASE_INSTANCE_NAME}:~
gcloud compute ssh ${GPU_BASE_INSTANCE_NAME} -- sh host-setup-gpu.sh

echo Stopping instance ${GPU_BASE_INSTANCE_NAME} ...
gcloud compute instances stop ${GPU_BASE_INSTANCE_NAME}

echo Creating image ${IMAGE_NAME} ...
gcloud compute images create ${IMAGE_NAME} --source-disk=${GPU_BASE_INSTANCE_NAME}

echo Deleting instance ${GPU_BASE_INSTANCE_NAME} ...
gcloud compute instances delete ${GPU_BASE_INSTANCE_NAME}
