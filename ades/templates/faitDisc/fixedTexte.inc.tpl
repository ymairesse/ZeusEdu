{strip}
<div class="col-xs-6">

	<div class="form-group">
		<input type="{$data.typeChamp}" 
				name="{$unChamp}"
				id="{$unChamp}" class="form-control {$data.classCSS}
				{if ($data.autocomplete == 'O')} autocomplete{/if}
				{if ($data.classCSS == 'obligatoire')} required{/if}"
				placeholder="{$data.label}"
				value="{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
				readonly>
	</div>   <!-- form-group -->

</div>
{/strip}
