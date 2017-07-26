
function xcode_gte_9 {
 XC_MAJOR=`xcrun xcodebuild -version | awk 'NR==1{print $2}' | awk -v FS="." '{ print $1 }'`
 if [ "${XC_MAJOR}" \> "9" -o "${XC_MAJOR}" = "9" ]; then
   echo "true"
 else
   echo "false"
 fi
}
