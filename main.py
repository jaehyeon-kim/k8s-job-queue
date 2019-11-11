import os
import json
import httpx
from uuid import uuid4
from fastapi import FastAPI, Body, HTTPException
from pydantic import BaseModel, Schema

from queue_celery.tasks import app as celery_app, long_task


def set_rserve_url(fname):
    return "http://{0}:{1}/{2}".format(
        os.getenv("RSERVE_HOST", "localhost"), os.getenv("RSERVE_PORT", "8000"), fname
    )


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


@app.post("/celery/execute", response_model=ExecuteResp, status_code=202, tags=["celery"])
async def execute_celery_task(total: int = Body(..., min=1, max=50, embed=True)):
    task = celery_app.send_task("long_task", args=[total])
    return {"task_id": task.id, "status": "created"}


@app.get(
    "/celery/collect",
    response_model=ResultResp,
    responses={500: {"model": ErrorResp}},
    tags=["celery"],
)
async def collect_celery_result(task_id: str):
    resp = long_task.AsyncResult(task_id)
    if resp.status == "FAILURE":
        raise HTTPException(status_code=500, detail="Fails to collect result")
    return resp.result


@app.post("/rserve/execute", status_code=202, tags=["rserve"])
async def execute_rserve_task(total: int = Body(..., min=1, max=50, embed=True)):
    jsn = json.dumps({"task_id": str(uuid4()), "total": total})
    async with httpx.AsyncClient() as client:
        r = await client.post(set_rserve_url("handle_long_task"), json=jsn)
        return r.json()


@app.get("/rserve/collect", tags=["rserve"])
async def collect_rserve_task(task_id: str):
    jsn = json.dumps({"task_id": task_id})
    async with httpx.AsyncClient() as client:
        r = await client.post(set_rserve_url("get_task"), json=jsn)
        return r.json()
