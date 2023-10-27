#!/bin/bash

set -e

ntfy_url=https://ntfy.sh
ntfy_topic=my-container-updates

updates=$(podman auto-update --dry-run --format json | \
          jq -r 'map(select(.Updated =="pending").ContainerName) | join(", ")')

if ! [[ -z "$updates" ]]; then
  curl --insecure -H prio:3 -H 'Title: Container Updates available!' -d "${updates}" ${ntfy_url}/${ntfy_topic}
else
  curl --insecure -H prio:2 -H 'Title: No Container Updates' -d "Hooray!" ${ntfy_url}/${ntfy_topic}
fi

