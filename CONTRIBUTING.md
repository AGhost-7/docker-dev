# How to contribute
Contributions are welcome. Open an issue on github and we can figure things
out.

## Developing new images
A good idea is to try out the commands in the base image first then write up
the dockerfile:
```sh
slipway start aghost7/nvim:bionic
```

You can then incrementally test your new image by installing packages on the
go.
