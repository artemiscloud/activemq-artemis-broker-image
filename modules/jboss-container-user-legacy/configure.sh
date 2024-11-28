#!/bin/bash
set -e

# Restore legacy jboss group and user names
groupmod -n jboss default && usermod -l jboss -m -d /home/jboss -c "JBoss user" default
chmod ug+rwX /home/jboss
chmod 664 /etc/passwd
