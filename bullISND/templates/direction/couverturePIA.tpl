<div class="container">

	{assign var=n value=0}
	{foreach from=$listePIA key=matricule item=eleve}
	<div id="pia">
		<h1>Plan Individuel d'Apprentissage et d'accompagnement</h1>

		<img src="images/gradientISND2.jpg" alt="entête" id="entetePIA" style="width:100%">
		<!-- entête du document de l'élève -->

		<div class="photo" id="blocNoms">

			<img src="../photos/{$eleve.detailsEleve.photo}.jpg" style="height:150px; float:left;" alt="{$eleve.detailsEleve.photo}">
			<br>
			<div id="nomPrenom">
				<h3>Ce document appartient à </h3>
				Nom: <strong>{$eleve.detailsEleve.nom}</strong>
				<br> Prénom: <strong>{$eleve.detailsEleve.prenom}</strong>
				<br> Classe: <strong>{$eleve.detailsEleve.groupe}</strong>
			</div>

		</div>
		<!-- col-md-... -->

		<table style="width:100%; margin-top:2em" class="tableauTitu" border="1">
			<tr style="height:3em; text-align:center;">
				<th>Cours</th>
				<th>Heures</th>
				<th>Professeur(s)</th>
				{foreach from=$listePeriodes item=noPeriode}
				<th style="width:3em">B {$noPeriode}</th>
				{/foreach}
			</tr>

			{foreach from=$eleve.listeCoursActuelle key=coursGrp item=detailsCours}
			<tr style="height:2em">
				<td style="padding-left:1em">{$detailsCours.libelle}</td>
				<td style="text-align:center; padding-left:1em;">{$detailsCours.nbheures}h</td>
				<td style="padding-left:1em">{$eleve.listeProfs.$coursGrp}</td>
				{foreach from=$listePeriodes item=noPeriode}
				<td>&nbsp;</td>
				{/foreach}
			</tr>
			{/foreach}
		</table>

		<p style="padding-top: 9em">Ce document est à compléter lors de chaque bulletin pour chaque cours pour lequel tu es invité-e à rencontrer ton professeur.</p>
		<p style="page-break-after: always;">En cas d'absence injustifiée à un rendez-vous, tu seras convoqué-e par la direction.</p>


		<p class="coursProf">Nom: <strong>{$eleve.detailsEleve.nom}</strong></p>
		<p class="coursProf">Prénom: <strong>{$eleve.detailsEleve.prenom}</strong></p>
		<p class="coursProf">Adresse: <strong>{$eleve.detailsEleve.adresseEleve}</strong>
			<br>
			<strong>{$eleve.detailsEleve.cpostEleve} {$eleve.detailsEleve.localiteEleve}</strong></p>
		<p class="coursProf">Courriel de l'élève: <strong>{$eleve.detailsEleve.user}@{$eleve.detailsEleve.mailDomain}</strong></p>
		<p class="coursProf">Téléphone du père: <strong>{$eleve.detailsEleve.telPere}</strong></p>
		<p class="coursProf">Téléphone de la mère: <strong>{$eleve.detailsEleve.telMere}</strong></p>
		<p class="coursProf">Courriel des parents: <strong>{$eleve.detailsEleve.courriel}</strong></p>

		{if $eleve.degre == 1}
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

		<table style="font-size:0.8em" class="tableauTitu">
			<tr>
				<th>&nbsp;</th>
				{foreach from=$eleve.listeCours key=coursGrp item=data}
				<th title="{$data.libelle} {$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut} </th>
				{/foreach}
				<th>Mentions</th>
			</tr>
			{assign var=annee value=$eleve.annee} {foreach from=$eleve.resultats key=periode item=bulletin}
			<tr>
				<th>{$periode}</th>

				{foreach from=$eleve.listeCours key=coursGrp item=data} {if in_array($coursGrp, array_keys($eleve.resultats.$periode))}
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

		<h3 style="margin-top:5em">Informations médicales</h3>

		<p style="font-size:50%; color: #555">{$eleve.infosMedic}</p>
	</div>

	{assign var=n value=$n+1}
	{if ($listePIA|count > 1) && ($n < $listePIA|count)}
		<br class="pageBreak">
	{/if}
	{/foreach}

</div>
<!-- container -->
