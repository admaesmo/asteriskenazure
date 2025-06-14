#!/bin/bash

# Actualizar sistema
apt-get update && apt-get upgrade -y

# Instalar dependencias
apt-get install -y build-essential libncurses-dev libxml2-dev uuid-dev \
libjansson-dev libssl-dev libsqlite3-dev wget curl gnupg2

# Descargar y compilar Asterisk
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
tar -xzvf asterisk-20-current.tar.gz
cd asterisk-20*/

# Instalar dependencias específicas de Asterisk
contrib/scripts/install_prereq install

./configure
make menuselect.makeopts
menuselect/menuselect --enable app_macro menuselect.makeopts
make
make install
make samples
make config

# Crear usuario y permisos
groupadd asterisk
useradd -r -d /var/lib/asterisk -s /sbin/nologin -g asterisk asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/run/asterisk

# Configurar asterisk.conf
sed -i 's/^;runuser = .*/runuser = asterisk/' /etc/asterisk/asterisk.conf
sed -i 's/^;rungroup = .*/rungroup = asterisk/' /etc/asterisk/asterisk.conf

# Obtener la IP pública de la máquina
PUBLIC_IP=$(curl -s ifconfig.me)

# Configurar sip.conf con IP estática
cat > /etc/asterisk/sip.conf <<EOL
[general]
context=public
udpbindaddr=0.0.0.0
tcpenable=no
transport=udp
externip=${PUBLIC_IP}
localnet=10.0.0.0/8
localnet=172.16.0.0/12
localnet=192.168.0.0/16

[1000]
type=friend
host=dynamic
secret=1234
context=internal
disallow=all
allow=ulaw
allow=alaw
EOL

# Configurar extensions.conf básico
cat > /etc/asterisk/extensions.conf <<EOL
[internal]
exten => 1000,1,Dial(SIP/1000,20)
exten => 1000,n,Hangup()

[public]
exten => _X.,1,Dial(SIP/\${EXTEN})
EOL

# Configurar rtp.conf para usar puertos fijos
cat > /etc/asterisk/rtp.conf <<EOL
[general]
rtpstart=10000
rtpend=20000
EOL

# Habilitar y arrancar Asterisk
systemctl daemon-reexec
systemctl enable asterisk
systemctl start asterisk

# Abrir puertos necesarios
ufw allow 22
ufw allow 5060/udp
ufw allow 10000:20000/udp
ufw --force enable

echo "Configuración completada. IP pública del servidor: ${PUBLIC_IP}"
echo "Puedes conectarte con el usuario SIP 1000 y contraseña 1234"