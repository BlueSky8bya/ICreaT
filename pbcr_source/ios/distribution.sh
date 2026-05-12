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

echo "[iOS Build & Distribution]"
echo "Hello, "$USER". Where to go?"
echo "  [1] to Firebase" 
echo "  [2] to AppStore"
read go

if [ $go -eq 2 ]; then
    echo "자동배포 옵션 (심사 완료 후 자동 release 할건지)"
    echo "  [1] True" 
    echo "  [2] False"
    read release_option
fi

archive_file="../build/ios/archive/Runner.xcarchive"
ipa_file="ad_hoc/iCReaT DCT.ipa"
ipa_test_file="ad_hoc/iCReaT DCT.ipa"

delete_file "$archive_file"
delete_file "$ipa_file"        
delete_file "$ipa_test_file"        
delete_file "ad_hoc/DistributionSummary.plist"
delete_file "ad_hoc/Packaging.log"

case $go in
    1) 
        flutter build ipa --profile && xcodebuild -exportArchive -archivePath "$archive_file" -exportPath ad_hoc -exportOptionsPlist ad_hoc/ExportOptions.plist -allowProvisioningUpdates && fastlane firebase file_path:"$ipa_test_file"
        ;;
    2)
        flutter build ipa && xcodebuild -exportArchive -archivePath "$archive_file" -exportPath ad_hoc -exportOptionsPlist ad_hoc/ExportOptions.plist -allowProvisioningUpdates && fastlane store file_path:"$ipa_file" archive_path:"$archive_file" auto_release:"$release_option"
        ;;
esac