
set_access_token = function() {
    query = sprintf(
        '%s/login?client_id=%s&client_secret=%s',
        Sys.getenv('LOOKER_API_PATH'),
        Sys.getenv('LOOKER_CLIENT_ID'),
        Sys.getenv('LOOKER_CLIENT_SECRET')
    )
    response = httr::POST(query)
    status_code = httr::status_code(response)
    if (status_code != 200) {
        sprintf("something went wrong :( status code: %s", status_code)
    } else {
        Sys.setenv('LOOKER_ACCESS_TOKEN_EXPIRY' = Sys.time() + httr::content(response)$expires_in)
        Sys.setenv('LOOKER_ACCESS_TOKEN' = httr::content(response)$access_token)
    }
}

get_look = function(look_id) {
    require(tidyverse)
    if (
        Sys.getenv('LOOKER_ACCESS_TOKEN') == "" | Sys.time() >= Sys.getenv('LOOKER_ACCESS_TOKEN_EXPIRY')
    ) set_access_token()
    query = sprintf(
        '%s/looks/%s/run/csv?limit=-1&access_token=%s',
        Sys.getenv('LOOKER_API_PATH'),
        look_id,
        Sys.getenv('LOOKER_ACCESS_TOKEN')
    )
    response = httr::GET(query)
    status_code = httr::status_code(response)
    if (status_code != 200) {
        sprintf("something went wrong :( status code: %s", status_code)
    } else {
        df = readr::read_csv(httr::content(response))

        names(df) = names(df) %>%
            stringr::str_to_lower() %>%
            stringr::str_replace_all('\\.', '_') %>%
            stringr::str_replace_all(' ', '_')

        return(df)
    }
}
