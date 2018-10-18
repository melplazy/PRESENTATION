# Introduction
## Interagir avec julia: le mode non-interactif
julia -e "for x in ARGS ; println(x) ; end" Hello Bye

echo 'for x in ARGS ; println(x) ; end' > script.jl
julia script.jl Hello Bye


## Interagir avec julia: le mode interactif
? quit
; echo 'x = 1; for x in ["A" 2]; println(x); end' > script.jl

pwd()
include("script.jl")
whos()
workspace(); whos()


# Les bases de Julia
## Les opérateurs
x = [1 2 3]
2x + 1
y = [10, 5, 21]
x + y
x + y'

x .+ y
broadcast(+, x, y)
true || false
true && true
1 < 2 < 3
[1 2 3] .< [4 1 6]

## Les numériques
2 + 2
1/3
1//3
1/3 == float(1//3)


## Les variables
valeurPI = "Que j'aime a faire connaitre un nombre utile aux sages"
valeurpi = 3.1415926535
π
pi
ans

pi = 1


## Les chaines de caractères
x = 8; machaine = "Le sens de la vie? $(2(x-1)^2 - 3(x+9) - 5)"
string(machaine," (H2G2)")
"machaine" * " (H2G2)"


## Les tuples
()
x = (1, 2)
x[3]
a, b = x
a
b


## Les tableaux (arrays)
### Construire des tableaux
[1, 2, 3, 4, 5]
[i for i = 1:5]
[1:5]

[1 2 3 4 5]
[i+j for i = 1:5, j = 1:5]

[[1:5] [6:10]]
cat(2, [1:5], [6:10])

### Accéder au contenu des tableaux
myarray = [i+j for i = 1:5, j = 1:5];

myarray[1:5, 1:5]
myarray[1:5, 1:end]
myarray[1:2, :]
myarray[4:end, :]


## Déclaration de Type
### Déclaration d’un Type à Julia
type MonType
    x::Int
    y::Float64
end

p = MonType(2, 3)
typeof(ans)
names(p)
p.x


## Les dictionnaires
Dict{Float64, Int64}()
(Float64=>Int64)[1.1=>1, 2=>2]
dico = {"key"=>1, (2,3)=>true}
dico[(2, 3)]


## Les blocs d'expressions
z = begin
        x = 1
        y = 2
        x + y
    end
z = begin x = 1; y = 2; x + y end

z = (x = 1;
    y = 2;
    x + y)
z = (x = 1; y = 2; x + y)


## Les tests de conditions
x=2; y=3;

if x <= y
    "x <= y"
else
    "x > y"
end

if x < y
    "x < y"
elseif x > y
    "x > y"
else
    "x = y"
end

x <= y ? "x <= y" : "x > y"
x < y ? "x < y" : x > y ? "x > y" : "x = y"


## Les boucles
### Les boucles I
for i = 1:5
    println(i)
end
for i in [1:5]
    println(i)
end
for i in [1, 2, 3, 4, 5]
    println(i)
end

i = 1;
while i <= 5
    println(i)
    i += 1
end

### Les boucles II
for i = 1:3
    i == 2 ? break : println(i)
end
for i in [1:3]
    i == 2 ? continue : println(i)
end

for i = ["A", "B"]
    for j = [1:2]
        println((i,j))
    end
end
for i in ["A", "B"], j in [1:2]
    println((i,j))
end


## Les fonctions
### Définir une fonction
function f(x,y)
    x + y
end
f(x,y) = x + y

### Renvoyer le résultat d’une fonction
function f(x,y)
    x * y
    return x + y
end
function f(x,y)
    return x * y
    x + y
end

myfunction(x,y) = (x,y)
a,b = myfunction(2,3)

### Fonction et Type
f(x::Int64) = print("x est un entier: ", x)
f(7)
f("chaine")

### Gérer les ambiguïtés
f(x::Float64, y) = 2x + y
f(x, y::Float64) = x + 2y
methods(f)
f(x::Float64, y::Float64) = 2x + 2y


# Mise en pratique
## Exemple: Génèrer des données
function genere(nind::Int, ncpg::Int)
    rand(nind, ncpg)
end
genere(nind::Int, ncpg::Int) = rand(nind, ncpg)

function effet(M::Array{Float64, 2}, beta::Float64)
    min(M+beta, 1)
end
effet(M::Array{Float64, 2}, beta::Float64) = min(M+beta, 1)


nind = (2,3); ncpg = 10;
dns = genere(sum(nind), ncpg)
ncas, ncontrole = nind
dns[1:ncas, :] = effet(dns[1:ncas, :], 0.2)

individus = ["Individus$i" for i in 1:sum(nind)]

statut = [["cas" for i in 1:ncas], ["controle" for i in 1:ncontrole]]

function simule(nind::(Int,Int), ncpg::Int)
    dns = genere(sum(nind), ncpg)
    ncas, ncontrole = nind
    dns[1:ncas, :] = effet(dns[1:ncas, :], 0.2)
    individus = ["Individus$i" for i in 1:sum(nind)]
    statuts = [["cas" for i in 1:ncas], ["controle" for i in 1:ncontrole]]
    return transpose(hcat(individus, statuts, dns))
end



## Lire et écrire des données
dta = simule((14, 16), 200);
writedlm("methylation.txt", dta, '*')

readdlm("methylation.txt", "*")
readdlm("methylation.txt", '*')


## Messages et erreurs
info("Bonjour!")
warn("Bonjour!")
error("Bonjour!")

x = -1
sqrt(-1)
try
    sqrt(x)
catch
    sqrt(complex(x,0))
end


## Décrire des données
function summarystat(x::Array{Float64, 2}, dim::Int)
    if dim==0
        res = hcat(
            mean(x), minimum(x), maximum(x),
            median(x), std(x)
        )
    else
        res = cat(dim,
            mean(x, dim), minimum(x, dim), maximum(x, dim),
            median(x, dim), std(x, dim)
        )
    end
    dim==1 ? transpose(res) : res
end


isascii2(x) = try isascii(x) catch; false end
function resume (M::Array)
    testascii = broadcast(isascii2, M[:, 1])
    entete = M[findin(testascii, true), :]
    data = float(M[findin(testascii, false), :])

    noms = entete[1, :]
    statuts = entete[2, :]
    indexcas = findin(statuts.=="cas", true)
    indexcontrole = findin(statuts.=="controle", true)

    tmp = vcat(
        ["moy" "min" "max" "med" "std"], # vcat("moy", "min", "max", "med", "std")
        summarystat(data[:, indexcas], 0),
        summarystat(data[:, indexcontrole], 0),
        summarystat(data, 1)
    )

    resultat = hcat(
        transpose(["" "cas" "controle" noms]), # hcat("", "cas", "controle", noms)
        tmp
    )
    return resultat
end


# Calcul parallèle
## Lancer Julia en parallèle
julia -p 2

r = remotecall(2,rand,3,3)
fetch(r)

s = @spawnat 2 2*fetch(r)
fetch(s)


## Les boucles
ntirages = @parallel (+) for i in [1:1000000]
    int(randbool())
end

pmap(x -> x.>0.5, [rand(1) for i in [1:40000]])


## Exemple: Des calculs en parallèle
function resume (M::Array, method::Int)
    noms = M[1, :]

    statuts = M[2, :]
    indexcas = findin(statuts.=="cas", true)
    indexcontrole = findin(statuts.=="controle", true)

    testascii = broadcast(isascii2, M[:, 1])
    cherchenum = findin(testascii, false)
    N = float(M[cherchenum, :])

    x1 = {N[:, indexcas], N[:, indexcontrole], N}
    x2 = [0 0 1]

    if method==1
        println("@parallel method")
        tmp = @sync @parallel vcat for i in [1:3]
            summarystat(x1[i], x2[i])
        end
    else
        println("pmap method")
        tmp = pmap(summarystat, x1, x2)
        tmp = reduce(vcat, tmp)
    end
    tmp = vcat(["moy" "min" "max" "med" "std"], tmp)

    resultat = hcat(
        transpose(["" "cas" "controle" noms]),
        tmp
    )
    return resultat
end


@everywhere function summarystat(x::Array, dim::Int)
    if dim==0
        res = hcat(
            mean(x), minimum(x), maximum(x),
            median(x), std(x)
        )
    else
        res = cat(dim,
            mean(x, dim), minimum(x, dim), maximum(x, dim),
            median(x, dim), std(x, dim)
        )
    end
    dim==1 ? transpose(res) : res
end

res1 = resume(dta, 1);
res2 = resume(dta, 2);
res1 == res2


# Les paquets
## Installer un paquet
Pkg.add("GLM")
using GLM

Pkg.status()
Pkg.installed()

Pkg.update()

Pkg.clone("git://example.com/path/to/Package.jl.git")
Pkg.rm("GLM")


## Exemple : Charger et utiliser un paquet
using GLM, DataFrames;

dta = simule((14, 16), 200);
dta2 = convert(DataFrame, transpose(dta)); # Conversion de type

vrainom = [["nom" "statut"] ["x$j" for i in 1, j in 1:size(dta2, 2)-2]]; # Noms des colonnes
rename!(dta2, names(dta2), convert(Array{Symbol, 2}, vrainom)); # Renomme les colonnes

dta2[:statut2] = int(dta2[:statut].=="cas"); # Ajoute une colonne statut2 en binaire

fit(LinearModel, x1~statut2, dta2)


## Petit benchmark Julia et R
dta = simule((140, 160), 1000);
dta2 = convert(DataFrame, transpose(dta));
vrainom = [["nom" "statut"] ["x$j" for i in 1, j in 1:size(dta2, 2)-2]];
rename!(dta2, names(dta2), convert(Array{Symbol, 2}, vrainom));
dta2[:statut2] = int(dta2[:statut].=="cas");
writetable("dta.txt", dta2);

### Julia
@everywhere using GLM, DataFrames;
dta = readtable("dta.txt");
nombrevariable = sum(map((x)->ismatch(r"x[0-9]*", string(x)), names(dta)));
alltime = Float64[1:100];
for j in 1:100
    jtime = @elapsed @parallel hcat for i in 1:nombrevariable
        fit(LinearModel, eval(parse("x$i~statut2")), dta)
    end
    alltime[j] = jtime
end
(mean(alltime), std(alltime))

library(parallel)
dta = read.delim("dta.txt", sep = ",")
nombrevariable = length(grep("x[0-9]*", colnames(dta)))
alltime = 1:100
for (j in 1:100) {
    alltime[j] = system.time({
        mclapply(1:nombrevariable, mc.cores = 2, function (i) {
            eval(parse(text = paste0("summary(lm(x", i, "~statut2, data = dta))")))
        })
    })[["elapsed"]]
}
c(mean(alltime), sd(alltime))


## Le dessin n’est pas la forme, il est la manière de voir la forme
Pkg.add("Gadfly"); Pkg.add("Cairo");
using Gadfly, Cairo, DataFrames;

dta = simule((14, 16), 200);
dta2 = convert(DataFrame, transpose(dta)); # Conversion de type
vrainom = [["nom" "statut"] ["x$j" for i in 1, j in 1:size(dta2, 2)-2]]; # Noms des colonnes
rename!(dta2, names(dta2), convert(Array{Symbol, 2}, vrainom)); # Renomme les colonnes
dta2[:statut2] = int(dta2[:statut].=="cas"); # Ajoute une colonne statut2 en binaire

p = plot(x=rand(10), y=rand(10))
draw(PNG("plot1.png", 7.5cm, 6cm), p) # Ecriture de l'image

p1 = plot(dta2, x = "statut", y = "x1", color = "statut")

p2 = plot(
    dta2, x = "statut", y = "x1", color = "statut", Geom.boxplot,
    Scale.color_discrete_manual("firebrick2", "dodgerblue"),
    Guide.title("Le titre")
)

p3 = plot(
    dta2,
    layer(x = "statut", y = "x1", color = "statut", Geom.boxplot),
    layer(x = "statut", y = "x1", color = "statut", Geom.point)
)

using PyPlot
surf(rand(30,40))


## Les modules
module MonModule
    export x
    x = 1
    y = 2 # variable cachee
end
whos(MonModule)
names(MonModule)
(MonModule.x, MonModule.y)

using MonModule
x
y


import MonModule.y
y


## Les macros
:( println("Hello, world!") )
typeof(ans)
eval(:( println("Hello, world!") ))

macro premieremacro(mot1, mot2)
    return :( println($mot1, $mot2) )
end

@premieremacro("Hello, ", "world!")
@premieremacro "Hello, " "world!"


# Appel de fonctions
## Exécuter des commandes externes
run(`echo hello`)
res = readall(`echo hello`)

## Appel de fonctions Python
Pkg.add("PyCall")
using PyCall

pyeval("1+1")
@pyimport math
pycall(math["sin"], Float64, 1)
math.sin(math.pi / 4) - sin(pi / 4)

@pyimport matplotlib.pyplot as plt
x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x));
plt.plot(x, y, color="red", linewidth=2.0, linestyle="--");
plt.show()

## Appel de fonctions C
t = ccall( (:clock, "libc"), Int32, () )
typeof(ans)





