FROM alpine:latest

CMD ["git-extras", "--help"]

RUN echo "* Install OS deps" \
  && apk add --update --no-cache \
    curl \
    git \
    build-base \
    bash \
    man

RUN echo "* Installing git-extra" \
  && curl -sSL http://git.io/git-extras-setup > /tmp/git-extras-setup \
  && sed -i 's/sudo //g' /tmp/git-extras-setup \
  && chmod +x /tmp/git-extras-setup \
  && /tmp/git-extras-setup

RUN echo "* Remove unneeded packages" \
  && apk del \
    build-base

