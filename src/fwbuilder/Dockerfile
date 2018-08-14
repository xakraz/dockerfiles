FROM debian:jessie-slim

RUN echo "* Updating APT" \
  && apt update \
  && echo "* Installing fwbuilder" \
  && apt install -y --force-yes fwbuilder \
  && echo "* Cleaning APT cache" \
  && rm -rf /var/lib/apt

ENTRYPOINT ["/usr/bin/fwbuilder"]

