```{r}
settings.table <- data.frame(matrix(NA, nrow = 9, ncol = 2, dimnames = list(NULL, c("Parameters", "Values"))))
settings.table[, "Parameters"] <- c("Number of participants ($n$)", "Number of measures ($m$)", "Diabetes incidence rate ($d$)", "Minor allele frequency ($f$)", "Random effects ($\\theta$)", "SNP effect on $Y_{ij}$ ($\\gamma$)", "SNP effect on $T_i$ ($\\alpha$)", "Association between $Y_{ij}$ and $T_i$ ($\\beta$)", "Error term ($\\epsilon$)")
settings.table[, "Values"] <- c(
  format(rawsettings$n+1, big.mark = ","), 
  4, 
  signif(rawsettings$d, digits = 3), 
  signif(rawsettings$maf, digits = 3),
  paste0(
    "$\\sim\\mathcal{N}_2\\left (\\begin{bmatrix}", 
    formatScientific(rawsettings$thetas[1]), "\\\\", 
    formatScientific(rawsettings$thetas[2]), 
    "\\end{bmatrix} , \\begin{bmatrix} ", 
    formatScientific(rawsettings$Epsilon_thetas[1, 1]), " & ", 
    formatScientific(rawsettings$Epsilon_thetas[1, 2]), " \\\\ ", 
    formatScientific(rawsettings$Epsilon_thetas[2, 1]), " & ", 
    formatScientific(rawsettings$Epsilon_thetas[2, 2]), " \\end{bmatrix} \\right )$"
  ),
  signif(rawsettings$gamma, digits = 3), 
  signif(rawsettings$alpha[2], digits = 3), 
  signif(rawsettings$beta, digits = 3), 
  paste0("$\\sim\\mathcal{N}(0,", signif(rawsettings$sigma, digits = 3), "^2)$")
)


pretty_kable(
  data = settings.table, 
  caption = paste0('Parameters and numerical values used for sensitivity analysis and simulations, based on results from ', bestEffect[, "snp"], ' within gene _', bestEffect[, "closestgene"], '_ in the French cohort D.E.S.I.R.'),
  align = c("l", "c"),
  escape = TRUE
)
```


\begin{frame}{\subsecname: \subsubsecname}
    Puissance statistique pour détecter un effet joint du SNP rs17747324 (\textit{TCF7L2}), à partir de la formule développée par \citep{chen_sample_2011}:\\[1em]

    \begin{minipage}[t]{0.475\columnwidth}
        \vspace{0em}
        \begin{gather*}
            \textcolor{black}{H_0:\ }\beta\gamma+\alpha=0\\
            d=\frac{(z_{\tilde{\beta}}+z_{1-\tilde{\alpha}})^2}{f(1-f)(\beta\gamma+\alpha)^2}\\
            z_{\tilde{\beta}}=\pm\sqrt{df(1-f)(\beta\gamma+\alpha)^2}+z_{1-\tilde{\alpha}}
        \end{gather*}
    \end{minipage}%
    \hfill\vline\hfill
    \begin{minipage}[t]{0.475\columnwidth}%
        \vspace{1em}
        avec:
        \begin{description}
            \item[$d$] le nombre de T2D incidents,
            \item[$f$] la fréquence de l'allèle à risque,
            \item[$\tilde{\alpha}$] le seuil de significativité,
            \item[$\tilde{\beta}_{\tilde{\alpha}}$] la puissance statistique au seuil $\tilde{\alpha}$.
        \end{description}
        \vspace{1em}
    \end{minipage}
    \vspace{1em}
    \begin{center}$\textcolor{firebrick2}{\Rightarrow}\tilde{\beta}_{\tilde{\alpha}}=46,56\%$ pour rs17747324 (\textit{TCF7L2})\end{center}
\end{frame}


\subsubsection{Résultats}
\begin{frame}{\subsecname: \subsubsecname}
    \begin{center}
        {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig10.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}\'Etude de simulation de l'estmation $\color{springgreen3}\hat{\gamma}$ du Modèle Joint (extension \textit{JM}) et de l'approche en ``deux étapes'' (extension \textit{nlme}).}
    \end{center}
\end{frame}


\begin{frame}{\subsecname: \subsubsecname}
    \begin{center}
        {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig11.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}\'Etude de simulation de l'estmation $\color{springgreen3}\hat{\beta}$ du Modèle Joint (extension \textit{JM}) et de l'approche en ``deux étapes'' (extension \textit{nlme}).}
    \end{center}
\end{frame}


\begin{frame}{\subsecname: \subsubsecname}
    \begin{center}
        {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig09.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}\'Etude de simulation de l'estmation $\color{springgreen3}\hat{\alpha}$ du Modèle Joint (extension \textit{JM}) et de l'approche en ``deux étapes'' (extension \textit{nlme}).}
    \end{center}
\end{frame}


\begin{frame}{\subsecname: \subsubsecname}
    \begin{center}
        {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig15.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}Comparaison des résultats des approches par Modèle Joint et en ``deux étapes''.}
    \end{center}
