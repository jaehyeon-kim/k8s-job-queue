# watchmedo auto-restart -d . -p '*.py' -- celery worker -l info -A tasks


# ##
# redis-cli
# key *

# mget celery-task-meta-d0952e60-4c69-4116-a8e6-04ae06d43dcb
# 1) "{\"status\": \"SUCCESS\", \"result\": 8, \"traceback\": null, \"children\": [], \"task_id\": \"d0952e60-4c69-4116-a8e6-04ae06d43dcb\", \"date_done\": \"2019-11-06T19:27:40.576766\"}"


# echo '{"total": 30}' | http POST http://localhost:9000/celery/execute

# http http://localhost:9000/celery/collect?task_id=df0be018-ca1d-4092-b58f-44589e6b2fc1


http POST http://localhost:9000/rserve/execute