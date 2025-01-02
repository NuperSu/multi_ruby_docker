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

FROM ubuntu:20.04 AS ruby-ssl1.1.1
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl1.1 && \
    rm -rf /var/lib/apt/lists/*

# newer Rubies
FROM ubuntu:24.04
COPY --from=ruby-old /usr/local/rvm /usr/local/rvm

# SSL 1.0
COPY --from=ruby-old /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/
COPY --from=ruby-old /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/  

# SSL 1.1
COPY --from=ruby-ssl1.1.1 /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/
COPY --from=ruby-ssl1.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/

# deps for RVM
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg2 build-essential openssl libssl-dev libreadline-dev zlib1g-dev libyaml-dev \
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

RUN source /usr/local/rvm/scripts/rvm && \
    gem update --system 3.2.3 && \
    rvm 2.3.8 do gem install bundler -v 2.3.27;

RUN source /usr/local/rvm/scripts/rvm && \
    for v in 2.4.10 2.5.9; do \
      rvm "$v" do gem install bundler -v 2.3.27; \
    done

RUN source /usr/local/rvm/scripts/rvm && \
    for v in 2.6.10 2.7.8; do \
      rvm "$v" do gem install bundler -v 2.4.22; \
    done

#RUN source /usr/local/rvm/scripts/rvm && \
#    rvm 3.0.7 do gem install bundler -v 2.4.22;

RUN source /usr/local/rvm/scripts/rvm && \
    for v in 3.1.6 3.2.6 3.3.6; do \
      rvm "$v" do gem install bundler -v 2.6.2; \
    done

WORKDIR /app

COPY Gemfile /app/
COPY multiruby.gemspec /app/
COPY lib /app/lib
COPY app.rb /app/

SHELL ["/bin/bash", "-c"]

ENTRYPOINT [ \
  "/bin/bash", \
  "-c", \
  "set -e; \
   source /usr/local/rvm/scripts/rvm; \
   if [ -n \"$RUBY_V\" ]; then \
     echo \"Using Ruby version: $RUBY_V\"; \
     rvm use $RUBY_V --default; \
   else \
     echo \"No Ruby version specified. Please set RUBY_V environment variable. Exiting.\"; \
     exit 1; \
   fi; \
   bundler install; \   
   ruby app.rb;" \
]
