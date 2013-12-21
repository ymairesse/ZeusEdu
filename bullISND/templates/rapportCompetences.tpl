<h1>Rapport de compétences acquises: {$classe}</h1>
<div id="tableauCompetences">
{if isset($listeEleves)}
{foreach from=$listeEleves key=matricule item=data}
	{include file="enteteCompetences.tpl"}
	<table style="width:100%" border="1px" class="tableauAdmin">
		<tr>
			<th width="75%">COMPETENCES</td>
			<th width="25%">Acquisition</td>
		</tr>
		{if isset($listeAcquis.$matricule)}
		{assign var=lesCoursEleve value=$listeAcquis.$matricule}
		{* $lesCours = liste des cours de l'élève courant avec les informations de cotes et d'acquisition OK ou KO *}
		{foreach from=$lesCoursEleve key=abrCours item=dataCompetences}
		<tr>
			<td class="nomCours" colspan="2"><h4>{$listeCours.$abrCours.libelle}</h4></td>
		</tr>
			{foreach from=$dataCompetences key=idComp item=uneCompetence}
				<tr>
					<td>{$listeCompetences.$abrCours.$idComp.libelle}
						<span class="noprint hide">{if isset($listeAcquis.$matricule)}{$listeAcquis.$matricule.$abrCours.$idComp.cote}/{$listeAcquis.$matricule.$abrCours.$idComp.max}{/if}}</span>
					</td>
					<td style="text-align:center">{if isset($listeAcquis.$matricule)}{$listeAcquis.$matricule.$abrCours.$idComp.acq}{/if}</td>
				</tr>
			{/foreach}
		{/foreach}
		{/if}
	</table>
	<p>Dans le cas où l'élève est orienté vers une année complémentaire au pemier degré, le présent rapport sera complété par un plan individuel d'apprentissage élaboré par le Conseil de Guidance.</p>
	<p>Donné à ANDERLECHT, le {$date}</p>
	<table width="100%" class="signature" style="padding-top: 2em">
		<tr>
			<td  width="75%">Sceau de l'établissement</td>
			<td width="25%">{$DIRECTION}</td>
		</tr>
		{if $signature == true}
		<tr>
			<td  width="75%"><img src="images/sceauISND.png" width="240" border="0" alt="Sceau ISND" /></td>
			<td width="25%"><img src="images/ams.jpg" width="149" border="0" alt="Signature" /></td>
		</tr>
		{/if}
	</table>
{/foreach}
{/if}
</div>
