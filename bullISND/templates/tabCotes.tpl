<table style="font-size:0.8em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<th title="{$data.libelle} | {$listeProfsCoursGrp.$coursGrp}">{$data.cours}</th>
		{/foreach}
		<th>Mentions</th>
	</tr>
	{foreach from=$listePeriodes key=periode item=bulletin}
	<tr>
		<th>{$bulletin}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		
		<td class="cote mention{$syntheseCotes.$bulletin.$coursGrp.mention|default:''}"
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
<table class="micro">
<tr>
	<td colspan="6">Code de couleurs</td>
</tr>
<tr>
	<td class="mentionI">< 50</td>
	<td class="mentionF">50</td>
	<td class="mentionS">60</td>
	<td class="mentionAB">65</td>
	<td class="mentionB">70</td>
	<td class="mentionBplus">75</td>
	<td class="mentionTB">80</td>
	<td class="mentionTBplus">85</td>
	<td class="mentionE">>90</td>
</tr>
</table>
