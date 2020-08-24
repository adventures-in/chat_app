#!/bin/sh
 
echo "Retrieving credential files..."

gsutil cp gs://adventures-in-credentials/GoogleService-Info.plist ./ios/Runner/GoogleService-Info.plist
gsutil cp gs://adventures-in-credentials/GoogleService-Info.plist ./macos/Runner/GoogleService-Info.plist
gsutil cp gs://adventures-in-credentials/gc_keys.json ./ios/gc_keys.json
gsutil cp gs://adventures-in-credentials/google-services.json ./android/app/google-services.json
gsutil cp gs://adventures-in-credentials/keystore.jks ./android/app/keystore.jks
gsutil cp gs://adventures-in-credentials/keystore.config ./android/app/keystore.config
