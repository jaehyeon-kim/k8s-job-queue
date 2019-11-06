from fastapi import FastAPI, Body
from pydantic import BaseModel

from job_queue.tasks import long_task

app = FastAPI(title="FastAPI Celery Example", version="0.0.1")


class ExecuteResp(BaseModel):
    task_id: str
    status: str


class ResultResp(BaseModel):
    current: int
    total: int
    status: str
    result: int


@app.post("/execute", response_model=ExecuteResp, status_code=202, tags=["task"])
async def execute_task(total: int = Body(..., min=0, max=30)):
    task = long_task.apply_async(args=[total])
    return {"task_id": task.id, "status": "created"}


@app.get("/collect", response_model=ResultResp, tags=["task"])
async def collect_result(task_id: str):
    resp = long_task.AsyncResult(task_id)
    return resp.result
