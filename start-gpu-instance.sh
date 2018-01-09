INSTANCE_NAME=$1
IMAGE_NAME=$2

if [ -z "${INSTANCE_NAME}" ]; then
	INSTANCE_NAME='spawn'
fi

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME='gpu-base'
fi

MACHINE_TYPE='n1-standard-4'
ACCELERATOR='type=nvidia-tesla-k80,count=1'
ZONE='us-central1-c'
DISK_SIZE=64GB

echo Creating instance ${INSTANCE_NAME} ...
gcloud beta compute instances create ${INSTANCE_NAME} --accelerator=${ACCELERATOR} \
	--machine-type=${MACHINE_TYPE} --image ${IMAGE_NAME} --zone=${ZONE} \
	--boot-disk-size=${DISK_SIZE} \
	--preemtible --maintenance-policy=TERMINATE

echo 'Waiting for instance ...'
until gcloud compute --verbosity error ssh $1 -- echo ' instance started'; do
	echo -n .
done