\end{frame}


\begin{frame}{\subsecname: \subsubsecname}
    \begin{center}
        {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig12.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}Comparaison des résultats des approches par Modèle Joint et en ``deux étapes''.}
    \end{center}
\end{frame}


\begin{frame}{\subsecname: \subsubsecname}
    \everymath{\color{black}}
    \begin{center}
        \begin{table}
            \begin{tabular}{ccccc}
                \hline
                & \multicolumn{2}{c}{\textcolor<2>{maroon2}{Modèle Joint}} & \multicolumn{2}{c}{\textcolor<2>{dodgerblue}{Modèle ``deux-étapes''}}\\
                \hline
                Nombre & \textcolor<2>{maroon2}{Moyenne} & \multirow{2}{*}{\textcolor<2>{maroon2}{100K SNPs}} & \textcolor<2>{dodgerblue}{Moyenne} & \multirow{2}{*}{\textcolor<2>{dodgerblue}{100K SNPs}}\\
                d'individu & \textcolor<2>{maroon2}{(\'Ecart-Type)} &  & \textcolor<2>{dodgerblue}{(\'Ecart-Type)} & \\
                \hline
                500 & \textcolor<2>{maroon2}{51 s ($\textcolor<2>{maroon2}{3,4}$)} & \textcolor<2>{maroon2}{59 j} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{0,71}$ s ($\textcolor<2>{dodgerblue}{0,066}$)} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{0,82}$ j}\\
                2\ 500 & \textcolor<2>{maroon2}{100 s (11)} & \textcolor<2>{maroon2}{120 j} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{3,1}$ s ($\textcolor<2>{dodgerblue}{0,092}$)} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{3,6}$ j}\\
                5\ 000 & \textcolor<2>{maroon2}{180 s (25)} & \textcolor<2>{maroon2}{210 j} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{6,3}$ s ($\textcolor<2>{dodgerblue}{0,17}$)} & \textcolor<2>{dodgerblue}{$\textcolor<2>{dodgerblue}{7,3}$ j}\\
                10\ 000 & \textcolor<2>{maroon2}{340 s (34)} & \textcolor<2>{maroon2}{400 j} & \textcolor<2>{dodgerblue}{9 s ($\textcolor<2>{dodgerblue}{0,22}$)} & \textcolor<2>{dodgerblue}{10 j}\\
                \hline
            \end{tabular}
            \captionof{table}{\color{springgreen3}Temps de calcul (fonction \textit{system.time} du logiciel R).}
        \end{table}
    \end{center}
    \everymath{\color{dodgerblue}}
\end{frame}


\subsection{Application sur Données Réelles: D.E.S.I.R.}
\begin{frame}{\subsecname}
    \vspace{-1em}
    \begin{center}\begin{minipage}[t]{0.85\textwidth}\vspace{-1.5em}\begin{block}{\itshape\textbf{D.E.S.I.R.}}\setstretch{1}
        \begin{itemize}
            \item Données Épidémiologiques sur le Syndrome d’Insulino-Résistance
            \item 5\ 212 individus
            \item 1 visite tous les 3 ans, de 0 à 9 ans
            \item \texttildelow 4\ 500 individus génotypés
        \end{itemize}
    \end{block}\vspace{1.5em}\end{minipage}\end{center}
    \vspace{-1em}
    \begin{minipage}[t]{0.475\columnwidth}
        \vspace{-3.75em}
        \everymath{\color{black}}
        \begin{center}
            \begin{table}
                {\footnotesize
                    \begin{tabular}{lcc}
                        \hline
                         &  Témoins &  Cas Incidents \\
                        \hline
                        Sexe & \Male$2\ 293$; \Female$2\ 483$ & \Male$142$; \Female$64$ \\
                        \^Age (années) & $46$ ($10$) & $51$ ($9$) \\
                        Glycémie (mmol/L) & $5,2$ ($0,51$) & $6$ ($0,57$)\\
                        BMI & $24$ ($3,7$) & $28$ ($4,4$) \\
                        HbA1c (\%) & $5,4$ ($0,39$) & $5,8$ ($0,48$) \\
                        \hline
                    \end{tabular}
                }
                \captionof{table}{\color{springgreen3}Caractéristiques des individus D.E.S.I.R. selon le statut diabète de type 2.}
            \end{table}
        \end{center}
        \everymath{\color{dodgerblue}}
    \end{minipage}%
    \hfill\vline\hfill
    \begin{minipage}[c]{0.475\columnwidth}%
        \begin{center}
            {\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig02.png}}}}
            \captionof{figure}{\color{springgreen3}Trajectoires de la glycémie à jeun des individus D.E.S.I.R.}
        \end{center}
    \end{minipage}
\end{frame}


