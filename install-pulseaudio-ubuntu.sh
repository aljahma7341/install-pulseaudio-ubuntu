# For those of you looking for this GIST: I don't maintain this code anymore. I recommend using WSLg, which is included starting with Windows 11.

# Please refer to https://gist.github.com/CraigCottingham/fad000cc2ec4678203acf62c4ad2ab23 code that forked this GIST.

# Credits
# https://c-nergy.be/blog/?p=13655
# https://askubuntu.com/questions/844245/how-to-compile-latest-pulseaudio-with-webrtc-in-ubuntu-16-04
# https://askubuntu.com/questions/496549/error-you-must-put-some-source-uris-in-your-sources-list
# https://unix.stackexchange.com/questions/65167/enable-udev-and-speex-support-for-pulseaudio
# https://rudd-o.com/linux-and-free-software/how-to-make-pulseaudio-run-once-at-boot-for-all-your-users

# First, you should install XRDP and X11 Desktop Environment first.

# Step 1 - Install Some PreReqs
sudo apt-get install git libpulse-dev autoconf m4 intltool build-essential dpkg-dev libtool libsndfile-dev libspeexdsp-dev libudev-dev -y

# Enable source repo
sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update

sudo apt build-dep pulseaudio -y

#  Download pulseaudio source in /tmp directory - Do not forget to enable source repositories
cd /tmp
sudo apt source pulseaudio

# Compile
pulsever=$(pulseaudio --version | awk '{print $2}')
cd /tmp/pulseaudio-$pulsever
sudo ./configure --without-caps

# Create xrdp sound modules
sudo git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git
cd pulseaudio-module-xrdp
sudo ./bootstrap 
sudo ./configure PULSE_DIR="/tmp/pulseaudio-$pulsever"
sudo make

#copy files to correct location (as defined in /etc/xrdp/pulse/default.pa)
cd /tmp/pulseaudio-$pulsever/pulseaudio-module-xrdp/src/.libs
sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so

# TODO: Register pulseaudio as a service

# Restart xrdp
sudo service dbus restart
sudo service pulseaudio restart
sudo service xrdp restart
cd 
