# watchmedo auto-restart -d . -p '*.py' -- celery worker -l info -A tasks


# ##
# redis-cli
# keys *

# mget celery-task-meta-d0952e60-4c69-4116-a8e6-04ae06d43dcb
# 1) "{\"status\": \"SUCCESS\", \"result\": 8, \"traceback\": null, \"children\": [], \"task_id\": \"d0952e60-4c69-4116-a8e6-04ae06d43dcb\", \"date_done\": \"2019-11-06T19:27:40.576766\"}"

## queue celery
echo '{"total": 30}' | http POST http://localhost:9000/celery/execute

http http://localhost:9000/celery/collect?task_id=e31ec3e6-f44c-4212-9470-9c19283112c1

## queue rserve
echo '{"total": 30}' | http POST http://localhost:9000/rserve/execute

http http://localhost:9000/rserve/collect?task_id=2db859ed-557c-4d4b-b26f-1b5b690c346c