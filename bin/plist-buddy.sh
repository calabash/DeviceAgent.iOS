
source bin/log_functions.sh

# $1 Plist
# $2 Key
# $3 Variable reference
function plist_read_key {
  eval $3=`/usr/libexec/PlistBuddy -c "Print :${2}" "${1}" | tr -d '\n'`
}

# $1 Plist
# $2 Key
# $3 Value
function plist_set_key {
  /usr/libexec/PlistBuddy -c "Set :${2} ${3}" "${1}" | tr -d '\n'
}

# $1 Expected version
# $2 Plist
# $3 Key
function expect_version_equal {
  VERSION=""
  plist_read_key "${2}" "${3}" VERSION

  if [ "${1}" = "${VERSION}" ]; then
    info "${2} has the correct ${3}"
  else
    error "Incorrect version detected:"
    error ""
    error "Expected: ${1}"
    error "  Actual: ${VERSION}"
    error ""
    error "${2}"
    exit 1
  fi
}

