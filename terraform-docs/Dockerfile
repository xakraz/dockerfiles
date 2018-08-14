# Based on hashicorp/docker-hub-images
#
FROM alpine:3.7
MAINTAINER "Xavier Krantz <xakraz@gmail.com>"

ENV TERRAFORM_DOCS_VERSION=0.3.0 \
    TERRAFORM_DOCS_SHA256SUM=339c157dfbabc1ad22091b07d5793902611eee6c3c5e95c5fc7c6b55540c542a \
    TERRAFORM_DOCS_RELEASE_URL="https://github.com/segmentio/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs_linux_amd64"

WORKDIR /app
RUN echo "* Install OS dependencies" \
  && apk add --update --no-cache git curl openssh \
  && echo "* Install Terraform-docs v${TERRAFORM_DOCS_VERSION}" \
  && curl ${TERRAFORM_DOCS_RELEASE_URL} > terraform-docs_${TERRAFORM_DOCS_VERSION}_linux_amd64 \
  && echo "${TERRAFORM_DOCS_SHA256SUM}  terraform-docs_${TERRAFORM_DOCS_VERSION}_linux_amd64" > terraform-docs_${TERRAFORM_DOCS_VERSION}_SHA256SUMS \
  && sha256sum -cs terraform-docs_${TERRAFORM_DOCS_VERSION}_SHA256SUMS \
  && mv terraform-docs_${TERRAFORM_DOCS_VERSION}_linux_amd64 /bin/

ENTRYPOINT ["/bin/terraform-docs"]

