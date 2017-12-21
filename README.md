# lookr

A quick way to get data out of Looker without row limits.

## set up

You will first need to create a file ~/.Renviron with the following variables:

```
LOOKER_API_PATH = 'https://???.looker.com:19999/api/3.0'
LOOKER_CLIENT_ID = '???'
LOOKER_CLIENT_SECRET = '???'
```

## installation

```
install.packages('devtools')
library('devtools')
install_github('rich1000/lookr')
```

## usage

```
library(lookr)

df = get_look(look_id = 123)  # default row limit of 500

df = get_look(look_id = 123, limit = 10000)  # custom row limit

df = get_look(look_id = 123, limit = -1)  # without row limit
```

And that's it, there are no other functions!
