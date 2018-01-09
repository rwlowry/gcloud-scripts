INSTANCE_NAME=$1

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME=cpu-spawn
fi

MACHINE_TYPE='n1-standard-4'
ZONE='us-central1-c'
DISK_SIZE=64GB

echo Creating instance $1
gcloud beta compute instances create $1 \
	--machine-type=${MACHINE_TYPE} --image $2 --zone=${ZONE} \
	--boot-disk-size=${DISK_SIZE} \
	--preemptible --maintenance-policy=TERMINATE

echo -n 'Waiting for instance '
until gcloud compute --verbosity error ssh $1 -- echo ' instance started'; do
	echo -n .
done
