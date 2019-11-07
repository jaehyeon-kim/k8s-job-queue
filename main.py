from fastapi import FastAPI, Body, HTTPException
from pydantic import BaseModel, Schema

from job_queue.tasks import app as celery_app, long_task

app = FastAPI(title="FastAPI Celery Example", version="0.0.1")


class ExecuteResp(BaseModel):
    task_id: str
    status: str


class ResultResp(BaseModel):
    current: int
    total: int
    status: str
    result: int = None


class ErrorResp(BaseModel):
    detail: str


@app.post("/execute", response_model=ExecuteResp, status_code=202, tags=["task"])
async def execute_task(total: int = Body(..., min=0, max=50, embed=True)):
    task = celery_app.send_task("long_task", args=[total])
    return {"task_id": task.id, "status": "created"}


@app.get(
    "/collect", response_model=ResultResp, responses={500: {"model": ErrorResp}}, tags=["task"]
)
async def collect_result(task_id: str):
    resp = long_task.AsyncResult(task_id)
    if resp.status == "FAILURE":
        raise HTTPException(status_code=500, detail="Fails to collect result")
    return resp.result
