# Evolução de Soja 2023-2024
Frequência: atualização semanal

### Definição do problema
Este relatório deve possibilitar que algumas perguntas fundamentais sejam respondidas facilmente ao visualizar os dados no painel:
1. Todos os clientes planejados estão sendo realizados?
2. O cliente planejado está recebendo as variedades planejadas?
3. Os obtentores planejados são os mesmos realizados? Ou as filiais estão utilizando cultivares de obtentores diferentes? Se sim, por quê?

E como a base utilizada possui apenas variáveis com dados qualitativos, as perguntas acima são respondidas com gráficos que demonstram a frequência de categorias-chaves.

### Preparação dos dados
Os dados recebidos apresentam ausência de padronização em algumas variáveis-chaves como: nome do cliente, nome da cultivar. Além de vir com linhas duplicadas. Então, é necessário remover as duplicadas e padronizar os nomes dos clientes e das cultivares.

### Análise exploratória dos dados
No relatório, foquei inicialmente em realizar análises básicas como:
1. Contagem de regional por cliente e cultivar
2. Contagem de filial por cliente e cultivar
3. Contagem de CTV por cliente e cultivar
4. Participação de um obtentor em relação a todos os obtentores planejados
5. Participação de um obtentor em relação a todos os obtentores realizados

### Visualização dos resultados
Para a proposta acima, preciso apenas das variáveis seguintes na base de dados:
| Período | Regional | Filial | CTV | Cliente | Cultivar | Obtentor |
|---------|----------|--------|-----|---------|----------|----------|
| Planejado |        |       |          |       |        |          |
| Realizado até dd/mm/aa |      |       |      |      |       |          |

Com essa base de dados, gerei um gráfico comparando a cultivar (eixo X) com a contagem de cliente (eixo Y), incluindo como legenda o período, para que seja possível comparar os dados planejados com os realizados.

![Captura de tela 2023-12-26 111849](https://github.com/elisamaribeiro/job-analise-de-agronegocio/assets/125142048/d36b7eb3-db5e-4996-a201-4478ed9d0f84)

Para facilitar a visualização dos diretores e gerentes, inclui como filtros a regional, a filial, o nome do CTV responsável, nome do cliente e o obtentor.

<img width="323" alt="image" src="https://github.com/elisamaribeiro/job-analise-de-agronegocio/assets/125142048/ec190f32-0da5-4604-986f-4434d4b32116">

Além disso, inclui dois quadros para mostrar, de acordo com os filtros selecionados, o total de áreas planejadas e o total de áreas realizadas.

<img width="214" alt="image" src="https://github.com/elisamaribeiro/job-analise-de-agronegocio/assets/125142048/42946939-38e6-4df2-bcfc-95a2d215a85a">

Para finalizar, também apresentei dois quadros com a participação dos obtentores em relação ao total. Sendo que o primeiro foi em relação aos valores planejados, e o segundo os realizados.

![Captura de tela 2023-12-26 112321](https://github.com/elisamaribeiro/job-analise-de-agronegocio/assets/125142048/2d581698-c1a8-4497-848c-53760545dfa9)

O relatório inteiro ficou com essa aparência, porém diariamente faço ajustes pontuais:

![Captura de tela 2023-12-26 112447](https://github.com/elisamaribeiro/job-analise-de-agronegocio/assets/125142048/13ecad67-411d-48ed-8612-a124cd740911)
