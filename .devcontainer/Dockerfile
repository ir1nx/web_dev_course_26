FROM debian:13-slim

RUN apt update && apt install git wget \
    build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev -y

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv

RUN echo 'eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"' >> ~/.bashrc

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN ~/.rbenv/bin/rbenv install 3.3.10

RUN ~/.rbenv/bin/rbenv global 3.3.10
