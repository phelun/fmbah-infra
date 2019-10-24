# Packer example

This folder contains an example of how define infrastructure-as-code using [Packer](https://www.packer.io/). The
`simple-web-server.json` Packer template shows how to create an AMI containing a simple web server that you can deploy
in AWS. 

## Quick start

1. Install [Packer](https://www.packer.io/).
2. Add your AWS credentials as the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
3. Run `packer build packer.json`.
4. packer build -var 'version=_v-1.0.1' -var 'source_ami_id=ami-0d6f66eff8dds62x99e57' packer.json
