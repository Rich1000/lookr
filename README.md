# lookr

A quick way to get data out of Looker without row limits.

## installation

```
install.packages('devtools')
library('devtools')
install_github('rich1000/lookr')
```

## set up

You will first need to create a file ~/.Renviron with the following variables:

```
LOOKER_API_PATH = 'https://???.looker.com:19999/api/3.0'
LOOKER_CLIENT_ID = '???'
LOOKER_CLIENT_SECRET = '???'
```


## usage

```
df = get_look(look_id = 123)
```

Note: the row limit is taken from the saved Look, to save without limit simply delete the numbers in the row limit box
