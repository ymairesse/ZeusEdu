<div class="row">

	<div class="col-xs-12">

		<input type="{$data.typeChamp}" name="{$unChamp}" id="{$unChamp}" class="form-control {$data.classCSS}
				{if ($data.typeDate == 1)} uneDate{/if}
				{if ($data.classCSS == 'obligatoire')} required{/if}"
				autocomplete="off"
				placeholder="{$data.label}"
				value="{if isset($fait.$unChamp)}{$fait.$unChamp}{/if}"
				{if $data.maxlength> 0} maxlength="{$data.maxlength}" {/if}
				{if $data.colonnes > 0} cols="{$data.colonnes}" {/if}
				tabIndex="{$tabIndex}">
				{if $unChamp == 'professeur'}
					<p class="help-block"><span id="nomPrenom"></span></p>
				{/if}
		{assign var="tabIndex" value=$tabIndex+1 scope="global"}
	</div>

</div>
