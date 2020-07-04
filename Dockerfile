FROM ruby:2.7.1-slim-buster
LABEL author="Dave Elliott"
LABEL homepage="https://github.com/DDAZZA/renogen"

COPY renogen-*.gem .
RUN gem install renogen-*.gem
VOLUME ./change_log/

ENTRYPOINT ["renogen"]
