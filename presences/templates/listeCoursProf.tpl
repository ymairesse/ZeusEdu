<select name="coursGrp" id="coursGrp" class="form-control input-sm">
	<option value="">Sélectionnez un cours</option>
	{foreach from=$listeCoursGrp key=coursGrp item=data}
		<option value="{$coursGrp}" title="{$data.libelle}">
			{$data.libelle|truncate:25} ({$data.classes})
		</option>
	{/foreach}
</select>
