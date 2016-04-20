
DOCS_DIR="./documentation"

appledoc \
--project-name "CBXDriver" \
--project-company "Xamarin" \
--company-id "sh.calaba" \
--output "${DOCS_DIR}" \
--keep-undocumented-objects \
--keep-intermediate-files YES\
--search-undocumented-doc \
--no-repeat-first-par \
--ignore "*.m" \
--ignore "Server/NSXPCConnection.h" \
./Server

if [ "$?" = 0 ]; then 
  echo "Docs published to ${DOCS_DIR}"
else
  echo "Failed to create documentation"
fi
