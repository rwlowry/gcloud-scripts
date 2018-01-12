INSTANCE_NAME=$1
IMAGE_PROJECT=centos-cloud
IMAGE_FAMILY=centos-7

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME="gpu-base"
fi

echo Creating instance ${INSTANCE_NAME} ...
gcloud beta compute instances create ${INSTANCE_NAME} \
--accelerator=type=nvidia-tesla-k80,count=1 --machine-type=n1-highmem-4 \
--image-project ${IMAGE_PROJECT} --image-family ${IMAGE_FAMILY} \
--maintenance-policy=TERMINATE

echo 'Waiting for sshd to start... '
until gcloud compute --verbosity error ssh ${INSTANCE_NAME} -- echo ' instance started'; do
	echo -n .
done
