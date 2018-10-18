###############################################################
function genere(nind::Int, ncpg::Int)
    rand(nind, ncpg)
end
genere(nind::Int, ncpg::Int) = rand(nind, ncpg)
genere(5, 7)


###############################################################
function effet(M::Array{Float64, 2}, beta::Float64)
    min(M+beta, 1)
end
effet(M::Array{Float64, 2}, beta::Float64) = min(M+beta, 1)
effet([0.0 for i in 1:5, j in 1:7], 0.5)
effet(genere(5, 7), 0.5)


###############################################################
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
simule((2, 3), 10)


###############################################################
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
summarystat(rand(25,4), 0)


###############################################################
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
dta = simule((14, 16), 200);
resume(dta)


###############################################################
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



###############################################################
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
