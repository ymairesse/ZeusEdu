{strip}

<div class="form-group">
	<label for="{$unChamp}" class="sr-only">{$data.label}</label>
	{strip}
	<textarea {if ($data.classCSS == 'obligatoire')} required {/if}
		name="{$unChamp}"
		id="{$unChamp}"
		class="form-control"
		placeholder="{$data.label}"
		readonly>
		{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}</textarea>
	{/strip}

</div>  <!-- form-group -->

{/strip}
