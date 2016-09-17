<style type="text/css">
    table.cours { border: solid 1px #ccc; border-collapse: collapse; width: 100% }
    table.cours td { border: solid 1px #ccc; font-size: 8pt;}
    table.cours tr.title { background-color: #ccc; font-size: 9pt; text-align:center; }
	p { font-size: 10pt; }
</style>

<page backtop="10mm" backbottom="10mm" backleft="10mm" backright="15mm">

	<h3 style="text-align:center">Plan Individuel d'Apprentissage et d'accompagnement</h3>

	<img src="../../images/gradientISND2.jpg" alt="entête" style="width:100%">

	<br><br><br>
	
	<!-- entête du document de l'élève -->
<table style="width:100%; margin: 2cm 0;">
	<tr>
		<td style="width:40%">&nbsp;</td>
		<td style="width:60%; border: 2px solid #999; margin-left: 10cm">
			<img src="../../../photos/{$eleve.detailsEleve.photo}.jpg" style="height:150px; float:left;" alt="{$eleve.detailsEleve.photo}">

				<h4 style="font-size:12pt">Ce document appartient à </h4>
				Nom: <strong>{$eleve.detailsEleve.nom}</strong>
				<br> Prénom: <strong>{$eleve.detailsEleve.prenom}</strong>
				<br> Classe: <strong>{$eleve.detailsEleve.groupe}</strong>
		</td>
	</tr>
</table>

<br><br><br><br><br><br><br><br><br>


<table class="cours" style="margin: 4em 0; width:100%">
	<tr style="height:3em; text-align:center;" class="title">
		<th style="width:30%">Cours</th>
		<th style="width:15%">Heures</th>
		<th style="width:30%">Professeur(s)</th>
		{foreach from=$listePeriodes item=noPeriode}
		<th style="width:5%">B{$noPeriode}</th>
		{/foreach}
	</tr>

	{foreach from=$eleve.listeCoursActuelle key=coursGrp item=detailsCours}
	<tr style="height:2em; font-size:9px;">
		<td>{$detailsCours.libelle}</td>
		<td style="text-align:center;">{$detailsCours.nbheures}h</td>
		<td>{$eleve.listeProfs.$coursGrp|truncate:30}</td>
		{foreach from=$listePeriodes item=noPeriode}
		<td>&nbsp;</td>
		{/foreach}
	</tr>
	{/foreach}
</table>

<br><br><br>

	<p style="padding-top: 9em">Ce document est à compléter lors de chaque bulletin pour chaque cours pour lequel tu es invité-e à rencontrer ton professeur.</p>
	<p>En cas d'absence injustifiée à un rendez-vous, tu seras convoqué-e par la direction.</p>
</page>


<page backtop="10mm" backbottom="10mm" backleft="10mm" backright="15mm">

	<table style="width:90%; margin: 2em 0;">

	    <tr>
	        <td style="width:60%">
				<p>Nom: <strong>{$eleve.detailsEleve.nom}</strong><br>
				Prénom: <strong>{$eleve.detailsEleve.prenom}</strong><br>
				Adresse: <strong>{$eleve.detailsEleve.adresseEleve}</strong><br>
				<strong>{$eleve.detailsEleve.cpostEleve} {$eleve.detailsEleve.localiteEleve}</strong><br>
				Courriel de l'élève:<br> <strong>{$eleve.detailsEleve.user}@{$eleve.detailsEleve.mailDomain}</strong></p>
	        </td>
	        <td style="width:40%;">
				<p>Téléphone du père: <strong>{$eleve.detailsEleve.telPere}</strong><br>
				Téléphone de la mère: <strong>{$eleve.detailsEleve.telMere}</strong><br>
				Courriel des parents: <strong>{$eleve.detailsEleve.courriel}</strong></p>
	        </td>
	    </tr>

	</table>


	{if $eleve.degre == 1}
	<h4>Résultats du CEB</h4>
	<table style="font-size:0.8em; width:100%" class="cours">
		<tr class="title">
			<th style="width:17%">Matières</th>
			<th style="width:17%">Français</th>
			<th style="width:17%">Math</th>
			<th style="width:17%">Sciences</th>
			<th style="width:17%">Histoire/géo</th>
			<th style="width:17%">Deuxième langue</th>
		</tr>
		<tr>
			<td>Cotes obtenues</td>
			<td class="cote">{$eleve.ceb.fr}</td>
			<td class="cote">{$eleve.ceb.math}</td>
			<td class="cote">{$eleve.ceb.sc}</td>
			<td class="cote">{$eleve.ceb.hg}</td>
			<td class="cote">{$eleve.ceb.l2}</td>
		</tr>
	</table>
	{/if}


	{* s'il y a des résultats précédents (cas de tous les élèves sauf les 1ères *}
	{if (isset($eleve.resultats))}
	<h4>{$eleve.anScolaire} - Résultats de {$eleve.annee}e année</h4>
	{assign var=listeCoursGrp value=$eleve.listeCours}
	{assign var=resultats value=$eleve.resultats}

	<table style="font-size:10pt" class="cours">
		<tr style="font-weight: normal; font-size: 8pt;" class="title">
			<th>&nbsp;</th>
			{foreach from=$eleve.listeCours key=coursGrp item=data}
			<th>{$data.cours}<br>{$data.nbheures}h {$data.statut} </th>
			{/foreach}
			<th>Mentions</th>
		</tr>
		{assign var=annee value=$eleve.annee}
		{foreach from=$eleve.resultats key=periode item=bulletin}
		<tr>
			<th>{$periode}</th>

			{foreach from=$eleve.listeCours key=coursGrp item=data}
			{if in_array($coursGrp, array_keys($eleve.resultats.$periode))}
			<td class="cote" title="{$coursGrp}">
				{if isset($eleve.resultats.$periode.$coursGrp.sitDelibe) && ($eleve.resultats.$periode.$coursGrp.sitDelibe != '')}
				<span class="micro">Délibé </span>
				<strong>{$eleve.resultats.$periode.$coursGrp.sitDelibe}</strong>
				<br> {/if} {if isset($eleve.resultats.$periode.$coursGrp.pourcent) && ($eleve.resultats.$periode.$coursGrp.pourcent != '') } {$eleve.resultats.$periode.$coursGrp.situation}/{$eleve.resultats.$periode.$coursGrp.maxSituation}
				<br>
				<span class="micro">={$eleve.resultats.$periode.$coursGrp.pourcent}</span> {/if}
			</td>
			{else}
			<td>&nbsp;</td>
			{/if}
			{/foreach}
			<td class="cote"><strong>{$eleve.mentions.$matricule.$annee.$periode|default:'&nbsp;'}</strong></td>
		</tr>
		{/foreach}

	</table>
	{/if}

	<h3 style="margin-top:5em; font-size: 50%; color:#555">Informations médicales</h3>

	<p style="font-size:50%; color: #555">{$eleve.infosMedic}</p>

</page>
