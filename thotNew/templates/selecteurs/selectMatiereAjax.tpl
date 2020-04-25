<select class="form-control" name="matiere" id="selectMatiere">
	<option value="">Choisir une matière</option>
	{foreach from=$listeMatieres key=matiere item=data}
		<option value="{$matiere}">{$data.cours} {$data.libelle|truncate:25:'...'}</option>
	{/foreach}
</select>
<span class="input-group-btn">
	<button type="button" class="btn btn-primary" name="button" data-type="matiere" disabled>
		<i class="fa fa-arrow-right"></i>
	</button>
</span>
