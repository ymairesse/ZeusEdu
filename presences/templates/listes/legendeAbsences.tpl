<h4>Légende</h4>
<table>
	<tr>
	{foreach from=$statuts item=justification key=justif}
		<td style="width:100px; padding-right: 0.5em; color:{$justification.color}; background:{$justification.background}; text-align:center; border:1px solid black;"
			title="{$justification.libelle}">
			{$justification.shortJustif}
		</td>
	{/foreach}
	</tr>
</table>
