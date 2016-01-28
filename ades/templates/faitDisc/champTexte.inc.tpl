{strip}
	<div class="form-group">
		<label for="{$unChamp}">{$data.label}</label>
		<input type="{$data.typeChamp}" name="{$unChamp}" id="{$unChamp}" class="form-control {$data.classCSS}
				{if ($data.typeDate == 1)} uneDate{/if}
				{if ($data.autocomplete == 'O')} autocomplete{/if}
				{if ($data.classCSS == 'obligatoire')} required{/if}
				" value="{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
			{if $data.maxlength > 0} maxlength="{$data.maxlength}" {/if} 
			{if $data.colonnes > 0} cols="{$data.colonnes}" {/if} 
			{if $data.lignes > 0} rows="{$data.lignes}" {/if} tabIndex="{$tabIndex}">
			{if $unChamp == 'professeur'} <p class="help-block"><span id="nomPrenom"></span></p>{/if}
	</div>   <!-- form-group -->
	{assign var="tabIndex" value=$tabIndex+1 scope="global"}
{/strip}