from python:latest
COPY ./build .
# RUN pip install .
# RUN pip install -r experimentvr/requirements.txt
RUN pip install ./*whl
RUN mkdir ~/.aws
CMD ["python", "handler.py"]