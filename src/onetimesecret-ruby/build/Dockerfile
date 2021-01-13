FROM ruby:2.7-alpine3.12

ENTRYPOINT [ "onetime" ]
CMD ["--help"]

RUN printf '\e[1;32m%-6s\e[m\n' "* Install OS deps" \
  && apk add --update --no-cache \
    curl
#     git \
#     build-base \
#     bash \
#     man

RUN printf '\e[1;32m%-6s\e[m\n' "* Installing onetimesecret-ruby" \
  && printf '\e[1;32m%-6s\e[m\n' "  - Get gem certificate" \
  && curl -LO https://raw.github.com/onetimesecret/onetime-ruby/master/gem-public_cert.pem \
  && printf '\e[1;32m%-6s\e[m\n' "  - import gem certificate" \
  && gem cert --add gem-public_cert.pem \
  && rm -v gem-public_cert.pem \
  && printf '\e[1;32m%-6s\e[m\n' "  - Install gem" \
  && gem install onetime

# RUN echo "* Remove unneeded packages" \
#   && apk del \
#     build-base

