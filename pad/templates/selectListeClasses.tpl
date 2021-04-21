<div class="form-group">

	<select name="listeClasses[]" id="selectClasses" class="form-control" multiple style="min-height:10em; overflow:auto;">
		{foreach from=$listeClasses item=uneClasse}
		<option value="{$uneClasse}">{$uneClasse}</option>
		{/foreach}
	</select>

</div>
