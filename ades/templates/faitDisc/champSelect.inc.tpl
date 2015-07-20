{strip}
{if $unChamp == 'idretenue'}
<input type="hidden" name="oldIdretenue" value="{$fait.idretenue|default:''}">
<div class="form-group">
	<label for="{$unChamp}">{$data.label}</label>						
	<select name="{$unChamp}"
			id="{$unChamp}"
			tabindex="{$tabIndex}"
			class="form-control"
			{if ($data.classCSS == 'obligatoire')} required{/if}>
		<option value=''>Choisir une date</option>
		{foreach from=$listeRetenues key=unidretenue item=uneRetenue}
			{if $uneRetenue.affiche == 'O'}
				<option value="{$unidretenue}"{if $uneRetenue.places <= $uneRetenue.occupation} disabled="disabled"{/if}
				{if isset($fait.idretenue) && ($fait.idretenue == $unidretenue)} selected="selected"{/if}>{$unidretenue} {$fait.idretenue}
				{$uneRetenue.jourSemaine} {$uneRetenue.dateRetenue} [durée: {$uneRetenue.duree}h à {$uneRetenue.heure}] : {$uneRetenue.occupation}/{$uneRetenue.places}</option>
			{/if}
		{/foreach}
	</select>
</div>  <!-- form-group -->
{assign var="tabIndex" value=$tabIndex+1}
{/if}
{/strip}