<style>

td, th {
	font-size: 7pt;
}

.mentionI {
	background-color: #FEA2A0;
}

.mentionF {
	background-color: #F7D29D;
	color: black;
}

.mentionS {
	background-color: #EBF79D;
}

.mentionAB {
	background-color: #9DF7A1;
}

.mentionB {
	background-color: #9EF8DB;
	color: black;
}

.mentionBplus {
	background-color: #26F8B6;
	color: black
}

.mentionTB {
	background-color: #7290E2;
	color: white
}

.mentionTBplus {
	background-color: #2558E2;
	color: white
}

.mentionE {
	background-color: #D2AAE6;
}

td.cote {
	border: 1px solid black;
	padding: 1mm;
	border-collapse: collapse;
}

.break {
	 page-break-before: always
}
h1 {
	font-size:14pt;
	padding-bottom: 3pt;
}
h2, h3 {
	font-size:12pt;
	padding-bottom: 0;
}

td, th {
	border: 1px solid black;
	padding: 1mm;
	border-collapse: collapse;
	font-size: 8pt;
}

th {
	background-color: #FFA621;
}

.important {
	color: red;
}
</style>


<page backtop="7mm" backbottom="7mm" backleft="20mm" backright="0mm">
    <page_header>
		<span style="margin-left: 20mm">[[page_cu]]/[[page_nb]]</span>
    </page_header>
    <page_footer>
       <span style="margin-left: 20mm">{$nomEleve}</span>
    </page_footer>

<h1>Scolaire: {$nomEleve}</h1>

{if isset($degre) && ($degre == 1)}

<h3>Résultats du CEB</h3>

<table class="table table-condensed" style="width:80%">
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

<div class="break"></div>

{/if}

 <!-- année scolaire en cours -->
{assign var=annee value=$classe|substr:0:1}
<h3 class="break">Résultats de {$annee}e année (année scolaire en cours)</h3>
	<div class="table-responsive">

		<table class="table table-condensed" style="width:100%">
			<tr>
				<th>&nbsp;</th>
				{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
					<th style="text-align:center">
						{$dataCours.cours}<br>
						{$dataCours.nbheures}h<br>{$dataCours.statut}
					</th>
				{/foreach}
			<th>Mentions</th>
			</tr>

			{foreach from=$anneeEnCours key=periode item=data}
			<tr>
				<th>{$periode}</th>
				{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
					<td class="cote mention{$anneeEnCours.$periode.$coursGrp.mention|trim:'+'|default:''}">
					{if isset($anneeEnCours.$periode.$coursGrp) && isset($anneeEnCours.$periode.$coursGrp.sitDelibe) && ($anneeEnCours.$periode.$coursGrp.sitDelibe != '')}
						<span class="micro">Délibé</span>
						<strong>{$anneeEnCours.$periode.$coursGrp.sitDelibe|default:''}</strong><br>
					{/if}
					{if isset($anneeEnCours.$periode.$coursGrp) && ($anneeEnCours.$periode.$coursGrp.situation|trim:' ' != '')}
						{$anneeEnCours.$periode.$coursGrp.situation|default:''}/{$anneeEnCours.$periode.$coursGrp.maxSituation|default:''}<br>
						<span class="micro">={$anneeEnCours.$periode.$coursGrp.pourcent|default:''}</span>
					{else}
						&nbsp;
					{/if}
					</td>
				{/foreach}
				<td class="cote" style="text-align:center"><strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$periode|default:'-'}</strong></td>
			</tr>
			{/foreach}
		</table>

	</div>  <!-- table-responsive -->

<!-- Années scolaires précédentes -->

{foreach from=$syntheseToutesAnnees key=anScolaire item=syntheseAnnee  name=tour}

	<!-- les éprevues externes de cette année scolaire -->
	{if isset($epreuvesExternes.$anScolaire)}
		<h4>Épreuves externes en {$anScolaire}</h4>
		<div class="table-responsive">
			<table class="table table-striped">
				<tr>
				{foreach from=$epreuvesExternes.$anScolaire key=cours item=cote}
					<td class="{if $cote < 50}mentionI {/if}cote">{$cours}: <strong>{$cote} / 100</strong></td>
				{/foreach}
				</tr>
			</table>
		</div>
	{/if}

	{foreach from=$syntheseAnnee key=annee item=dataSynthese}

	{assign var=listeCoursGrp value=$dataSynthese.listeCours}
	{assign var=resultats value=$dataSynthese.resultats}

	<h4>{$anScolaire} - Résultats de {$annee}e année</h4>

	<div class="table-responsive">

		<table class="table table-condensed">
			<tr>
				<th>&nbsp;</th>
				{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
					<th style="text-align:center">
					{$dataCours.cours}<br>
					{$dataCours.nbheures}h<br>{$dataCours.statut}
					</th>
				{/foreach}
				<th>Mentions</th>
			</tr>

			{foreach from=$resultats key=periode item=bulletin}

			<tr>
				<th>{$periode}</th>
				{foreach from=$listeCoursGrp key=coursGrp item=data}
					{if in_array($coursGrp, array_keys($resultats.$periode))}
						<td class="cote mention{$resultats.$periode.$coursGrp.mention|trim:'+'|default:''}">
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
				{/foreach} {* from $listeCoursGrp *}
				<td class="cote" style="text-align:center"><strong>{$mentions.$matricule.$anScolaire.$annee.$periode|default:'-'}</strong></td>
			</tr>

			{/foreach}  {* form $resultats*}

		</table>

		{include file="tableauMentions.tpl"}

	</div>  <!-- table-responsive -->

	{/foreach}  {* $syntheseAnnee*}

	{* saut de page éventuel *}
	{if $smarty.foreach.tour.iteration %2 != 0}<div class="break"></div>{/if}

{/foreach}  {* syntheseToutesAnnees *}

{if $ecoles}
<h3>Écoles fréquentées</h3>

<table class="table table-condensed table-hover">
	<tr>
	<th>Année</th>
	<th>École</th>
	<th>Adresse</th>
	</tr>
	{foreach from=$ecoles item=uneEcole}
	<tr>
	<td>{$uneEcole.annee}</td>
	<td>{$uneEcole.nomEcole}</td>
	<td>{$uneEcole.adresse} {$uneEcole.cPostal} {$uneEcole.commune}</td>
	</tr>
	{/foreach}
</table>
{/if}

</page>
