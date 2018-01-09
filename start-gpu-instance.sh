IMAGE_NAME=$1

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME='gpu-spawn'
fi

MACHINE_TYPE='n1-standard-4'
ACCELERATOR='type=nvidia-tesla-k80,count=1'
ZONE='us-central1-c'

echo Creating instance $1
gcloud beta compute instances create $1 --accelerator=${ACCELERATOR} \
	--machine-type=${MACHINE_TYPE} --image $2 --zone=${ZONE} \
	--preemtible --maintenance-policy=TERMINATE

echo 'Waiting for instance ...'
until gcloud compute --verbosity error ssh $1 -- echo ' instance started'; do
	echo -n .
done
