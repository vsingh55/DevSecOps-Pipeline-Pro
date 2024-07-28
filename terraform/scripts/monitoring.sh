#!/bin/bash

sudo apt-get update
# Prometheus
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/prometheus-2.51.2.linux-amd64.tar.gz
tar -xvf prometheus-2.51.2.linux-amd64.tar.gz
rm -rf prometheus-2.51.2.linux-amd64.tar.gz
cd prometheus-2.51.2.linux-amd64
./prometheus --config.file=prometheus.yml &
cd ~
sleep 10


# Grafana
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get install -y adduser libfontconfig1 musl
cd /opt
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.4.2_amd64.deb
sudo dpkg -i grafana-enterprise_10.4.2_amd64.deb
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server
cd ~
sleep 10

# Blackbox Exporter
cd /opt
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz
rm -rf blackbox_exporter-0.25.0.linux-amd64.tar.gz
cd blackbox_exporter-0.25.0.linux-amd64
./blackbox_exporter &
cd ~