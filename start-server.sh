# Clean up old container
sudo docker rm -f occlum-server

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
	-e PCCS_URL=$PCCS_URL \
	-e ATTESTATION_SERVER_IP=$ATTESTATION_SERVER_IP \
	-e ATTESTATION_SERVER_PORT=$ATTESTATION_SERVER_PORT \
	piaolaidelangman/occlum-server:1.0 \
	bash