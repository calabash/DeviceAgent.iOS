#!/usr/bin/env bash

xcrun codesign \
  --verbose=4 \
  --verify  \
  -R='anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.1] exists and (certificate leaf[field.1.2.840.113635.100.6.1.2] exists or certificate leaf[field.1.2.840.113635.100.6.1.4] exists)' \
  "${1}"
