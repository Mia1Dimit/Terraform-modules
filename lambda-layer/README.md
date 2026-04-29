Lambda Layer module

Usage:

This module publishes a Lambda Layer from an existing zip object stored in S3.

Required inputs:
- `layer_name` - name of the Lambda Layer
- `s3_bucket` - S3 bucket containing the layer zip
- `s3_key` - S3 key for the layer zip
- `compatible_runtimes` - list of runtimes (defaults to python3.12)
- `compatible_architectures` - list of architectures (defaults to arm64)

Tags are merged from `applicationid`, `applicationname`, `environment` and `specifictags`.
