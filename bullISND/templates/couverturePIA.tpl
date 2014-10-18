<div id="pia">
<h1>Plan Individuel d'Apprentissage et d'accompagnement</h1>

<img src="images/gradientISND.jpg" alt="entête" id="entetePIA">

<div id="blocNom" class="shadow">
	<img src="../photos/{$eleve.photo}.jpg" style="height:150px; float:left;" alt="{$eleve.photo}">
	<br>
	<div id="nomPrenom">
		<h3>Ce document appartient à </h3>
		Nom: <strong>{$eleve.nom}</strong> <br>
		Prénom: <strong>{$eleve.prenom}</strong><br>
		Classe: <strong>{$eleve.groupe}</strong>
	</div>
</div>

<p class="coursProf">Cours de _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>
<p class="coursProf">Professeur _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>

<p class="coursProf"></p>

<p class="coursProf">Cours de _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>
<p class="coursProf">Professeur _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>

<p class="coursProf"></p>

<p class="coursProf">Cours de _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>
<p class="coursProf">Professeur _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _</p>

<p class="coursProf"></p>

<p style="padding-top: 9em">Ce document est à compléter lors de chaque bulletin pour chaque cours pour lequel tu es invité à rencontrer ton professeur.</p>
<p style="page-break-after: always;">En cas d'absence injustifiée à un rendez-vous, tu seras convoqué par la direction.</p>


<p class="coursProf">Nom: <strong>{$eleve.nom}</strong></p>
<p class="coursProf">Prénom: <strong>{$eleve.prenom}</strong></p>
<p class="coursProf">Adresse: <strong>{$eleve.adresseEleve}</strong><br>
<strong>{$eleve.cpostEleve} {$eleve.localiteEleve}</strong></p>
<p class="coursProf">Téléphone père: <strong>{$eleve.telPere}</strong></p>
<p class="coursProf">Téléphone mère: <strong>{$eleve.telMere}</strong></p>
<p class="coursProf">Courriel parents: <strong>{$eleve.courriel}</strong></p>

{if $degre == 1}
<h4>Résultats du CEB</h4>
<table style="font-size:0.8em; width:100%" class="tableauTitu">
	<tr>
		<th style="width:17%">Matières</th>
		<th style="width:17%">Français</th>
		<th style="width:17%">Math</th>
		<th style="width:17%">Sciences</th>
		<th style="width:17%">Histoire/géo</th>
		<th style="width:17%">Deuxième langue</th>
	</tr>
	<tr>
		<th>Cotes obtenues</th>
		<td class="cote">{$ceb.fr}</td>
		<td class="cote">{$ceb.math}</td>
		<td class="cote">{$ceb.sc}</td>
		<td class="cote">{$ceb.hg}</td>
		<td class="cote">{$ceb.l2}</td>
	</tr>
</table>
{/if}

{* s'il y a des résultats précédents (cas de tous les élèves sauf les 1ères *}
{if (isset($resultatsPrec))}
<h4>{$anScolaire} - Résultats de {$annee}e année</h4>

{assign var=listeCoursGrp value=$resultatsPrec.listeCours}
{assign var=resultats value=$resultatsPrec.resultats}
 
<table style="font-size:0.8em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
			<th title="{$data.libelle} {$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut} </th>
		{/foreach}
		<th>Mentions</th>
	</tr>
	
	{foreach from=$resultats key=periode item=bulletin}
	<tr>
		<th>{$periode}</th>
		
		{foreach from=$listeCoursGrp key=coursGrp item=data}
			{if in_array($coursGrp, array_keys($resultats.$periode))}
				<td class="cote" title="{$coursGrp}">
					{if isset($resultats.$periode.$coursGrp.sitDelibe) && ($resultats.$periode.$coursGrp.sitDelibe != '')}
						<span class="micro">Délibé </span>
						<strong>{$resultats.$periode.$coursGrp.sitDelibe}</strong><br>
					{/if}
					
					{if isset($resultats.$periode.$coursGrp.pourcent) && ($resultats.$periode.$coursGrp.pourcent != '') }
					{$resultats.$periode.$coursGrp.situation}/{$resultats.$periode.$coursGrp.maxSituation}<br>
					<span class="micro">={$resultats.$periode.$coursGrp.pourcent}</span>
					{/if}
				 </td>
				{else}
				<td>&nbsp;</td>
			{/if}
		{/foreach}
		<td class="cote"><strong>{$mentions.$matricule.$annee.$periode|default:'&nbsp;'}</strong></td> 
	</tr>
	{/foreach}
	
</table>
{/if}

<h3 style="margin-top:5em">Informations médicales</h3>

<p style="font-size:50%; color: #555">{$infosMedic}</p>
</div>
