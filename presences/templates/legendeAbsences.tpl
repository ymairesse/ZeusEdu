<h4>Légende</h4>

<table>
	<tr>
	{foreach from=$statutsAbs item=justification key=justif}
		<td  class="justif" style="width:100px; padding-right: 0.5em; color:{$justification.color}; background:{$justification.background}; text-align:center"
			title="{$justification.libelle}" data-justif="{$justif}">
			{$justification.shortJustif}
		</td>
	{/foreach}
	</tr>
</table>
