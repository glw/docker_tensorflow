# tensorflow object detection

docker image for tensorflow with jupyter


to run jupyter notebook in your host environment:
docker run --rm -p 8888:8888 -v /$(pwd)/:/data garretw/tensorflow_objdetect_jupyter:1.0 jupyter notebook --ip 0.0.0.0 --no-browser --allow-root

For some reason when running jupyter the IP turns into some kind of 12 character alpha numeric code.
For example

```
http://96175bf43a81....
```

changing this to 'localhost' seems to work

```
http://localhost......
```
