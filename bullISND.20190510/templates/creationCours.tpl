<h3>Création d'un nouveau cours</h3>

<form name="creationCours" id="creationCours" method="POST" action="index.php">
	<h4>Liste des cours existants au niveau {$niveau}</h4>
	<div style="float:left">
	<p>À titre d'exemples</p>
	<select name="coursExistants" id="coursExistants" size="15">
		{foreach from=$listeCoursComp key=cours item=data}
		<option value="{$cours}">{$data.libelle} {$data.statut} {$data.nbheures}h</option>
		{/foreach}
	</select>
	</div>
	<label for="cours">Nom du cours</label>
	<input type="text" name="cours" id="cours" value="{$nomCours}" size="30">
	<label for="abreviation">Abréviation en 5 lettres</label>
	<input type="text" name="abreviation" id="abreviation" value="{$abreviation}" size="5" maxlength="5"><br>
	<label for="cadre">Cadre de formation</label>
	<select name="cadre" id="cadre">
		{foreach from=$listeStatutCours key=cadre item=data}
		<option value="{$cadre}">{$data.statut} {$data.legende}</option>
		{/foreach}
	</select>
	
</form>