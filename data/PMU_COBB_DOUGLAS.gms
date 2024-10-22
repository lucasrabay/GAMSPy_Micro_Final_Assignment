
$title Modelo do consumidor 

$ontext
1 - Exemplo da resolução numérica do problema do consumidor, considerando dois bens e uma função
Utilidade COBB-DOUGLAS

2 - Nesse caso, foi criado um SET com dez componentes (P1 até p10) para fazer a indexação, conforme classificação da POF

3- Nesse exemplo, foi criando um SET para diferenciar os tipos de familias em sete categorias, conforme classificação da POF. As variáveis relacionadas ao consumidor, foram idexadas por tipo de família

$offText



*Os resultados serão apresentados com 6 casas decimais
OPTION decimals=6;

*Declarando conjunto para os produtos
Set I /P1*P10/

*declarando o conjunto para as famílias 
;
set H /HH1*HH7/
;

* comando ALIAS cria um set "TRANSPOSTO J" para o set dos produtos I
alias (I,J)
;
*Declarando os paramentos do modelo
Parameter
*valores inciais para as variávies do modelo

P0(I)      Precos inicial dos bens 
M0(H)      Renda inicial dos consumidores
X0(I,H)    Quantidade inicial do bens
U0(H)      Utilidade inicial

*parametros da funcão COBB-DOUGLAS
alpha(I,H) Expoente da funcao cobb-douglas
*dados sobre o consumo das familias (origem na POF)
;
table consumo(I,H)

     HH1     HH2     HH3     HH4      HH5     HH6     HH7
P1   321     466     592     758     962     1317    2007 
p2   454     613     1003    1504    2038    2592    3403 
P3   56      81      150     239     380     518     631 
P4   115     186     438     910     1035    1974    2928 
P5   76      110     160     208     322     439     360 
P6   68      127     223     445     552     797     1159 
P7   34      58      125     301     465     510     603 
P8   27      43      98      136     245     319     850 
P9   8        7      12      18      10      8        47 
P10  13      21      35      75      133     160     220 

    
;
*atribuindo o valor inicial para o preço
P0(I)=1;
*atribuindo o valor inicial para a renda
M0(H)=sum(I, P0(I)*(consumo(I,H));

*calculado os valores inicias para o consumo e para o parametro da funcal cobb-douglas
loop(H,
X0(I,H) = consumo(I,H)/P0(I);
alpha(I,H)= P0(I)*X0(I,H)/M0(H);
);

*calculando o valor inicial para a utilidade
U0(H) = prod(I, X0(I,H)**alpha(I,H));

*declarando as variáveis do modelo
Variables

X(I,H) Quantidade do bem I consumido pela familia H
M(H)   Renda da familia H
P(I)   Preco do bem 
U(H)   Utilidade 
UMAX   Variavel de maximizacao
;

* declarando as equacoes do modelo
Equations

F_utilidade(H)    Funcao utilidade
R_orcamentaria(H) Restricao orcamentaria
MAX_func          Funcao objetivo
;

*especificando as formas funcionais das equacoes

F_utilidade(H)..  U(H) =E= prod(I, X(I,H)**alpha(I,H));

R_orcamentaria(H).. M(H) =E= sum(I,P(I)*X(I,H));

* a funcao objetivo e a soma das utilidades por tipo de familia.
MAX_func..        UMAX=E=sum(H,U(H));

*definindo o modelo "consumidor_cobb_douglas"com base no script acima

model consumidor_cobb_douglas /all/;
*fixando os valores dos precos e da renda (sufixo .fx). os consumidores tomam como dado os precos e a renda.
P.FX(I)=P0(I);
M.FX(H)=M0(H);

*valores iniciais para as variaveis livres(.l) (variavais que o gams vai calcular)

X.L(I,H)= X0(I,H);
U.L(H) = U0(H);
UMAX.L=SUM(H,U0(H));

*testando como uma mudanca no preco afeta a demanda pelos diversos bens da economia.
*aumenta-se o preço do bem 1 em 1%, igualando o preço do bem i P.FX("P1") a 1.01 do preço inicial do bem i (P0("P1"))
P.FX("p1")=1.0*P0("p1");


*resolvendo o problema de maximizacao de utilidade de todas as familias.

solve consumidor_cobb_douglas using NLP maximizing UMAX;

*dando um display nos resultados obtidos para o consumo e a utilidade

display X.l, U.l;

*A seguir, uma forma de calcular os impactos da mudança no preço do bem 1 sobre a utilidade e 

*Inicialmente, define-se os elementos que representarao os valores dos impactos
Parameter

Impacto_utilidade(H) Impacto da mudança de preço sobre a Utilidade de cada tipo de família
Impacto_consumo(I,H) Impacto da mudança de preço sobre o consumo de cada bem por tipo de familia
;

* O impacto sobre a utilidade é igual a utilidade calculada (U.L(H)) menos a utilidade inicial (U0), dividido pela utilidade inicial
Impacto_utilidade(H) = 100*((U.L(H) - U0(H))/U0(H));

* o impacto sobre o consumo é igual ao consumo calculado (X.L(I,H)menos os valores iniciais do consumo (X0), dividido pelo valores iniciais do consumo (X0)
Impacto_consumo(I,H) =100*(X.L(I,H)-X0(I,H))/X0(I,H);
*É esperado que um aumento no preço do bem 1 reduza apenas consumo do bem 1, não havendo efeitos sobre o consumo do demais bens, pois na funcao cobb-douglas não há efeito substituiçao

*exibindo os valores dos impactos calculados
display Impacto_utilidade, impacto_consumo;










