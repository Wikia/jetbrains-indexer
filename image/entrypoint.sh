#/bin/sh

echo_format() {
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

echo_format "Generating indexes"

/opt/ij-shared-indexes-tool-cli/bin/ij-shared-indexes-tool-cli \
    indexes \
    --ij /opt/idea \
    --project ${IDEA_PROJECT_DIR} \
    --base-url ${INDEXES_CDN_URL} \
    --data-directory ${SHARED_INDEX_BASE}/project
