<select class="form-control" name="classe" id="selectClasse">
	<option value="">Choisir une classe</option>
	{foreach from=$listeClasses item=uneClasse}
		<option value="{$uneClasse}">{$uneClasse}</option>
	{/foreach}
</select>
<span class="input-group-btn">
	<button type="button" class="btn btn-primary" name="button" data-type="classe" disabled>
		<i class="fa fa-arrow-right"></i>
	</button>
</span>
