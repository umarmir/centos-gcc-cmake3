# centos-gcc-cmake3
Docker container build on top off the official Centos 7.5 container with gcc-5.3.1 and cmake-3.12.2

CentOS Linux release 7.5.1804
gcc-5.3.1
cmake-3.12.2

Tools/Libraries
bzip2 wget openssh-server passwd zlib libtool which epel-release texinfo zeromq-devel deltarpm Development Tools centos-release-scl devtoolset-4-gcc

Others
PHP 7.0.32, SSH

Run Container
Run the command to start container with ssh port 2200
$ docker run -d -t --name centos-gcc-cmake3 -p 2200:22 --restart always umir/centos-gcc-cmake3

SSH
for ssh directly into the container
$ ssh root@ip -p 2200
the default password is also root whiich you may change later.
