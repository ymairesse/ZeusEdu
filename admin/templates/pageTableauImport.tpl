<h4>Le fichier à traiter contient les données suivantes</h4>
<table class="tableauAdmin">
	<tr>
	{foreach from=$entete item=element}
		<th>{$element}</th>
	{/foreach}		
	</tr>

	{foreach from=$tableau item=ligne}
		<tr>{strip}
			{foreach from=$ligne item=element}
				<td>{$element|default:'&nbsp;'}</td>
			{/foreach}
			{/strip}
		</tr>
	{/foreach}
</table>