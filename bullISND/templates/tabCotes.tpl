





<table style="font-size:0.8em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
			<th title="{$data.libelle} | {$listeProfsCoursGrp.$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut}</th>
		{/foreach}
		<th>Mentions</th>
	</tr>
	
	{foreach from=$listePeriodes key=periode item=bulletin}
	<tr>
		<th>{$periode+1}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}		
			<td class="cote mention{$syntheseCotes.$bulletin.$coursGrp.mention|trim:'+'|default:''}"
				title="{$listeProfsCoursGrp.$coursGrp}: {$listeCoursGrp.$coursGrp.libelle}|{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'no comment'}">
				{if isset($syntheseCotes.$bulletin.$coursGrp.sitDelibe) && ($syntheseCotes.$bulletin.$coursGrp.sitDelibe != '')}
					<span class="micro">Délibé </span>
					<strong>{$syntheseCotes.$bulletin.$coursGrp.sitDelibe|default:''}</strong><br>
				{/if}
				
				{if isset($syntheseCotes.$bulletin.$coursGrp.pourcent) && ($syntheseCotes.$bulletin.$coursGrp.pourcent != '')}
				{$syntheseCotes.$bulletin.$coursGrp.situation|default:''}/{$syntheseCotes.$bulletin.$coursGrp.maxSituation|default:''}<br>
				<span class="micro">={$syntheseCotes.$bulletin.$coursGrp.pourcent|default:''}</span>
				{/if}
			 </td>
		{/foreach}
		<td class="cote"><strong>{$mentions.$matricule.$annee.$bulletin|default:'&nbsp;'}</strong></td> 
	</tr>
	{/foreach}
</table>

{include file="tableauMentions.tpl"}
