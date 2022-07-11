FROM alpine:latest

RUN mkdir /app

COPY templates /templates
COPY mailApp /app

CMD [ "/app/mailApp" ]