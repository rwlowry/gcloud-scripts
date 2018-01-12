INSTANCE_NAME=$1
IMAGE_NAME=$2

if [ -z "${INSTANCE_NAME}" ]; then
	INSTANCE_NAME='spawn'
fi

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME='cpu-base'
fi

MACHINE_TYPE='n1-standard-4'
ZONE='us-central1-c'
DISK_SIZE=64GB

echo Creating instance ${INSTANCE_NAME}
gcloud compute instances create ${INSTANCE_NAME} \
	--machine-type=${MACHINE_TYPE} --image ${IMAGE_NAME} --zone=${ZONE} \
	--boot-disk-size=${DISK_SIZE} \
	--preemptible --maintenance-policy=TERMINATE

echo 'Waiting for instance ...'
until gcloud compute --verbosity error ssh ${INSTANCE_NAME} -- echo ' instance started'; do
	echo -n .
done
