{if isset($listeClasses)}

<div class="form-group">
	<label for="selectClasse">Classe</label>

	<select name="classe" id="selectClasse" {if isset($size)}size="{$size}"{/if}{if isset($multiple)} multiple{/if} class="form-control">
		<option value="">Toutes les classes</option>
		{if isset($listeClasses)}
			{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if isset($classe) && ($uneClasse==$classe)} selected{/if}>{$uneClasse}</option>
			{/foreach}
		{/if}
	</select>
	</div>

{/if}
