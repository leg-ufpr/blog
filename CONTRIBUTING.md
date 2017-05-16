# Guia de postagem do Blog do LEG

## Escrevendo a matéria

As matérias para o blog (ou *posts*) podem ser escritos em [MarkDown][]
pleno.  Na grande maioria das vezes, as matérias vão considerar porções
de código, como tutoriais de R, comandos executados em shell e dicas de
LaTeX e, portanto, escrever documentos em markdown ou RMarkdown salva
tempo, principalmente quando o código precisar ser interpretado e
figuras/tabelas precisam ser inseridas.  Dessa forma, esse documento tem
o objetivo de documentar o procedimento de escrever uma matéria em
RMarkdown.  Assume-se, no entanto, que o leitor já tenha conhecimento do
[RMarkdown][], conheça o pacote [knitr][], as [opções de chunk][] e
saiba transformar o documento em html.

## Organização do repositório

Cada matéria deve estar em um diretório.  O nome do diretório deve ser
precedido com a data da matéria no formato Y-m-d e um termo chave,
e.g. `2017-03-21-nuvem-tags`, `2017-05-15-familia-apply`.  Dentro do
diretório, o arquivo `main.Rmd` deve conter o código da matéria.  Se a
matéria precisar de arquivos auxiliares (`.bib`, `.txt`, `.csv`,
`.RData`, etc) eles devem estar dentro do diretório, podendo estar em
subpastas se isso conferir maior organização.

O arquivo `main.Rmd` deve ter o cabeçalho yaml no topo com os seguintes
campos preenchidos conforme indicado na próxima sessão. É importante que
contenha o título, autor, *tags* e *categories* para facilitar a
aplicação de filtros e reconstruir o blog, caso necessário.

Deve ser versionado apenas o código fonte da matéria.  Portanto, o
fragmento html gerado não deve ser versionado.

O diretório `config/` tem arquivos de configuração que potencialmente
serão usados em todas as matérias, como o arquivo `setup.R` que
configura as dimensões e fontes usadas nas figuras.

## Fragmento html

As matérias são incluídas no blog a partir de fragmentos html.  Deve-se
usar o classe `html_fragment` como formato de documento do RMarkdown
(TODO veja abaixo.

As figuras são representadas na encriptação base64 para geração de um
fragmento autocontido.  Para inserir figuras externas, use a função
`knitr::include_graphcis()`.

Veja o arquivo `config/templates.Rmd` para um exemplo de escrita de
matéria.

## Matérias encaminhadas para o R-bloggers

Para que a matéria seja exibida no [R-bloggers][], atribua a categoria
`rbloggers_en` para matérias em inglês e `rbloggers_pt` para português.
Materias que não tem conteúdo compatível com o R-bloggers não devem
estar nessas categorias.

<!------------------------------------------- -->

[MarkDown]: http://lifehacker.com/5943320/what-is-markdown-and-why-is-it-better-for-my-to-do-lists-and-notes
[knitr]: http://yihui.name/knitr/
[opções de chunk]: http://yihui.name/knitr/options/#chunk_options
[Rmarkdown]: http://kbroman.org/knitr_knutshell/pages/Rmarkdown.html
[opções do pacote]: http://yihui.name/knitr/options/#package_options
[base64]: http://davidbcalhoun.com/2011/when-to-base64-encode-images-and-when-not-to/
[R-bloggers]: http://www.r-bloggers.com/
