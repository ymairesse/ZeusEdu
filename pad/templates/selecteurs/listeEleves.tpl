<h4>Liste des élèves</h4>

<button type="button" class="btn btn-primary btn-block" id="selectAllEleves">Sélectionner tout</button>

<select name="eleves[]" id="eleves" multiple size="24" class="form-control">
	{foreach from=$listeEleves key=matricule item=eleve}
		<option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
	{/foreach}
</select>

<div id="nbEleves">0 élève sélectionné</div>
