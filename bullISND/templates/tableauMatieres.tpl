<h3>Création d'un nouveau cours</h3>
<form name="creationCours" id="creationCours" action="index.php" method="POST">
	<p>Matière: <strong>{$cours}</strong>
	{assign var=dataCours value=$listeMatieres.$cours} Libellé: <strong>{$dataCours.libelle}</strong> Cadre: <strong>{$dataCours.cadre} </strong> Statut<strong> {$dataCours.statut}</strong>
		Nombre d'heures <strong> {$dataCours.nbheures}h</strong></p>
	<p>Nouveau cours: <strong><span id="nouveauCours">{$cours}</span></strong></p>
	<label for="groupe">Groupe [(0)n(x)]</label><input type="text" name="groupe" id="groupe" size="3" maxlength="3"><br>
	
	<label for="profs">Professeur(s)</label>
		<select name="profs[]" id="profs" multiple="multiple">
			<option value="">Sélectionner un ou plusieurs noms</option>
			{foreach from=$listeProfs key=acronyme item=data}
			<option value="{$acronyme}">{$data.nom} {$data.prenom}</option>
			{/foreach}
		</select>
	<input type="submit" name="submit" id="submit" value="Enregistrer">
	<input type="hidden" name="cours" id="matiere" value="{$cours}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="niveau" value="{$niveau}">
	<input type="hidden" name="etape" value="enregistrer">
</form>

{if !(empty($listeCoursGrp))}
<h3>Action sur les cours</h3>

<table class="tableauBull">
	<tr>
		<th>Cours</th>
		<th>Libellé</th>
		<th>Statut</th>
		<th>Cadre</th>
		<th>Professeur</th>
		<th>Nombre d'élèves</th>
	</tr>
{foreach from=$listeCoursGrp key=coursGrp item=data}
	<tr>
		<td>{$coursGrp}</td>
		<td>{$data.libelle}</td>
		<td>{$data.statut}</td>
		<td>{$data.cadre}</td>
		<td><form name="modProfs_{$coursGrp}" action="index.php" method="POST" class="microForm">
		{if $data.acronyme != ''}
			{$data.nomProf} ({$data.acronyme})
		{/if}
			<input type="hidden" name="acronyme" value="{$data.acronyme}">
			<input type="hidden" name="coursGrp" value="{$data.coursGrp}">
			<input type="hidden" name="niveau" value="{$niveau}">
			<input type="hidden" name="action" value="admin">
			<input type="hidden" name="etape" value="show">
			<input type="hidden" name="mode" value="attributionsProfs">
			<input type="submit" name="Mod+" value="+/-">
			</form>
		</td>
		<td><form name="modEleves_{$coursGrp}" action="index.php" method="POST" class="microForm">
			{$data.nbEleves}
				<input type="hidden" name="cours" value="{$data.cours}">
				<input type="hidden" name="coursGrp" value="{$coursGrp}">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="attributionsEleves">
				<input type="submit" name="Mod+" value="+/-">
			</form>
		</td>

	</tr>
{/foreach}
</table>
{/if}

{if empty($listeCoursGrp)}
<h3>Suppression d'un cours</h3>
<form name="supprCours" id="supprCours" method="POST" action="index.php">
	<p>Le cours <strong>{$cours} {$listeMatieres.$cours.statut} {$listeMatieres.$cours.libelle} {$listeMatieres.$cours.nbheures}h</strong> est orphelin (ni professeur, ni élèves).</p>
	<input type="submit" name="Submit" value="Supprimer ce cours">
	<input type="hidden" name="cours" value="{$cours}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="deleteCours">
	<input type="hidden" name="niveau" value="{$niveau}">
</form>
{/if}

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		$("#groupe").keyup(function(){
			var groupe = $(this).val();
			var matiere = $("#matiere").val();
			$("#nouveauCours").text(matiere+'-'+groupe);
			})
		
		
		$("#creationCours").validate({
				rules: {
					groupe:{
						required: true,
						regex: /^[0]*[1-9]+[a-c]*$/
						},
					profs: {
						required: true
						}
					},
				errorElement: "span"
			});

		$("#supprCours").submit(function(){
			if (!(confirm("La suppression de ce cours est définitive. Veuillez confirmer.")))
				return false;
				else {
					$("#wait").show();
					$.blockUI();
					}
			
			})

		})
	
	$.validator.addMethod(
       "regex",
        function(value, element, regexp) {
        var check = false;
        return this.optional(element) || regexp.test(value);
        },
        "format incorrect"
        );
{/literal}
</script>

