curl -O http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-9.1.85-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel7-9.1.85-1.x86_64.rpm
sudo yum clean all
sudo yum install -y cuda-drivers
