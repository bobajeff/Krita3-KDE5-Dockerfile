# Krita3-KDE5-Dockerfile
A set of Dockerfiles and scripts to set up a build/test environment for Krita3

#Build the kdework container

To set this up: Download the files then create kdedev image with:
``` bash
sudo docker build -t kdedev -f Dockerfile-kdedev .
```
Then create the kdebuilddata data volume container:
``` bash
sudo docker create -v /home/kdedev/ --name kdebuilddata -it kdedev
```

Then create the kdework container and mounting the to the kdebuilddata volume.
``` bash
sudo docker run --name kdework --rm --volumes-from kdebuilddata -it kdedev
```
#Compile Qt5

Inside the container `cd` to the kf5 directory:
``` bash
cd kf5/
```
Then clone then compiles qt from git:
``` bash
git clone git://code.qt.io/qt/qt5.git --branch 5.5
cd qt5
./init-repository
./configure -prefix $PWD/qtbase -opensource -confirm-license -nomake tests -nomake examples -dbus \
  -no-separate-debug-info -xcb -system-xcb -qpa xcb -no-gtkstyle -release -force-debug-info -reduce-relocations \
  -optimized-qmake
make
```

#Compile KDE Frameworks

Change back to the home directory:
``` bash
cd
```

Clone kdesrc-build:
``` bash
git config --global url."git://anongit.kde.org/".insteadOf kde: && \
    git config --global url."ssh://git@git.kde.org/".pushInsteadOf kde: && \
    mkdir -p extragear/utils && \
    git clone kde:kdesrc-build extragear/utils/kdesrc-build && \
    ln -s extragear/utils/kdesrc-build/kdesrc-build .
```

Then run kdesrc-build:
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
cd calligra/
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

From the host machine. Find the ip address of the kdework container and connect to it with a VNC client:
``` bash
vncviewer $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' kdework):5900
```
*If the previous command didn't work you most likely have a version of Docker with different json structure. You'll need to manually find the ipaddress via 'docker inspect kdework' and start your client with that plus ':5900'*

Now inside the container you can run Krita:
``` bash
krita &
```
![alt tag](https://cloud.githubusercontent.com/assets/8573364/10269716/596e5718-6aa4-11e5-9fb4-59c50f44bcef.png)

#Access the volume data from the host

To get the location of the files in your data volume container run:
``` bash
sudo docker inspect --format '{{ index .Volumes "/home/kdedev" }}' kdebuilddata
```
*(again if this doesn't work you'll have to manually find the location via docker inspect)*

You can open it up in a filemanager via gksu for example:
``` bash
gksu pcmanfm $(sudo docker inspect --format '{{ index .Volumes "/home/kdedev" }}' kdebuilddata)
```
