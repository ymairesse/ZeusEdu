{strip}
<input type="hidden" name="{$unChamp}" id="{$unChamp}" value="
	{if $unChamp == 'qui'} 
		 {$identite.acronyme}"
	 {elseif $unChamp == 'matricule'} 
		 {$eleve.matricule}"
	 {elseif $unChamp == 'type'} 
		 {$prototype.structure.type}"
	 {else}
		 {if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
	{/if}>
{/strip}