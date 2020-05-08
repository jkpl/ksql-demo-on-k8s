#
# Builder stage for fetching external resources
#
FROM debian AS builder

RUN apt-get update && apt-get install -y curl

ENV JMX_EXPORTER_VERSION="0.12.0"
ENV JMX_EXPORTER_URL=https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_EXPORTER_VERSION/jmx_prometheus_javaagent-$JMX_EXPORTER_VERSION.jar
WORKDIR /project
RUN curl -o jmx_prometheus_javaagent.jar "$JMX_EXPORTER_URL"

#
# Image for running the KSQL script
#
FROM confluentinc/cp-ksql-server:5.4.2

ENV KSQL_KSQL_QUERIES_FILE="/script.sql" \
    KSQL_KSQL_SERVICE_ID=ksql-demo \
    MAX_RAM_USAGE_PCT=90.0 \
    JMX_EXPORTER_PATH=/jmx_prometheus_javaagent.jar \
    JMX_EXPORTER_CONFIG_PATH=/etc/jmx_exporter.yaml \
    JMX_EXPORTER_PORT=5556
ENV KSQL_OPTS="-XX:MaxRAMPercentage=$MAX_RAM_USAGE_PCT -javaagent:${JMX_EXPORTER_PATH}=${JMX_EXPORTER_PORT}:${JMX_EXPORTER_CONFIG_PATH}"

# Copy assets
COPY --from=builder /project/jmx_prometheus_javaagent.jar "$JMX_EXPORTER_PATH"
COPY jmx_exporter.yaml "$JMX_EXPORTER_CONFIG_PATH"
COPY script.sql "$KSQL_KSQL_QUERIES_FILE"

EXPOSE "$JMX_EXPORTER_PORT"
