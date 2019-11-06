from tasks import add, fail, long_task

tsk = long_task.apply_async(args=[23])

resp = long_task.AsyncResult(tsk.id)


result = add.delay(4, 4)

result.apply_async

result.ready()

result.get(timeout=1)

result.get(propagate=False)

result.traceback


result = fail.delay(4)

result.ready()

result.get(timeout=1)

result.get(propagate=False)

result.traceback
