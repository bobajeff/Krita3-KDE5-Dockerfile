# Krita3-KDE5-Dockerfile
A set of Dockerfiles and scripts to set up a build/test environment for Krita3

#Build the kdework container

To set this up download the files create kdedev image:
``` bash
sudo docker build -t kdedev -f Dockerfile-kdedev1.2 /home/$USER
```
Then create the kdebuilddata data volume container:
``` bash
sudo docker run --name kdebuilddata -it kdedev
```

Then create the kdework container and mounting the to the kdebuilddata volume.
``` bash
sudo docker run --name kdework --rm --volumes-from kdebuilddata -it kdedev
```

#Compile KDE Frameworks

Inside the container run:
``` bash
./kdesrc-build extra-cmake-modules
./kdesrc-build phonon
./kdesrc-build frameworks
```

#Download and Compile Krita 3

Check out Krita-Next:
``` bash
cd ~/kf5/src/
git clone git://anongit.kde.org/calligra
git checkout krita-next
```

Build and Install Krita
``` bash
mkdir -p $HOME/kf5/build/calligra
cd $HOME/kf5/build/calligra
cmake -DCMAKE_INSTALL_PREFIX=$HOME/kf5/inst $HOME/kf5/src/calligra -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPRODUCTSET=KRITA

make -j4
make install
```

#Run it in VNC

If you're in the previous container exit out of it:
``` bash
exit
```

Now create the container with the $DISPLAY variable set:
``` bash
sudo docker run -e DISPLAY=:1 --name kdework --rm --volumes-from kdebuilddata -it kdedev
```

Inside the container run X server, VNC server and window manager:
``` bash
sudo Xvfb $DISPLAY +extension GLX +render -screen 0 1024x780x24 &
sudo x11vnc -display $DISPLAY &
openbox &
```

On the host/client machine run find the ip address of the kdework container:
``` bash
sudo docker inspect kdework
```

Then connect to it with a VNC client (put the ipaddress from the previous step instead of [ipaddress]):
``` bash
vncviewer [ipaddress]:5900
```

Now inside the container you can run Krita:
``` bash
krita &
```
