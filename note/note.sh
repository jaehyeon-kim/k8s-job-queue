# watchmedo auto-restart -d . -p '*.py' -- celery worker -l info -A tasks


# ##
# redis-cli
# keys *

# mget celery-task-meta-d0952e60-4c69-4116-a8e6-04ae06d43dcb
# 1) "{\"status\": \"SUCCESS\", \"result\": 8, \"traceback\": null, \"children\": [], \"task_id\": \"d0952e60-4c69-4116-a8e6-04ae06d43dcb\", \"date_done\": \"2019-11-06T19:27:40.576766\"}"


# echo '{"total": 30}' | http POST http://localhost:9000/celery/execute

# http http://localhost:9000/celery/collect?task_id=87c51085-fce7-459a-9df5-7c4e01fd9bed


echo '{"total": 30}' | http POST http://localhost:9000/rserve/execute

http http://localhost:9000/rserve/collect?task_id=f97efb39-8154-42b3-b545-0db841dc001e