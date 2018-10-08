# ---- Base Node ----                                                           
FROM centos 
WORKDIR /
############ Installations ############                                                  
RUN yum -y install bzip2 wget openssh-server passwd zlib* libtool which epel-release deltarpm    
RUN yum groupinstall -y "Development Tools"                                     
RUN yum -y update 

########### Directries Needed ############
### For SSH
RUN mkdir /var/run/sshd

########### SSH ############
RUN echo 'root:root' | chpasswd                                 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' 
RUN ssh-keygen -A 
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' -y
EXPOSE 22

########### g++ 5.3.1 ############
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-4-gcc*
RUN mv /usr/bin/gcc /usr/bin/gccold && mv /usr/bin/g++ /usr/bin/g++old && mv /usr/bin/c++ /usr/bin/c++old
RUN ln -s /opt/rh/devtoolset-4/root/usr/bin/gcc /usr/bin/gcc
RUN ln -s /opt/rh/devtoolset-4/root/usr/bin/g++ /usr/bin/g++
RUN ln -s /usr/bin/g++ /usr/bin/c++
RUN ln -s /opt/rh/devtoolset-4/root/usr/lib /usr/local/lib
RUN ln -s /opt/rh/devtoolset-4/root/usr/lib64 /usr/local/lib64
RUN gcc --version
                                            
############ cmake3 ############
RUN echo '[group_kdesig-cmake3_EPEL]' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'name=Copr repo for cmake3_EPEL owned by @kdesig' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'baseurl=https://copr-be.cloud.fedoraproject.org/results/@kdesig/cmake3_EPEL/epel-7-$basearch/' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'type=rpm-md' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'skip_if_unavailable=True' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'gpgcheck=1' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'gpgkey=https://copr-be.cloud.fedoraproject.org/results/@kdesig/cmake3_EPEL/pubkey.gpg' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'repo_gpgcheck=0' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'enabled=1' >> /etc/yum.repos.d/cmake3.repo
RUN echo 'enabled_metadata=1' >> /etc/yum.repos.d/cmake3.repo
RUN echo alias cmake='cmake3' >> /etc/profile.d/others.sh
RUN yum install -y cmake3 

########### ENV ############
ENV cmake=cmake3
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH    
                                          
########### Start ############                                      
CMD ["/usr/sbin/sshd", "-D"]
