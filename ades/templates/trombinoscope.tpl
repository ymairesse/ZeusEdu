<div class="container">
<fieldset class="infos" style="clear:both">
<legend><span id="classe">{$classe}</span>
	{if isset($titulaires)}
		Titulaire(s): {", "|implode:$titulaires}
	{/if}
	</legend>

<ul id="trombi">
	{foreach from=$tableauEleves key=matricule item=unEleve name=trombi}
		{* 16 photos par page, à l'impression *}
		{if $smarty.foreach.trombi.iteration % 17 == 0}
			<li class="unePhoto" id="{$matricule}" style="page-break-before:always">
		{else}
			<li class="unePhoto" id="{$matricule}">
		{/if}
		<a href="index.php?action=eleves&amp;mode=trombinoscope&amp;matricule={$matricule}">
		<img src="../photos/{$unEleve.photo}.jpg" style="width:128px; height:190px" alt="{$matricule}"
		 title="Fiche de {$unEleve.prenom} {$unEleve.nom}"><br /></a>
		{$unEleve.classe} {$unEleve.prenom} {$unEleve.nom}
		</li>
	{/foreach}
</ul>
</fieldset>
</div>