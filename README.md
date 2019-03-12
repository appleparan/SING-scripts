# singularity-keras
Simple singularity recipe for keras (personal use)

# How to build
```
$ sudo singularity build keras.img keras-py3.def
```

# How to run singularity with bindindg directory

```
$ singularity exec --bind $HOME/data/res_t path:/mnt keras-py3-jskim.sif "some command to run"
```
