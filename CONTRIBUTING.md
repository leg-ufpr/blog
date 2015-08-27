# Guia de postagem do Blog do LEG

****
## Escrevendo a matéria

As matérias para o blog (ou *posts*) podem ser escritos em [MarkDown][]
pleno. Na grande maioria das vezes, as matérias vão considerar porções
de código, como tutoriais de R, comandos executados em shell e dicas de
LaTex e, portanto, escrever documentos em markdown ou R+markdown salva
tempo, principalmente quando o código precisar ser interpretado e
figuras/tabelas precisam ser inseridas. Dessa forma, esse documento tem
o objetivo de documentar o procedimento de escrever uma matéria em
R+markdown. Assume-se, no entanto, que o leitor já tenha conhecimento do
[R+markdown][], conheça o pacote [knitr][], as [opções de chunk][] e
saiba transformar o documento em html.


****
## Opções de chunk

Existem muitas [opções de chunk][] e [opções do pacote][] que permitem
controlar desde decoração do código e execussão dos comandos até
aparências das imagens. Para evitar de fazer upload das imagens ou usar
codificação [base64][], iremos aqui considerar o upload das imagens para
um diretório público (`#1`). Por comodidade, as figuras podem ser
mantidas em um diretório dedicado (`#2`).

```{r}
opts_knit$set(
    base.url="http://blog.leg.ufpr.br/~walmes/",   #1
    base.dir="/home/walmes/figuras/")              #2

```

É importante considerar uma regra de atribuição de nomes que faça
distinção entre arquivos, seja por separar as figuras das materias em
diretórios ou usar um prefixo adequado. Para isso, considere `#3` para
usar um prefixo ou `#4` para usar um diretório para imagens de cada
matéria. Em `#5` e `#6` especifica-se as dimensões da figura, a
resolução e formato que tem-se mostrado sufientes para uso em blog. O
uso de `#7` é para obter uma fonte nos gráficos mais compatível com a
fonte do texto no blog.

```{r}
opts_chunk$set(
    fig.path="post_001-",              #3
    ## fig.path="post_001/",           #4
    fig.width=6, fig.height=6,         #5
    dpi=90, dev="png",                 #6
    dev.args=list(family="Helvetica")) #7

```

****
## Usando o `knitr` e `RWordPress`

Como mencionado, será considerado o pacote **knitr** processar os
chunks. Para subir a matéria para o blog, poupando tempo e trabalho
manual, será considerado o pacote **RWordPress**. Ele não é um pacote
oficial mas ainda é simples instalá-lo.

```{r}
install.packages("RWordPress", repos="http://www.omegahat.org/R",
                 type="source")

```

Considere que a matéria seja o arquivo `materia.Rmd`. A porção de código
abaixo carrega os pacotes mencionados, recebe as informações do autor e
endereço do blog e, por fim, cria uma nova matéria (modo rascunho, sem
públicar) e atualiza da matéria por meio do seu id. Note nos argumentos
da `knit2wp()` que é possível especificar título, categorias e
palavras-chave.


```{r}
## Carrega pacotes.
library(knitr)
library(RWordPress)

## Informações do autor e do blog.
options(WordpressLogin=c(autor_do_blog="senha_do_autor"),
        WordpressURL="http://blog.leg.ufpr.br/xmlrpc.php")

## Sobe a matéria.
knit2wp("materia.Rmd",
        title="Minha fantástica matéria",
        categories="gráficos",
        mt_keywords=c("xyplot", "panel.groups"),
        action="newPost",
        publish=FALSE)

## Atualiza a matéria.
knit2wp("materia.Rmd",
        title="Minha fantástica matéria",
        categories="gráficos",
        mt_keywords=c("xyplot", "panel.groups"),
        action="editPost", postid=99,
        publish=FALSE)

```

Não é uma exigência usar a `knit2wp()` mas é muito recomendado que se
faça. Caso considerar não usar, deve-se aplicar `knit2html()`, abrir o
arquivo em um editor de texto e recortar apenas o conteúdo do campo
`<body>`. Isso dá trabalho! Para encurtar, use a versão modificada da
`knit2wp()`, que ao invés de subir a matéria para o blog, salva o que
seria ser levado em um arquivo. O conteúdo desse arquivo deve ser
copiado e colado na janela de edição do blog. Lembre-se de adicionar
título, categoria e palavras-chave.

