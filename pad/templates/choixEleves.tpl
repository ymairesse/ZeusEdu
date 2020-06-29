<div class="container-fluid">

	<h2>Sélection des notes à partager</h2>
	<h3>
		{if isset($coursGrp)}Cours {$coursGrp}{/if}
		{if isset($classe)}Classe: {$classe}{/if}
	</h3>

	<form name="partage" id="formPartage">

	<div class="row">

		<div class="col-md-5 col-xs-12">

			<div class="panel panel-success">
				<div class="panel-heading">
					Liste des élèves
				</div>
				<div class="panel-body">
					<div id="nbEleves">0 élève sélectionné</div>
						<select name="eleves[]" id="eleves" multiple size="24" class="form-control">
						{foreach from=$listeEleves key=matricule item=eleve}
							<option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
						{/foreach}
						</select>
				</div>
				<div class="panel-footer">
					Sélectionner ici les élèves pour lesquels vous souhaitez partager vos notes personnelles. Garder Ctrl enfoncé pour une sélection multiple.
				</div>
			</div>

		</div> 	<!-- col-md... -->

		<div class="col-md-5 col-xs-12">
			<div class="panel panel-info">
				<div class="panel-heading">
					Partager/dé-partager avec
				</div>
				<div class="panel-body">
					<div id="nbProfs">0 prof sélectionné</div>
					<select name="profs[]" id="profs" multiple size="24" class="form-control">
					{foreach from=$listeProfs key=acronyme item=prof}
						<option value="{$acronyme}">{$prof.nom} {$prof.prenom} [{$acronyme}]</option>
					{/foreach}
					</select>
				</div>
				<div class="panel-footer">
					Sélectionner ici les collègues avec lesquels vous souhaitez partager vos notes personnelles relatives aux élèves. Garder Ctrl enfoncé pour une sélection multiple.
				</div>

			</div>

		</div> <!-- col-md... -->

		<div class="col-md-2 col-xs-12">
			<h4>Mode de partage</h4>
			<div class="radio">
				<label>
					<input type="radio" name="moderw" value="r"{if !(isset($moderw)) || $moderw == 'r'} checked="checked"{/if}> Lecture seule
				</label>
			</div>

			<div class="radio">
				<label>
					<input type="radio" name="moderw" value="rw"{if !(isset($moderw)) || $moderw == 'rw'} checked="checked"{/if}> Lecture/écriture
				</label>
			</div>

			<div class="radio">
				<label>
					<input type="radio" name="moderw" value="release"{if $moderw == 'release'} checked="checked"{/if}> Fin du partage
				</label>
			</div>

			<button type="reset" class="btn btn-default btn-block">Annuler</button>
			<button type="button" class="btn btn-primary btn-block" id="saveShare">Enregistrer</button>

		</div>  <!-- col-md... -->

	</div> <!-- row -->

	</form>

</div>  <!-- container -->


<script type="text/javascript">

$(document).ready(function(){

	$('#saveShare').click(function(){
		var formulaire = $('#formPartage').serialize();
		var message;
		$.post('inc/padShare.inc.php', {
			formulaire: formulaire
		}, function(resultat){
			resultat = Math.abs(resultat);
			bootbox.alert({
				title: 'Création / suppression de partages de notes',
				message: resultat + " partage(s) modifié(s)"
			});
		})
	})

	$("#eleves").change(function(){
		var nb = $("#eleves :selected").length;
		$("#nbEleves").html(nb+" élève(s) sélectionné(s)");
		})

	$("#profs").change(function(){
		var nb = $("#profs :selected").length;
		$("#nbProfs").html(nb+" prof(s) sélectionné(s)");
		})

})

</script>
