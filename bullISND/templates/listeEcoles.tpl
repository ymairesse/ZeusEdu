<select id="ecole" name="ecole" class="form-control input-sm">
	<option value="">École</option>
	{foreach from=$listeEcoles key=k item=uneEcole }
	<option value="{$k}"{if isset($ecole) && ($k == $ecole)} selected{/if}>{$uneEcole}</option>
	{/foreach}
</select>
