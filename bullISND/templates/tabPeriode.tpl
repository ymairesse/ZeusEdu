<table style="font-size:0.8em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
			<th title="{$data.libelle} | {$listeProfsCoursGrp.$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut}</th>
		{/foreach}
	</tr>
	<tr>
		<th>TJ</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<td class="cote mention{$cotesPeriode.$matricule.$coursGrp.form.mention|default:''}"
			title="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'No Comment'}">
			{if isset($cotesPeriode.$matricule.$coursGrp.form.cote)}
				{$cotesPeriode.$matricule.$coursGrp.form.cote}/{$cotesPeriode.$matricule.$coursGrp.form.max}
				{else}
				&nbsp;
			{/if}
		</td>
		{/foreach}
	</tr>
	<tr>
		<th>Cert</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<td class="cote mention{$cotesPeriode.$matricule.$coursGrp.cert.mention|default:''}"
			title="{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'No Comment'}">
			{if isset($cotesPeriode.$matricule.$coursGrp.cert.cote)}
				{$cotesPeriode.$matricule.$coursGrp.cert.cote}/{$cotesPeriode.$matricule.$coursGrp.cert.max}
				{else}
				&nbsp;
			{/if}
		</td>
		{/foreach}		
	</tr>
</table>

{include file="tableauMentions.tpl"}

