## code to prepare dataset goes here

# devtools::install_github("beatrizmilz/wikihistory")

# Termos para pesquisar -------
# esses termos precisam equivaler à páginas na wikipedia!

# Vamos buscar as paginas na categoria mudanças climaticas

paginas_categoria_mudancas_climaticas <- wikihistory::get_pages_in_categories("Mudanças climáticas", "pt")

paginas_predefinicao_mudanca_do_clima <-  wikihistory::get_template("Mudança do clima", lang = "pt")

paginas_mudancas_climaticas <- c(
  paginas_categoria_mudancas_climaticas$page_name,
  paginas_predefinicao_mudanca_do_clima$page_name
) %>%
  tibble::enframe() %>%
  dplyr::mutate(value = stringr::str_squish(value)) %>%
  dplyr::distinct(value) %>%
  dplyr::filter(value != "Predefinição:Mudança do clima",
                value != "Predefinição Discussão:Mudança do clima (página não existe)") %>%
  dplyr::rename("page_name" = value)


View(paginas_mudancas_climaticas)

dplyr::glimpse(paginas_mudancas_climaticas)

usethis::use_data(paginas_mudancas_climaticas, overwrite = TRUE)



# vamos buscar então as categorias dessas páginas --------

modified_get_categories <- function(page) {
  print(page)
  wikihistory::get_categories(page, lang = "pt")
}

categorias <- purrr::map_dfr(.x = paginas_mudancas_climaticas$page_name,
             #  .f = wikihistory::get_categories,
             modified_get_categories
               #lang = "pt"
             )


usethis::use_data(categorias, overwrite = TRUE)

View(categorias)

# ATÉ AQUI TÁ OK!


# qual é o historico de mudanças dessas páginas?

possibly_get_history <- function(page){
  history <- wikihistory::get_history(page)
  print(page)
  history
}

possibly_get_history(paginas_mudancas_climaticas$page_name[1])

historico_mudancas_raw <- purrr::map_dfr(.x = paginas_mudancas_climaticas$page_name,
               .f = purrr::possibly(wikihistory::get_history, otherwise = "Erro"),
               lang = "pt")

historico_mudancas <-  wikihistory::clean_history(historico_mudancas_raw, lang = "pt")


View(historico_mudancas)

usethis::use_data(historico_mudancas, overwrite = TRUE)


# quem é que faz as mudancas? remover os IPs

contribuidores <- wikihistory::get_users_edits(historico_mudancas) %>%
  wikihistory::clean_ip()


usethis::use_data(contribuidores, overwrite = TRUE)


# onde essas pessoas contribuem?

contribuidores_outras_paginas <- wikihistory::get_all_edits(contribuidores)

usethis::use_data(contribuidores_outras_paginas, overwrite = TRUE)

