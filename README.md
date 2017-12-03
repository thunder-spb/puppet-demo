# dev-pack
##description
Dev VMs pack

##tools versions installed
 - CentOS 6.6 x86_64 w/ puppet
 - git, wget, unzip, midnight commander latest versions
 - Jenkins 2.73.3 LTS - oracle jdk8
 - buildhost - maven versions: 3.0.5, 3.3.9 (default 3.3.9), ansible, oracle jdk8 1.8.0_151

##prerequestives
vagrant 1.8+
virtualbox 5+ at least for windows10

##usage
clone and run

Start all VMs
```sh
vagrant up jenkins_server gocd_server agent builder
```

Start Jenkins server (IP: 10.0.0.30:8080)

```sh
vagrant up jenkins_server
```

Start buildhost (IP: 10.0.0.35)

```sh
vagrant up builder
```
## running puppet apply from console:
**for builder instance**
```sh
FACTER_environment='vagrant' FACTER_category='builder' puppet apply --modulepath '/vagrant/puppet/modules:/etc/puppet/modules' --hiera_config=/vagrant/puppet/hiera.yaml --detailed-exitcodes --manifestdir /vagrant/puppet/manifests /vagrant/puppet/manifests/builder.pp
```
**for Jenkins instance**
```sh
FACTER_environment='vagrant' FACTER_category='jenkins' puppet apply --modulepath '/vagrant/puppet/modules:/etc/puppet/modules' --hiera_config=/vagrant/puppet/hiera.yaml --detailed-exitcodes --manifestdir /vagrant/puppet/manifests /vagrant/puppet/manifests/jenkins_server.pp
```
