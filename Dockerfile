FROM python:3.7

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

## create a user
RUN useradd app && mkdir /home/app \
    && chown app:app /home/app

USER app
WORKDIR /home/app

## copy source
COPY . /home/app

ENTRYPOINT ["uvicorn"]
CMD ["main:app", "--host", "0.0.0.0", "--port", "9000"]
