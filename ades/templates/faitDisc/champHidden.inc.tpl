{strip}
<input type="hidden" name="{$unChamp}" id="{$unChamp}"
	{if $unChamp == 'matricule'}
		value="{$Eleve.matricule}"
	{elseif $unChamp == 'type' }
		value="{$prototype.structure.type}"
	{elseif $unChamp == 'qui'}
		value="{$qui}"
	{elseif $unChamp == 'idfait'}
		value="{$fait.idfait}"
	{elseif $unChamp == 'anneeScolaire'}
		value="{$anneeScolaire}"
	{/if}>
{/strip}
