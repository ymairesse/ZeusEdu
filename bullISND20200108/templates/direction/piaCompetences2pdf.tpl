<page backtop="9mm" backbottom="18mm" backleft="15mm" backright="15mm">
	{if $typeDoc == 'pia'} {include file="../direction/entetePIA.tpl"} {/if}
	{if $typeDoc == 'competences'}{include file="../direction/enteteCompetences.tpl"} {/if}

	{include file="../direction/corpsCompetences.tpl"}

	<page_footer>
		{$unEleve.nom} {$unEleve.prenom}
	</page_footer>
</page>
