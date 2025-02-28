FROM ruby:3.3

WORKDIR /app
COPY . /app

EXPOSE 8081

RUN chmod +x /app/bin/application
CMD ["./bin/application"]