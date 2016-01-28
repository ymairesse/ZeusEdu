{if isset($listeClasses)}
<select name="classe" id="selectClasse" {if isset($size)}size="{$size}"{/if}{if isset($multiple)} multiple{/if}>
	<option value="">Toutes les classes</option>
	{if isset($listeClasses)}
		{foreach from=$listeClasses item=uneClasse}
		<option value="{$uneClasse}"{if isset($classe) && ($uneClasse==$classe)} selected{/if}>{$uneClasse}</option>
		{/foreach}
	{/if}
</select>
{/if}