<fieldset class="infos" style="clear:both">
<legend>Sélectionner la classe</legend>
{foreach from=$tableauGroupes item=unNiveau}
	<ul class="tableauGroupes">
		{foreach from=$unNiveau item=uneClasse}
			<li><a href="javascript:void(0)" class="classe">{$uneClasse}</a>&nbsp;</li>
	{/foreach}
	</ul>
{/foreach}
</fieldset>
