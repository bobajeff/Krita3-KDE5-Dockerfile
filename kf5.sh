export KF5=$HOME/kf5/inst
 
export QTDIR=$HOME/kf5/qt5/qtbase
export CMAKE_PREFIX_PATH=$KF5:$QTDIR:$CMAKE_PREFIX_PATH
 
export XDG_DATA_DIRS=$KF5/share:$XDG_DATA_DIRS:/usr/share
export XDG_CONFIG_DIRS=$KF5/etc/xdg:$XDG_CONFIG_DIRS:/etc/xdg
export XDG_DATA_HOME=$KF5/../local5/share
export XDG_CONFIG_HOME=$KF5/../config5
export XDG_CACHE_HOME=$KF5/../cache5
 
export PATH=$KF5/bin:$QTDIR/bin:$PATH
 
export QT_PLUGIN_PATH=$KF5/lib/plugins:$KF5/lib64/plugins:$KF5/lib/x86_64-linux-gnu/plugins:$QTDIR/plugins:$QT_PLUGIN_PATH
 
export QML2_IMPORT_PATH=$KF5/lib/qml:$KF5/lib64/qml:$KF5/lib/x86_64-linux-gnu/qml:$QTDIR/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH
 
export KDE_SESSION_VERSION=5
export KDE_FULL_SESSION=true
export KDE_SRC=$HOME/kf5/src
export KDE_BUILD=$HOME/kf5/build
 
c=`echo -e "\033"`
export QT_MESSAGE_PATTERN="%{appname}(%{pid})/(%{category}) ${c}[31m%{if-debug}${c}[34m%{endif}\
%{function}${c}[0m: %{message}"
unset c
