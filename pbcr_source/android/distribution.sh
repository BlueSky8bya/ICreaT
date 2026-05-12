#!/bin/sh

function delete_file() {
    if [ -f "$1" ]; then
        echo "$1 삭제"
        rm "$1"
    elif [ -d "$1" ]; then
        echo "$1 폴더 삭제"
        rm -r "$1"
    fi
}

echo "[Android Build & Distribution]"
echo "Hello, "$USER". Where to go?"
echo "  [1] to Firebase" 
echo "  [2] to PlayStore"
read go

case $go in
    1) 
        file="../build/app/outputs/flutter-apk/app-profile.apk"
        delete_file "$file"
        flutter build apk --profile && fastlane firebase file_path:"$file"
        ;;
    2)
        file="../build/app/outputs/bundle/release/app-release.aab"
        delete_file "$file"
        flutter build appbundle && fastlane store file_path:"$file"
        ;;
esac