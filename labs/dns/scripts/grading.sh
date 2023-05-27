#!/usr/bin/env bash
set -euo pipefail
set -x

outputs_file='/tmp/outputs.json'
results_file='results.txt'
cd "$(dirname $0)"

(cd ../ && terraform output -json) > "${outputs_file}"

urls="$(jq '[.dns_names.value[]]' ${outputs_file})"
num_students="$(jq '[.dns_names.value[]] | length' ${outputs_file})"

echo "EOF" > $results_file
for url_num in $(seq 1 "${num_students}") ; do
  url_index=$((url_num - 1))
  url=$(echo ${urls} | jq -rc ".[${url_index}]")
  echo $url >> ${results_file}
  curl -s $url | grep DOCTYPE >> ${results_file} || echo "No data" >> ${results_file}
#   scp -r ../scripts ../services ../instructions ../dummy-app-src   admin@"${server_ip}":/tmp
#   ssh admin@"${server_ip}" "export team_name=Team-${server_num} && export db_addr=${db_ip} && sudo -E bash /tmp/scripts/init.sh"
done
echo "EOF" >> $results_file
