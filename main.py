from fastapi import FastAPI, BackgroundTasks

from worker.task_app import app as task_app

app = FastAPI(title="FastAPI Celery Example", version="0.0.1")

# CELERY_BROKER_URL
# CELERY_RESULT_BACKEND
# CELERY_TRACK_STARTED
# BROKER_VISIBILITY_TIMEOUT: 3600
