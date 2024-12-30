# old Rubies

FROM ubuntu:18.04 AS ruby-old
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg2 build-essential libssl1.0.0 libssl1.1 libreadline-dev zlib1g-dev libyaml-dev \
    git ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable
SHELL ["/bin/bash", "-c"]
RUN source /usr/local/rvm/scripts/rvm && \
    rvm install 2.3.8 && \
    rvm install 2.4.10 && \
    rvm install 2.5.9 && \
    rvm install 2.6.10 && \
    rvm install 2.7.8


# newer Rubies
FROM ubuntu:24.04
COPY --from=ruby-old /usr/local/rvm /usr/local/rvm

# old SSL
COPY --from=ruby-old /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/
COPY --from=ruby-old /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/  

# deps for RVM
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev libyaml-dev \
    git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# installing RVM with GPG keys
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable

SHELL ["/bin/bash", "-c"]

RUN source /usr/local/rvm/scripts/rvm && \
    rvm install 3.0.7 && \
    rvm install 3.1.6 && \
    rvm install 3.2.6 && \
    rvm install 3.3.6
ENV CACHEBUST=1
RUN source /usr/local/rvm/scripts/rvm && \
    for v in 2.3.8 2.4.10 2.5.9 2.6.10 2.7.8 3.0.7 3.1.6 3.2.6 3.3.6; do \
      rvm "$v" do gem install bundler; \
    done

WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/
COPY multiruby.gemspec /app/
COPY lib/ /app/lib/

ENV RUBY_VERSION=3.3.0

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# entrypoint by default
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["rake", "test"]
