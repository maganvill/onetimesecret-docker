# onetimesecret-docker

This is a fork of [onetimesecret-docker](https://github.com/dismantl/onetimesecret-docker), with a few customizations.

## Configuraiton 
Environment variables are expanded in ```config.example```.
```
ONETIMESECRET_HOST
ONETIMESECRET_SSL
ONETIMESECRET_SECRET
```

## Minimal
All features except create, view, delete secrets are disabled. 

This is achieved by 
- using a subsets of the routes in ```routes.example```
- custom stripped footer in ```footer.mustache.example``` 
- CSS to hide the remaining links ```main_append.css```.