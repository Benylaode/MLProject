from prometheus_client import start_http_server, Summary, Counter, Gauge
import random
import time

REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
PREDICTION_COUNT = Counter('prediction_total', 'Total number of predictions made')
MODEL_ACCURACY = Gauge('model_accuracy', 'Current model accuracy')

@REQUEST_TIME.time()
def process_request():
    PREDICTION_COUNT.inc()
    MODEL_ACCURACY.set(random.uniform(0.8, 0.95))
    time.sleep(random.random())

if __name__ == '__main__':
    start_http_server(8001)
    print("✅ Prometheus exporter running on port 8001...")
    while True:
        process_request()
