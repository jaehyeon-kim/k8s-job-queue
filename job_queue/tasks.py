import math
import time

from . import app


@app.task(bind=True)
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
