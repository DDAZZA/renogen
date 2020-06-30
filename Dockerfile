FROM ruby:2.7.1-slim-buster
LABEL author="Dave Elliott"
LABEL homepage="https://github.com/DDAZZA/renogen"

RUN gem install renogen -v 1.2.1
VOLUME ./change_log/

ENTRYPOINT ["renogen"]
