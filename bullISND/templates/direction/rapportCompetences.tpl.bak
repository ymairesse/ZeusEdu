<div class="container">
	
{if $typeDoc == 'pia'}
	<h1>Plans individuels d'apprentissages: {$classe}</h1>
{/if}
{if $typeDoc == 'competences'}
	<h1>Rapport de compétences acquises: {$classe}</h1>
{/if}
<div id="tableauCompetences">
{if isset($listeEleves)}
{foreach from=$listeEleves key=matricule item=data}
	{if $typeDoc == 'pia'}
		{include file="entetePIA.tpl"}
	{/if}
	{if $typeDoc == 'competences'}
		{include file="enteteCompetences.tpl"}
	{/if}
	
	<div class="table-responsive">
	<table style="width:100%" border="1px" class="table tableauAdmin">
		<tr>
			<th width="75%">COMPETENCES</td>
			<th width="25%">Acquisition</td>
		</tr>
		{if isset($listeAcquis.$matricule)}
		{assign var=lesCoursEleve value=$listeAcquis.$matricule}
		{* $lesCours = liste des cours de l'élève courant avec les informations de cotes et d'acquisition OK ou KO *}

		{foreach from=$lesCoursEleve key=leCours item=dataCompetences}
		<tr>
			<td class="nomCours" colspan="2"><h4>{$listeCours.$leCours.dataCours.libelle}</h4></td>
		</tr>
			{foreach from=$dataCompetences key=idComp item=uneCompetence}
				<tr>
					<td>{$listeCompetences.$leCours.$idComp.libelle}
						<span class="noprint hide">{if isset($listeAcquis.$matricule)}{$listeAcquis.$matricule.$leCours.$idComp.cote}/{$listeAcquis.$matricule.$leCours.$idComp.max}{/if}}</span>
					</td>
					<td style="text-align:center">{if isset($listeAcquis.$matricule)}{$listeAcquis.$matricule.$leCours.$idComp.acq}{/if}</td>
				</tr>
			{/foreach}
		{/foreach}
		{/if}
	</table>
	</div>
	<p>Dans le cas où l'élève est orienté vers une année complémentaire au pemier degré, le présent rapport sera complété par un plan individuel d'apprentissage élaboré par le Conseil de Guidance.</p>
	<p>Donné à ANDERLECHT, le {$date}</p>
	
	<div class="table-responsive">
	<table width="100%" class="table signature" style="padding-top: 2em">
		<tr>
			<td  width="75%">Sceau de l'établissement</td>
			<td width="25%">{$DIRECTION}</td>
		</tr>
		{if $signature == true}
		<tr>
			<td  width="75%"><img src="images/sceauISND.png" width="240" border="0" alt="Sceau ISND" /></td>
			<td width="25%"><img src="images/direction.jpg" width="200" border="0" alt="Signature" /></td>
		</tr>
		{/if}
	</table>
	</div>
{/foreach}
{/if}
</div>

</div>  <!-- container -->
