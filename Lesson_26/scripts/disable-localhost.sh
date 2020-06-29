#!/usr/bin/env bash
sudo sed -i "/^127.0.0.1[[:space:]]cl01.otus.local[[:space:]]cl01/c\#127.0.0.1 cl01.otus.local cl01" /etc/hosts