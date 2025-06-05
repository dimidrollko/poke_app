#Don't forget store original files in firebase_local
#Before running don't forget to 
#$chmod +x ./scripts/bash.sh
cp firebase_local/google-services.json android/app/google-services.json
cp firebase_local/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
cp firebase_local/firebase_options.dart lib/firebase_options.dart