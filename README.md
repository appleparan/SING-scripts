# singularity-keras
Simple singularity recipe for keras (personal use)

# How to build
```
$ sudo singularity build keras.img keras-py3.def
```

# How to run singularity with bind option

```
$ singularity exec --bind $HOME/data/res_path:/mnt /opt/singularity/keras-jskim.img python3 your_script.py
```
