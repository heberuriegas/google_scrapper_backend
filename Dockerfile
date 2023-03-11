FROM ruby:3.2.0

RUN apt-get update -yq \
  && apt-get upgrade -yq \
  #ESSENTIALS
  && apt-get install -y -qq --no-install-recommends build-essential curl git-core vim passwd unzip cron gcc wget netcat \
  # RAILS PACKAGES NEEDED
  && apt-get update \
  && apt-get install -y --no-install-recommends postgresql-client

ENV PATH $CHROMEDRIVER_DIR:$PATH
# Clean cache and temp files, fix permissions
RUN apt-get clean -qy \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle \
  BUNDLE_BIN=/bundle/bin \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# install specific version of bundler
RUN gem install bundler -v 2.3

# keep Gemfile updated
ARG CACHEBUST=1
COPY Gemfile Gemfile.lock ./
RUN bundle install
ARG CACHEBUST=0

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000

CMD ["bash"]