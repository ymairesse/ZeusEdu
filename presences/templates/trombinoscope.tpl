<fieldset class="infos" style="clear:both">
<legend><span id="classe">{$titulaires.classe}</span>
	{if $titulaires}
		Titulaire(s): {", "|implode:$titulaires}
	{/if}
	{$cours}</legend>
<ul id="trombi">
	{foreach from=$tableauEleves key=matricule item=unEleve name=trombi}
		{* 16 photos par page, à l'impression *}
		{if $smarty.foreach.trombi.iteration % 17 == 0}
			<li class="unePhoto" id="{$matricule}" style="page-break-before:always">
		{else}
			<li class="unePhoto" id="{$matricule}">
		{/if}
		<a href="index.php?action=parEleve&amp;matricule={$matricule}&amp;selectClasse={$classe}">
		<img src="../photos/{$unEleve.photo}.jpg" style="width:128px; height:190px" alt="{$matricule}"
		 title="Détails de {$unEleve.prenom} {$unEleve.nom}"><br /></a>
		{$unEleve.classe} {$unEleve.prenom} {$unEleve.nom}
		</li>
	{/foreach}
</ul>
</fieldset>
