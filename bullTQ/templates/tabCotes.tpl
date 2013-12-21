<table style="font-size:0.8em" border="1" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<th title="{$data.libelle} | {$listeProfsCoursGrp.$coursGrp}">{$data.shortCours}</th>
		{/foreach}
		<th>Mentions</th>
	</tr>
	
	{foreach from=$listePeriodes key=periode item=bulletin}
	<tr>
		<th>{$bulletin}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		
		<td title="{$listeProfsCoursGrp.$coursGrp}: {$listeCoursGrp.$coursGrp.libelle}|{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'no comment'}">
				<strong>{$syntheseCotes.$bulletin.$coursGrp|default:'&nbsp;'}</strong>
		 </td>
		{/foreach}
		<td class="cote"><strong>{$mentions.$matricule.$bulletin|default:'&nbsp;'}</strong></td> 
	</tr>
	{/foreach}
</table>
