<div id="resultat">
<h1 style="clear:both" title="{$cours.coursGrp}">{$cours.libelle} {$cours.nbheures}h [{$cours.annee}] | Bulletin n° {$bulletin}</h1>

<table class="tableauAdmin" style="width:100%">
	<!-- titre du tableau -->
	<tr>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		{assign var=cours value=$cours.cours}
		{assign var='nbCompetences' value=$listeCompetences.$cours|@count}
		<th colspan="{$nbCompetences*2}" style="text-align:center">TJ</th>
		<th class="ponderation">{$ponderations.$coursGrp.$bulletin.all.form|default:'&nbsp;'}</th>
		<th colspan="{$nbCompetences*2}" style="text-align:center">Certificatif</th>
		<th class="ponderation">{$ponderations.$coursGrp.$bulletin.all.cert|default:'&nbsp;'}</th>
	</tr>
	<!-- sous-titre du tableau -->
	<tr>
		<th>Classe</th>
		<th>Nom</th>
		<!-- titres compétences Formatif -->
		{foreach from=$listeCompetences key=cours item=lesCompetences}
			{foreach from=$lesCompetences key=idComp item=uneCompetence}
				<th colspan="2" title="{$uneCompetence.libelle}"><span class="nano">{$uneCompetence.id}</span>
					{$uneCompetence.libelle|truncate:5:"..."}</th>
			{/foreach}
		{/foreach}
		<th>Global Form.</th> <!-- Colonne global Période Formative -->
		<!-- titres compétences Certificatif -->
		{foreach from=$listeCompetences key=cours item=lesCompetences}
			{foreach from=$lesCompetences key=idComp item=uneCompetence}
				<th colspan="2" title="{$uneCompetence.libelle}"><span class="nano">{$uneCompetence.id}</span> 
					{$uneCompetence.libelle|truncate:5:"..."}</th>
			{/foreach}
		{/foreach}
		<th>Global Cert</th> <!-- Colonne global Période Certificative -->
	</tr>
	
	<!-- Une ligne par élève -->
	{foreach from=$cotesCours key=matricule item=unEleve}
		<tr>
		<td>{$unEleve.classe}</td>
		{assign var=nomPrenom value=$unEleve.nom|cat:' '|cat:$unEleve.prenom}
		<td title="{$matricule}">{$nomPrenom|truncate:20:"..."}</td>

		<!-- Cotes Formatives -->
		{foreach from=$listeCompetences key=cours item=lesCompetences}
			{foreach from=$lesCompetences key=idComp item=uneCompetence}
				{assign var="cote" value=$unEleve.cotes.$coursGrp.$idComp.form.cote|default:Null}
				{assign var="maxForm" value=$unEleve.cotes.$coursGrp.$idComp.form.maxForm|default:Null}
				<td style="text-align:center" class="TJ {cycle values='row,rowalt'}
					{if ($maxForm neq '') && ($cote neq '') && ($cote/$maxForm < 0.5)} echec{/if}">
				{$cote|default:'&nbsp;'}</td>
				<td class="{cycle values="row,rowalt"}">{$maxForm|default:'&nbsp;'}</td>
			{/foreach}
		{/foreach}
		
		{assign var="cote" value=$listeGlobalPeriodePondere.$matricule.$coursGrp.form.cote|default:Null}
		{assign var="max" value=$listeGlobalPeriodePondere.$matricule.$coursGrp.form.max|default:Null}
		<td style="text-align:center"{if $max && $cote/$max < 0.5} echec{/if}>
			{if $max neq ''}
				{$cote} / {$max}
				{else}
				&nbsp;
			{/if}
		</td>
			
		<!-- Cotes Certificatives -->
		{foreach from=$listeCompetences key=cours item=lesCompetences}
			{foreach from=$lesCompetences key=idComp item=uneCompetence}
				{assign var="cote" value=$unEleve.cotes.$coursGrp.$idComp.cert.cote|default:Null}
				{assign var="maxCert" value=$unEleve.cotes.$coursGrp.$idComp.cert.maxCert|default:Null}
				<td style="text-align:center" class="TJ {cycle values='row,rowalt'}
					{if ($maxCert neq '') && ($cote neq '') && ($cote/$maxCert < 0.5)} echec{/if}">
				{$cote|default:'&nbsp;'}</td>
				<td class="{cycle values="row,rowalt"}">{$maxCert|default:'&nbsp;'}</td>
			{/foreach}
		{/foreach}
		
		{assign var="cote" value=$listeGlobalPeriodePondere.$matricule.$coursGrp.cert.cote|default:Null}
		{assign var="max" value=$listeGlobalPeriodePondere.$matricule.$coursGrp.cert.max|default:Null}
		<td style="text-align:center"{if $max && $cote/$max < 0.5} echec{/if}>
			{if $max neq ''}
				{$cote} / {$max}
				{else}
				&nbsp;
			{/if}
		</td>

		</tr>
	{/foreach}
</table>

<h3>Légendes des compétences</h3>
<ul>
{foreach from=$listeCompetences key=cours item=lesCompetences}
	{foreach from=$lesCompetences key=idComp item=uneCompetence}
	<li>{$idComp}: {$uneCompetence.libelle}</li>
	{/foreach}
{/foreach}
</ul>
