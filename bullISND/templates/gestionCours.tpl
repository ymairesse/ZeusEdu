<h2>Gestion des cours</h2>

<!-- 
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

-->

<div style="float:left;">
<form name="orphanCours" id="orphanCours" method="POST" action="index.php">
	<h4>Liste des cours orphelins (pas d'élèves, pas d'enseignant)</h4>
	<select name="listeOrphans[]" id="listeOrphans" size="10" multiple="multiple">
		{foreach from=$listeOrphanCours key=cours item=data}
		<option value="{$cours}">{$data.libelle} {$data.statut} {$data.nbheures}h [{$cours}]</option>
		{/foreach}
	</select>
	<br>
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="gestCours">
	<input type="hidden" name="etape" value="deleteOrphans">
	<input type="submit" name="Supprimer" value="Supprimer les cours sélectionnés" id="supprimer">
</form>
</div>



<script type="text/javascript">
{literal}
	$(document).ready(function(){
		$("#supprimer").click(function(){
			var listeCours = $("#listeOrphans").val();
			if (listeCours) {
			listeCours = listeCours.length;
			if (listeCours > 0) {
				var question = "Étes-vous sûr(e) de vouloir supprimer ce(s) "+listeCours+" cour(s)?";
				if (!(confirm(question)))
					return false;
				}
			}
			else return false;
		})
		})

{/literal}
</script>