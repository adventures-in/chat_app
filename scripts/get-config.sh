#!/bin/sh
 
echo "Retrieving firebase config files..."

# Firebase Credentials
gsutil cp gs://config-adventures-in-chat/GoogleService-Info.plist ./ios/Runner/GoogleService-Info.plist
gsutil cp gs://config-adventures-in-chat/GoogleService-Info.plist ./macos/Runner/GoogleService-Info.plist
gsutil cp gs://config-adventures-in-chat/google-services.json ./android/app/google-services.json
gsutil cp gs://config-adventures-in-chat/index_debug.html ./web/index.html