\begin{frame}{\subsecname}
    \begin{center}
        \alt<2>{\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig05b.png}}}}{\color{black}\fbox{\includegraphics[width=0.95\textwidth]{{images/Fig05.png}}}}
        \captionsetup{labelformat=empty, textfont={bf,it}, width=0.95\textwidth}
        \captionof{figure}{\color{springgreen3}Taille d'effet $\textcolor{springgreen3}{\beta}$ et Hazard Ratio respectivement pour la glycémie et le diabète de type 2. Gènes identifiés dans des études \mbox{pangénomiques} pour une association à la glycémie et/ou au diabète de type 2.}
    \end{center}
\end{frame}


\begin{frame}{\subsecname}
    \everymath{\color{black}}
    \begin{center}
        \begin{table}
            {\fontsize{8pt}{12pt}\selectfont
                \begin{tabular}{cccc}
                    \hline
                    \multirow{2}{*}{SNP (gène)} & \multicolumn{2}{c}{$\beta$ (p-valeur)}\\
                    & JM (D.E.S.I.R.) & TS (D.E.S.I.R.)\\
                    \hline
                    rs10830963\_G (MTNR1B) & $3,25$ ($3,6\times 10^{-42}$) & $3,52$ ($2,7\times 10^{-54}$)\\
                    rs17747324\_C (TCF7L2) & $3,17$ ($8,9\times 10^{-42}$) & $3,39$ ($2,2\times 10^{-52}$)\\
                    \hline
                \end{tabular}
            }
            \captionsetup{labelformat=empty, textfont={bf,it}, width=0.5\textwidth}
            \captionof{table}{\color{springgreen3}Coefficients $\color{springgreen3}\beta$ estimés par JM et TS.}
        \end{table}
    \end{center}
    \everymath{\color{dodgerblue}}
\end{frame}


\begin{frame}{\subsecname}
    \everymath{\color{black}}
    \begin{center}
        \begin{table}
            {\fontsize{8pt}{12pt}\selectfont
                \begin{tabular}{ccccccc}
                    \hline
                    \multirow{2}{*}{SNP (gène)} & \multicolumn{3}{c}{$\gamma$ (p-valeur)}\\
                    & JM (D.E.S.I.R.) & TS (D.E.S.I.R.) & MAGIC\\
                    \hline
                    rs10830963\_G (MTNR1B) & $0,0991$ ($1,3\times 10^{-23}$) & $0,0992$ ($8,9\times 10^{-24}$) & $0,079$ ($1,3\times 10^{-68}$)\\
                    rs17747324\_C (TCF7L2) & $0,0229$ ($3,0\times 10^{-02}$) & $0,0218$ ($3,8\times 10^{-02}$) & $0,025$ ($6,5\times 10^{-08}$)\\
                    \hline
                \end{tabular}
            }
            \captionsetup{labelformat=empty, textfont={bf,it}, width=0.65\textwidth}
            \captionof{table}{\color{springgreen3}Coefficients $\color{springgreen3}\gamma$ estimés par JM et TS, et reportés dans le consortium MAGIC.}
        \end{table}
    	 \begin{table}
            {\fontsize{8pt}{12pt}\selectfont
                \begin{tabular}{ccccccc}
                    \hline
                    \multirow{2}{*}{SNP (gène)} & \multicolumn{3}{c}{$\alpha$ (p-valeur)}\\
                    & JM (D.E.S.I.R.) & TS (D.E.S.I.R.) & DIAGRAM\\
                    \hline
                    rs10830963\_G (MTNR1B) & $-0,440$ ($9,4\times 10^{-04}$) & $-0,443$ ($5,0\times 10^{-04}$) & $0,104$ ($7,3\times 10^{-07}$)\\
                    rs17747324\_C (TCF7L2) & $0,265$ ($4,1\times 10^{-02}$) & $0,284$ ($2,2\times 10^{-02}$) & $0,358$ ($8,5\times 10^{-55}$)\\
                    \hline
                \end{tabular}
            }
            \captionsetup{labelformat=empty, textfont={bf,it}, width=0.65\textwidth}
            \captionof{table}{\color{springgreen3}Coefficients $\color{springgreen3}\alpha$ estimés par JM et TS, et reportés dans le consortium DIAGRAM.}
        \end{table}
    \end{center}
    \everymath{\color{dodgerblue}}
\end{frame}


\subsection{Conclusion: Modèle Joint}
\begin{frame}{\subsecname}
        \begin{center}
            \only<1>{\color{black}\fbox{\includegraphics[width=\textheight, page=31]{{images/Diagrammes.pdf}}}}%
            \only<2>{\color{black}\fbox{\includegraphics[width=\textheight, page=32]{{images/Diagrammes.pdf}}}}%
        \end{center}
\end{frame}
%\begin{frame}{\subsecname}
%\begin{itemize}
%\item Cohérence des résultats
%\item Modélisation jointe plus puissante que les approches génétique classique
%\item Temps de calcul important
%\item Approche ``deux-étapes'' comme compromis estimation/temps
%\item[$\Rightarrow$] Soumission en cours dans \textit{Genetic Epidemiolgy}
%\end{itemize}
%\end{frame}
%\note{}
