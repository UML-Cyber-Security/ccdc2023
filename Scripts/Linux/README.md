# Useful commands -- To fix my issues :) 
The Following will remove and replace CLRF with LF so Scripts work on Linux systems.
```
sed -i -e 's/\r$//' Script.sh 
```

The Following will change the permissions of all files found to end in .sh making them executable.
```

```

The following is for debian based systems, as some packages may request user input, which can be annoying. YUM and (maybe) APK appear to not do this. You still should use the **-y** flag as they will do the "Do you really want to use disk space" and making sure you are not installing some weird package.
```sh 
# We can show package configurations that we can set pre download.
debconf-show 
# This is how we would write them to the system
echo package option | debconf-set-selections

# alternatively we can use the default options by using the following (I prefer as I am Lazy)

export DEBIAN_FRONTEND=noninteractive 
```


