<div class="container">
	
<h3>Création d'un nouveau cours</h3>

<form name="creationCours" id="creationCours" action="index.php" method="POST" role="form" class="form-vertical">

	<div class="row panel panel-default">
		
		<div class="panel-heading">
			<h4>Matière</h4>
		</div>
		
		<div class="panel-body">
		
		<div class="col-md-2 col-sm-6">

			<div class="input-group">
				<label>Matière</label>
				<p class="form-control-static">{$cours}</p>
			</div>
			
		</div>
		
		<div class="col-md-2 col-sm-6">

			{assign var=dataCours value=$listeMatieres.$cours}
			<div class="input-group">
				<label>Libellé</label>
				<p class="form-control-static">{$dataCours.libelle}</p>
			</div>
			
		</div>
		
		<div class="col-md-2 col-sm-6">
		
			<div class="input-group">
				<label>Cadre</label>
				<p class="form-control-static">{$dataCours.cadre}</p>
			</div>
			
		</div>
		
		<div class="col-md-2 col-sm-6">			
				
			<div class="input-group">
				<label>Statut</label>
				<p class="form-control-static">{$dataCours.statut}</p>
			</div>
		
		</div>
		
		<div class="col-md-2 col-sm-6">	
				
			<div class="input-group">
				<label>Nombre d'heures</label>
				<p class="form-control-static">{$dataCours.nbheures}h</p>
			</div>
			
		</div>  <!-- col-md-... -->
		
		</div>  <!-- panel-body -->
		
	</div>  <!-- row -->
	
	<div class="row">

		<div class="panel panel-default">
			
			<div class="panel-heading">
				<h4>Nouvelle occurrence</h4>
			</div>
			
			<div class="panel-body">
				
				<div class="col-md-3 col-sm-6">
				
					<div class="input-group">
						<label>Nouveau cours:</label>
						<p class="form-control-static" id="nouveauCours">{$cours}</p>
					</div>
					
				</div>  <!-- col-md-... -->

				<div class="col-md-4 col-sm-6">
					
					<div class="input-group">
						<label for="groupe">Groupe [(0)n(x)]</label>
						<input type="text" name="groupe" id="groupe" maxlength="3" class="form-control">
						<div class="help-block">1 ou 2 chiffres puis 0 ou 1 lettre (a, b ou c)</div>
					</div>
				
				</div>  <!-- col-md-... -->
				
				<div class="col-md-5 col-sm-6">
					
					<div class="input-group">
						<label for="profs">Professeur(s)</label>
						<select name="profs[]" id="profs" multiple="multiple" class="form-control">
							<option value="">Sélectionner un ou plusieurs noms</option>
							{foreach from=$listeProfs key=acronyme item=data}
							<option value="{$acronyme}">{$data.nom} {$data.prenom}</option>
							{/foreach}
						</select>
						<div class="help-block">Touche CTRL enfoncée pour une sélection multiple</div>
					</div>
					
				</div>  <!-- col-md-... -->
				
			</div>  <!-- panel-body -->
			
		</div>	<!-- panel -->
			
			<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
			<button type="reset" class="btn btn-default pull-right">Annuler</button>
			<input type="hidden" name="cours" id="matiere" value="{$cours}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="niveau" value="{$niveau}">
			<input type="hidden" name="etape" value="enregistrer">
				
				
	</div>  <!-- row -->
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

</div>


<script type="text/javascript">

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

</script>

