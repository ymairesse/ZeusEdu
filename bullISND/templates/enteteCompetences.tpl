<h1 style="page-break-before:always">COMMUNAUTÉ FRANÇAISE DE BELGIQUE</h1>
<h2 style="text-align:center">ENSEIGNEMENT SECONDAIRE</h2>
<h3 style="text-align:center">RAPPORT DE COMPÉTENCES ACQUISES</h3>
<p style="text-decoration: underline;">Dénomination et siège de l'établissement</p>
<p><strong>Institut des Sœurs de Notre-Dame</strong><br>
rue de Veeweyde, 40&nbsp;&nbsp; 1070-Bruxelles</p>
<p>La soussignée, <strong>{$DIRECTION}</strong>,<br>
chef de l'établissement susmentionné, certifie</p>
<p>que <strong style="font-size:1.5em">{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}</strong><br>
né(e) à <strong>{$listeEleves.$matricule.commNaissance}</strong><br>
le <strong>{$listeEleves.$matricule.DateNaiss}</strong></p>
<p>élève de <strong>{$classe}</strong> au cours de l'année scolaire <strong>
{assign var=thisyear value=$smarty.now|date_format:"%Y"}
{section name=yearValue start=$thisyear-1 loop=$thisyear+1}
{$smarty.section.yearValue.index}{if $smarty.section.yearValue.index eq $thisyear-1}/{/if}
{/section}
</strong> a acquis le niveau de compétences suivant:</p>
