import os
from celery import Celery

app = Celery("tasks", broker=os.environ["CELERY_BROKER_URL"])
app.conf.update(broker_transport_options={"visibility_timeout": 3600})
