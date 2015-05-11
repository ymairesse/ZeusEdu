<div class="container">
{include file="pdfcsv.tpl"}

<fieldset class="infos" style="clear:both">
<legend>
	{if isset($cours)} {$cours} {/if}
	{if isset($classe)} {$classe} {/if}
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
		<a href="index.php?action=parEleve&amp;matricule={$matricule}">
		<img src="../photos/{$unEleve.photo}.jpg" style="width:128px; height:190px" alt="{$matricule}"
		 title="Détails de {$unEleve.nom} {$unEleve.prenom}"><br /></a>
		 <a href="mailto:{$unEleve.mail}" title="{$unEleve.mail}"><img src="images/emailIco.png"></a>
		{$unEleve.classe} {$unEleve.nom}  {$unEleve.prenom}

		</li>
	{/foreach}
</ul>

</fieldset>

</div>