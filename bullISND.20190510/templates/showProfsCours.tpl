<div class="container">

	{if isset($coursGrp)}
	<h2>Attribution des cours aux enseignants</h2>
	<div class="row">
		<div class="col-md-6 col-sm-12">
			<form name="supprProfCours" id="supprProfCours" method="POST" action="index.php" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Titulaire(s) du cours {if (isset($coursGrp))}{$coursGrp}{/if}</h3>
					</div>
					<div class="panel-body">
						{foreach from=$listeProfsTitulaires key=acronyme item=prof}
						<div class="checkbox">
						  <label>
							  <input type="checkbox" name="supprProf[]" value="{$acronyme}" title="Cochez pour supprimer"> {$prof}
						  </label>
						</div>
						{/foreach}

						<input type="hidden" name="coursGrp" value="{$coursGrp}">
						<input type="hidden" name="action" value="admin">
						<input type="hidden" name="mode" value="attributionsProfs">
						<input type="hidden" name="etape" value="supprProfs">
						<button class="btn btn-primary btn-block" type="submit" name="Envoyer">Supprimer les enseignants sélectionnés <span class="glyphicon glyphicon-arrow-right"></span></button>
						<input type="hidden" name="niveau" value="{$niveau}">

						<h4>Élèves inscrits (pour information)</h4>
						<select size="15" name="eleves" id="eleves" class="form-control" readonly>
							{foreach from=$listeEleves key=matricule item=eleve}
							<option value="{$matricule}">{$eleve.classe} - {$eleve.nom} {$eleve.prenom}</option>
							{/foreach}
						</select>
					</div>
					<div class="panel-footer">
						Liste des élèves "pour mémoire"
					</div>

				</div>

			</form>
		</div>
		<!-- col-md... -->

		<div class="col-md-6 col-sm-12">

			<form name="addProfCours" id="addProfCours" method="POST" action="index.php" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Professeurs à affecter au cours</h3>
					</div>
					<div class="panel-body">
						<select multiple="multiple" size="15" name="addProf[]" value="" class="form-control">
							{foreach from=$listeTousProfs key=acronyme item=prof}
							<option value="{$acronyme}">{$prof.acronyme}: {$prof.nom} {$prof.prenom}</option>
							{/foreach}
						</select>

						<input type="hidden" name="coursGrp" value="{$coursGrp}">
						<input type="hidden" name="action" value="admin">
						<input type="hidden" name="mode" value="attributionsProfs">
						<input type="hidden" name="etape" value="addProfs">
						<button button class="btn btn-primary btn-block" name="Envoyer" type="submit"><span class="glyphicon glyphicon-arrow-left"></span> Ajouter les enseignants sélectionnés</button>
						<input type="hidden" name="niveau" value="{$niveau}">
					</div>

				</div>
				<div class="panel-footer">
					Vous pouvez sélectionner plusieurs profs (touche Ctrl enfoncée)
				</div>

			</form>

		</div>
		<!-- col-md-... -->

	</div>
	<!-- row -->
	{/if}

</div>

<script type="text/javascript">
	$(document).ready(function() {
		$("#supprProfCours").submit(function() {
			$.blockUI();
			$("#wait").show();
		})

		$("#addProfCours").submit(function() {
			$.blockUI();
			$("#wait").show();
		})


	})
</script>
