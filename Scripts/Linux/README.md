# TODO
* YUM
* DNF
* APT

# Note
Ensure the files will run on linux.
I (Matt) write them on a Windows computer (...) and move them over to linux. So I will need to go through and fix the line endings and reupload them later. This is because I am now getting some issues.

The Following will remove and replace them so they work.
```
sed -i -e 's/\r$//' Script.sh 
```


```
debconf-show can be used to show selections that we can set using 
echo package option | debconf-set-selections
```