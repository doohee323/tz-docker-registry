# run external docker registry in vagrant (with x509/Basic Authentication)

* required
```
	- install vagrant 4.3
	https://www.virtualbox.org/wiki/Download_Old_Builds_4_3
	http://download.virtualbox.org/virtualbox/4.3.34/VirtualBox-4.3.34-104062-OSX.dmg
	cf. vagrant box add ubuntu/trusty64
		vagrant box add precise64 http://files.vagrantup.com/precise64.box
```

* run		
```
	bash build.sh
```	
	
* workflow
```
	1. make cert before making vagrant VMs (x509/Basic Authentication for docker registry)
	2. make docker registry VM (registry.sh)
		update certs
		install docker
		make test docker image
		install nginx
		make docker-registry / domain-registry
		push test image to external server with https
	3. make client registry VM (client.sh)
		update certs
		install docker
		pull test image from external server with https
```

* check out docker client
```
	* docker registry
	http://192.168.82.170:8080/
	* docker client
	http://192.168.82.171:8080/
	Username: admin Password: shipyard
```

* use docker registry on vagrant from other machine
```
  - On host server of vagrant
	1. virtualbox network setting 
		- Adapter 1
			- Attached to: Bridged Adapter
			- Name: eth0
			- Promiscuous mode: Allow VMs
	2. open host server firewall 	
		ex) sudo ufw allow 5000/tcp
  - On PC to use docker registry
    1. register VM's external IP as domain in hosts
    	ex) vi /etc/hosts
    		172.30.12.125	registry.tz.com
	2. get domain.crt from the host server of vagrant
		sudo cp domain.crt /usr/share/ca-certificates/
		echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
		sudo update-ca-certificates
	3. test
		sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000
		sudo docker pull registry.tz.com:5000/test:0.1
		sudo docker images
```