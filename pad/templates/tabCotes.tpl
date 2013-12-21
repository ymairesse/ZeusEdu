<table style="font-size:1.1em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<th title="{$data.libelle}">{$data.cours}</th>
		{/foreach}
		<th>Mentions</th>
	</tr>
	{foreach from=$listePeriodes key=periode item=bulletin}
	{if isset($syntheseCotes.$bulletin)}
	<tr>
		<th>{$bulletin}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		
		{if isset($syntheseCotes.$bulletin.$coursGrp)}
			<td class="cote mention{$syntheseCotes.$bulletin.$coursGrp.mention}">
				{if $syntheseCotes.$bulletin.$coursGrp.sitDelibe}
					<span class="micro">Délibé </span>
					<strong>{$syntheseCotes.$bulletin.$coursGrp.sitDelibe}</strong><br>
				{/if}
				
				{if $syntheseCotes.$bulletin.$coursGrp.pourcent != ''}
				{$syntheseCotes.$bulletin.$coursGrp.situation}/{$syntheseCotes.$bulletin.$coursGrp.maxSituation}<br><span class="micro">={$syntheseCotes.$bulletin.$coursGrp.pourcent}</span>
				{/if}
			 </td>
		{else}
			<td>&nbsp;</td>
		{/if}
		{/foreach}
		
		<td class="cote"><strong>{$mentions.$matricule.$bulletin|default:'&nbsp;'}</strong></td> 
	</tr>
	{/if}
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
