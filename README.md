# Run external docker registry in vagrant (with x509/Basic Authentication)

* Required
```
	- install vagrant 4.3
	https://www.virtualbox.org/wiki/Download_Old_Builds_4_3
	http://download.virtualbox.org/virtualbox/4.3.34/VirtualBox-4.3.34-104062-OSX.dmg
	cf. vagrant box add ubuntu/trusty64
	
	- Need to add 192.168.82.171 registry.tz.com into /etc/hosts
```

* Run		
```
	bash build.sh
```	
	
* Workflow
```
	1. make cert before making vagrant VMs (x509/Basic Authentication for docker registry)
	2. make docker registry VM (registry.sh)
		install docker
		make test docker image
		install nginx
		update certs
		make docker-registry
	3. push test image on registry server for test
		make test image
		push test image to external server
	4. make client registry VM (client.sh)
		install docker
		update certs
		pull test image from external server
```

* Check out docker client
```
	* docker registry
	http://192.168.82.170:8080/
	* docker client
	http://192.168.82.171:8080/
	Username: admin Password: shipyard
```

* Use docker registry on vagrant from other machine
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
		sudo docker pull registry.tz.com:5000/testnginx:0.1
		sudo docker images
```

* Test app deploy on docker client
```
	1. check out on webpage
		- Nginx: http://192.168.82.171:8000/
		- Node.js: http://192.168.82.171:3000/
	2. look into log
		vagrant ssh client
		docker ps -a | grep /test
		4215b414afac        registry.tz.com:5000/testnode:0.1    "/usr/local/bin/node "   node3
		df4a82a9810e        registry.tz.com:5000/testnginx:0.1   "nginx"                  nginx3
		- Nginx: sudo docker logs -f -t 4215b414afac
		- Node.js: sudo docker logs -f -t df4a82a9810e
	3. go to the container
		- Nginx: sudo docker exec -i -t 4215b414afac /bin/bash
		- Node.js: sudo docker exec -i -t df4a82a9810e /bin/bash
```


