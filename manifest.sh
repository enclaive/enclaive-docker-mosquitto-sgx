#! /bin/bash

if [ -n "$1" ]; then
  cd /manifest

	test -f $1.manifest && rm *.sig *.token *.sgx *.manifest

	gramine-manifest \
      -Dlog_level=error \
      $1.manifest.template $1.manifest
      
	gramine-sgx-sign \
	    --key $SGX_SIGNER_KEY \
	    --manifest $1.manifest \
	    --output $1.manifest.sgx

	gramine-sgx-get-token -s $1.sig -o $1.token     # requires $1.manifest.sgx

else
  echo "Manifest: argument missing"
fi
