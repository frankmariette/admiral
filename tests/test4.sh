#!/bin/bash

[ $# -lt 2 ] && { echo "Usage: $0 <source_app> <source_ns>" ; exit 1; }

test() {
    #Delete the deployment

    #Test, expecting to expect the grpc client to complete the requests with 100% success
    output=($(kubectl get se --namespace=admiral-sync | grep "stage.$source.global" | wc -l))
   if [[ "${output}" -gt 0 ]]; then
      echo "FAIL"
      kubectl get se --namespace=admiral-sync
      return 1
   else
      echo "PASS"
      return 0
   fi

}
source=$1
source_ns=$2
kubectl delete deploy $source -n $source_ns

export -f test
timeout 120s bash -c "until test; do sleep 10; done"
if [[ $? -eq 124 ]]
then
  exit 1
fi
