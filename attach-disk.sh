DISK=$1
INSTANCE=$2

if [ -z "${DISK}" ]; then
	echo usage: attach-disk.sh <disk> [instance]
	exit 1
fi

if [ -z "${INSTANCE}" ]; then
	INSTANCE='spawn'
fi

gcloud compute instances attach-disk ${INSTANCE} --disk=${DISK} \
	--device-name=${DISK}
