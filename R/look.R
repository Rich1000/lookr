
set_access_token = function() {
    looker_api_path = Sys.getenv('LOOKER_API_PATH')
    looker_client_id = Sys.getenv('LOOKER_CLIENT_ID')
    looker_client_secret = Sys.getenv('LOOKER_CLIENT_SECRET')

    if (looker_api_path == '') stop(sprintf('variable %s missing from file ~/.Renviron', 'LOOKER_API_PATH'))
    if (looker_client_id == '') stop(sprintf('variable %s missing from file ~/.Renviron', 'LOOKER_CLIENT_ID'))
    if (looker_client_secret == '') stop(sprintf('variable %s missing from file ~/.Renviron', 'LOOKER_CLIENT_SECRET'))

    query = sprintf(
        '%s/login?client_id=%s&client_secret=%s',
        looker_api_path,
        looker_client_id,
        looker_client_secret
    )
    response = httr::POST(query)
    status_code = httr::status_code(response)
    if (status_code != 200) {
        stop(sprintf('status code %s', status_code))
    } else {
        Sys.setenv('LOOKER_ACCESS_TOKEN_EXPIRY' = as.numeric(Sys.time()) + httr::content(response)$expires_in)
        Sys.setenv('LOOKER_ACCESS_TOKEN' = httr::content(response)$access_token)
    }
}

get_look = function(look_id, limit=500) {
    require(tidyverse)
    if (
        Sys.getenv('LOOKER_ACCESS_TOKEN') == '' | as.numeric(Sys.time()) >= Sys.getenv('LOOKER_ACCESS_TOKEN_EXPIRY')
    ) set_access_token()
    query = sprintf(
        '%s/looks/%s/run/csv?limit=%s&access_token=%s',
        Sys.getenv('LOOKER_API_PATH'),
        look_id,
        as.character(limit),
        Sys.getenv('LOOKER_ACCESS_TOKEN')
    )
    response = httr::GET(query)
    status_code = httr::status_code(response)
    if (status_code != 200) {
        stop(sprintf('status code %s', status_code))
    } else {
        df = readr::read_csv(httr::content(response))

        names(df) = names(df) %>%
            stringr::str_to_lower() %>%
            stringr::str_replace_all('\\.', '_') %>%
            stringr::str_replace_all(' ', '_')

        return(df)
    }
}
