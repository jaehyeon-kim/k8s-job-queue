## Distributed Task Queue with Python and R

![](/note/diagram.png)

* Main web service, created by [FastAPI](https://fastapi.tiangolo.com/), sends/executes long running tasks to task workers
* Task workers are built by [Celery](http://www.celeryproject.org/) and [Rserve](https://www.rforge.net/Rserve/)
* [Redis](https://redis.io/) is used as message broker/result backend for Celery worker and key-value store for Rserve worker
* See [this post](https://jaehyeon.me/blog/2019-11-15-Distributed-Task-Queue-with-Python-and-R-Example) for more details


### Docker Compose

```bash
docker-compose up -d
```

### Kubernetes

```bash
kubectl apply -f manifests
```