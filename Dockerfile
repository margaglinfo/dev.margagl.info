#
# Dockerfile generated from https://github.com/cloudposse/reference-architectures
#

FROM cloudposse/geodesic:0.115.0

# Terraform version changes should be carefully managed, but Geodesic updates them frequently,
# so Terraform version should be pinned here and updated thoughfully.
# Install terraform 0.11 for backwards compatibility
RUN apk add terraform_0.11@cloudposse terraform@cloudposse==0.11.14-r0

# helm and helmfile version changes should be carefully managed, but Geodesic updates them frequently,
# so the versions should be pinned here and updated thoughfully.
# Pin helm to 2.14.1 and helmfile to 0.73.1 for stability
RUN apk add helm@cloudposse==2.14.1-r0 helmfile@cloudposse==0.73.1-r0


ENV DOCKER_IMAGE="cloudposse/dev.margagl.info"
ENV DOCKER_TAG="latest"

# General
ENV NAMESPACE="minfo"
ENV STAGE="dev"

# Geodesic banner
ENV BANNER="dev"

# Message of the Day
ENV MOTD_URL="https://geodesic.sh/motd"

# AWS Region
ENV AWS_REGION="us-east-1"
ENV AWS_ACCOUNT_ID="433146033010"
ENV AWS_ROOT_ACCOUNT_ID="994146330903"

# Network CIDR Ranges
ENV ORG_NETWORK_CIDR="10.0.0.0/8"
ENV ACCOUNT_NETWORK_CIDR="10.101.0.0/16"

# chamber KMS config
ENV CHAMBER_KMS_KEY_ALIAS="alias/${NAMESPACE}-${STAGE}-chamber"

# Terraform State Bucket
ENV TF_BUCKET_PREFIX_FORMAT="basename-pwd"
ENV TF_BUCKET_ENCRYPT="true"
ENV TF_BUCKET_REGION="${AWS_REGION}"
ENV TF_BUCKET="${NAMESPACE}-${STAGE}-terraform-state"
ENV TF_DYNAMODB_TABLE="${NAMESPACE}-${STAGE}-terraform-state-lock"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="${NAMESPACE}-${STAGE}-admin"
ENV AWS_MFA_PROFILE="${NAMESPACE}-root-admin"

# Place configuration in 'conf/' directory
COPY conf/ /conf/

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

COPY rootfs/ /

WORKDIR /conf/
