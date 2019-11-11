import os
import math
import time
from celery import Celery

redis_url = "redis://{0}:{1}/{2}".format(
    os.environ["CELERY_HOST"], os.environ["CELERY_PORT"], os.environ["CELERY_DB"]
)

app = Celery("tasks", backend=redis_url, broker=redis_url)
app.conf.update(broker_transport_options={"visibility_timeout": 3600})


@app.task(bind=True, name="long_task")
def long_task(self, total):
    message = ""
    for i in range(total):
        message = "Percentage completion {0}...".format(math.ceil(i / total * 100))
        self.update_state(state="PROGRESS", meta={"current": i, "total": total, "status": message})
        time.sleep(1)
    return {"current": total, "total": total, "status": "Task completed!", "result": total}


@app.task
def add(x, y):
    time.sleep(8)
    return x + y


@app.task
def fail(x):
    time.sleep(3)
    1 / 0
    return x
