import os
from celery import Celery

app = Celery(
    "tasks",
    backend="redis://{0}:{1}/0".format(
        os.environ["CELERY_BACKEND_HOST"], os.environ["CELERY_BACKEND_PORT"]
    ),
    broker="redis://{0}:{1}/0".format(
        os.environ["CELERY_BROKER_HOST"], os.environ["CELERY_BROKER_PORT"]
    ),
)
app.conf.update(broker_transport_options={"visibility_timeout": 3600})
