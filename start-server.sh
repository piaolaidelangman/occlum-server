# Clean up old container
sudo docker rm -f bigdl-ppml-trusted-big-data-ml-scala-occlum

# Run new command in container
sudo docker run -itd \
	--net=host \
	--name=occlum-server \
	--cpuset-cpus 10-14 \
	--device=/dev/sgx/enclave \
	--device=/dev/sgx/provision \
	-v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
	-e LOCAL_IP=$LOCAL_IP \
	-e SGX_MEM_SIZE=8GB \
	-e SGX_THREAD=512 \
	-e SGX_HEAP=512MB \
	-e SGX_KERNEL_HEAP=1GB \
	piaolaidelangman/occlum-server:1.0 \
	bash