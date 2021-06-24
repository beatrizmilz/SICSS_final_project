## code to prepare dataset goes here

# devtools::install_github("beatrizmilz/wikihistory")

# Termos para pesquisar -------
# esses termos precisam equivaler à páginas na wikipedia!

# Vamos buscar as paginas na categoria mudanças climaticas

paginas_mudancas_climaticas <- wikihistory::get_pages_in_categories("Mudanças climáticas", "pt")


dplyr::glimpse(paginas_mudancas_climaticas)

usethis::use_data(paginas_mudancas_climaticas, overwrite = TRUE)

# vamos buscar então as categorias dessas páginas --------

categorias <- purrr::map_dfr(.x = paginas_mudancas_climaticas$page_name,
               .f = wikihistory::get_categories,
               lang = "pt")

usethis::use_data(categorias, overwrite = TRUE)

# qual é o historico de mudanças dessas páginas?

historico_mudancas_raw <- purrr::map_dfr(.x = paginas_mudancas_climaticas$page_name,
               .f = wikihistory::get_history,
               lang = "pt")

historico_mudancas <-  wikihistory::clean_history(historico_mudancas_raw, lang = "pt")


usethis::use_data(historico_mudancas, overwrite = TRUE)


# quem é que faz as mudancas? remover os IPs

contribuidores <- wikihistory::get_users_edits(historico_mudancas) %>%
  wikihistory::clean_ip()


usethis::use_data(contribuidores, overwrite = TRUE)


# onde essas pessoas contribuem?

contribuidores_outras_paginas <- wikihistory::get_all_edits(contribuidores)

usethis::use_data(contribuidores_outras_paginas, overwrite = TRUE)