```{r}
knit2wp_mod <- function(
    input, title = "A post from knitr", ..., shortcode = FALSE, 
    action = c("newPost", "editPost", "newPage"), postid,
    encoding = getOption("encoding"), publish = TRUE)
{
    out = knit(input, encoding = encoding)
    on.exit(unlink(out))
    con = file(out, encoding = encoding)
    on.exit(close(con), add = TRUE)
    content = native_encode(readLines(con, warn = FALSE))
    content = paste(content, collapse = "\n")
    content = markdown::markdownToHTML(text = content, fragment.only = TRUE)
    shortcode = rep(shortcode, length.out = 2L)
    if (shortcode[1]) 
        content = gsub("<pre><code class=\"([[:alpha:]]+)\">(.+?)</code></pre>", 
            "[sourcecode language=\"\\1\"]\\2[/sourcecode]", 
            content)
    content = gsub("<pre><code( class=\"no-highlight\"|)>(.+?)</code></pre>", 
        if (shortcode[2]) 
            "[sourcecode]\\2[/sourcecode]"
        else "<pre>\\2</pre>", content)
    content = native_encode(content, "UTF-8")
    title = native_encode(title, "UTF-8")
    ## action = match.arg(action)
    ## WPargs = list(content = list(description = content, title = title, 
    ##     ...), publish = publish)
    ## if (action == "editPost") 
    ##     WPargs = c(postid = postid, WPargs)
    ## do.call("library", list(package = "RWordPress", character.only = TRUE))
    ## do.call(action, args = WPargs)
    writeLines(text=content,
               con=gsub(x=out, pattern="\\.md$", replacement=".html"))
}

```

****
## Matérias encaminhadas para o R-bloggers

Para que a matéria seja exibida no [R-bloggers][], atribua a categoria
`rbloggers_en` para matérias em inglês e `rbloggers_pt` para
português. Materias que não tem conteúdo compatível com o R-bloggers não
devem estar nessas categorias.

****
## Template `Rmd`

Abaixo tem-se um template simples de uma matéria com figura e tabela.

    ```{r setupknitr, include=FALSE}
    opts_knit$set(
        base.dir="/home/walmes/blog/",
        base.url="http://blog.leg.ufpr.br/~walmes/")
    
    opts_chunk$set(
        fig.path="materia001/"
        fig.width=6, fig.height=6,
        dpi=90, dev="png",
        dev.args=list(family="Helvetica"))
        
    ```
    
    ## Introdução
    
    Sed ut perspiciatis unde omnis iste natus error sit voluptatem
    accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab
    illo inventore veritatis et quasi architecto beatae vitae dicta sunt
    explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut
    odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
    voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum
    quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam
    eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat
    voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam
    corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
    Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse
    quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo
    voluptas nulla pariatur?
    
    ## Produzindo uma figura
    
    Abaixo temos uma figura usando a função `xyplot` da biblioteca gráfica
    `lattice` desenvolvida por [Depayan Sarkar](https://plus.google.com/+DeepayanSarkar/posts).
    
    ```{r}
    ##-------------------------------------------
    
    require(lattice)
    
    xyplot(dist~speed, data=cars, type=c("p","smooth"))
    
    ```
    
    ```{r, echo=FALSE}
    
    histogram(~precip, col="red")
    
    ```
    
    Abaixo temos o resumo do ajuste do modelo de regressão linear simples
    aos dados apresentados no diagrama de dipersão.
    
    ```{r}
    ##-------------------------------------------
    
    m0 <- lm(dist~speed, data=cars)
    summary(m0)
    
    ```
    
    Abaixo uma tabela exportada para html com a função `knitr::kable()`
    
    ```{r}
    
    kable(head(iris), format = "html", caption = "Title of the table")
    
    ```
    
## Enviar figuras para o diretório público

Para enviar figuras para o diretório público pode-se considerar o
comando `scp` ou `rsync`. Abaixo considera-se `rsync` com instruções
para manter o diretório remoto com os mesmos arquivos do diretório local.

```{shell}
rsync -avzh --progress --delete -e "ssh -p PPPP" /home/walmes/blog/ walmes@XX.XX.XXX.XX:/home/walmes/public_html/

```

Por conveniência, pode-se fazer o `rsync` na sessão R em que se usou `knit2wp()`.

```{r}
cmd.rsy <- sprintf(
    "rsync -avzh --progress --delete -e \"ssh -p %d\" %s %s",
    PPPP, "/home/walmes/blog/",
    "walmes@XXX.XX.XXX.XX:/home/walmes/public_html/")

```

[MarkDown]: http://lifehacker.com/5943320/what-is-markdown-and-why-is-it-better-for-my-to-do-lists-and-notes
[knitr]: http://yihui.name/knitr/
[opções de chunk]: http://yihui.name/knitr/options/#chunk_options
[R+markdown]: http://kbroman.org/knitr_knutshell/pages/Rmarkdown.html
[opções do pacote]: http://yihui.name/knitr/options/#package_options
[base64]: http://davidbcalhoun.com/2011/when-to-base64-encode-images-and-when-not-to/
[R-bloggers]: http://www.r-bloggers.com/
