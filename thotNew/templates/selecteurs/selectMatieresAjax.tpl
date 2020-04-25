<select class="form-control" name="matricule" id="selectMatieres">
<option value="">Sélection d'une matière</option>
	{foreach from=$listeMatieres key=matiere item=dataCours}
		<option value="{$matiere}">[{$matiere}] {$dataCours.statut} {$dataCours.libelle} {$dataCours.nbHeures}h</option>
	{/foreach}
</select>
<span class="input-group-btn">
	<button type="button" class="btn btn-primary" name="button" data-type="matiere" disabled>
		<i class="fa fa-arrow-right"></i>
	</button>
</span>
