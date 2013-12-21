<fieldset class="infos" style="clear:both">
<legend><span id="classe">{$classe}</span> {$titulaires} {$cours}</legend>
<ul id="trombi">
	{foreach from=$tableauEleves item=unEleve name=trombi}
		{* 16 photos par page, à l'impression *}
		{if $smarty.foreach.trombi.iteration % 17 == 0}
			<li class="unePhoto eleve" id="{$unEleve.codeInfo}" style="page-break-before:always">
		{else}
			<li class="unePhoto eleve" id="{$unEleve.codeInfo}">
		{/if}
		<img src="../photos/{$unEleve.codeInfo}.jpg" style="width:128px; height:190px" alt="{$unEleve.codeInfo}"
		 title="Détails de {$unEleve.nomPrenom}"><br />
		{$unEleve.nomPrenom}
		</li>
	{/foreach}
</ul>
</fieldset>
