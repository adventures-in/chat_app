#!/bin/sh
 
echo "Retrieving credential files..."

# service account credentials for fastlane to retrieve iOS Signing credentials
gsutil cp gs://credentials-adventures-in-chat/gc_keys.json ./ios/gc_keys.json

# Android Signing credentials
gsutil cp gs://credentials-adventures-in-chat/keystore.jks ./android/app/keystore.jks
gsutil cp gs://credentials-adventures-in-chat/keystore.config ./android/app/keystore.config
