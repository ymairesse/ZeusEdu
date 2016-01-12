<div class="container">

<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<form name="modifVisite" id="modifVisite" method="POST" action="index.php" role="form" class="form-vertical">
	<div class="row">

		<div class="col-md-5 col-sm-12">

			<div class="form-group">

				<label for="professeur">Envoyé par</label>

					<div class="input-group">
						<input type="text" name="professeur" id="professeur" value="{if ($visite != Null)}{$visite.envoyePar|default:''}{/if}" maxlength="7" class="form-control" placeholder="Abréviation">
						<span class="input-group-btn">
							<select name="envoyePar" id="listeProfs" class="btn" style="text-align: left">
								<option value="">Nom</option>
								{foreach from=$listeProfs key=acro item=prof}
								<option value="{$acro}"{if ($visite != Null) && ($acro == $visite.envoyePar)} selected="selected"{/if}>{$prof.nom} {$prof.prenom}</option>
								{/foreach}
							</select>
						</span>
					</div>
					<div class="help-group">Abréviation ou sélection dans la liste à droite</div>
			</div>

		<div class="row">

			<div class="col-md-6">

			<div class="form-group">
			<label for="date">Date</label>
				<input id="datepicker" size="10" maxlength="10" type="text" name="date" value="{$visite.date|default:''}" class="form-control">
				<div class="help-group">Clic+Enter pour "Aujourd'hui"</div>
			</div>

			</div>

			<div class="col-md-6">

			<div class="form-group">
				<label for="heure">Heure</label>
				<input id="timepicker" size="5" maxlength="5" type="text" name="heure" value="{$visite.heure|truncate:5:''|default:''}" class="form-control">
				<div class="help-group">Clic+Enter pour "Maintenant"</div>
			</div>

			</div>

		</div>  <!-- row -->

		<div class="form-group">
			<strong>Ne s'est pas présenté </strong>
			<input type="checkbox" name="absent" id="absent" value="1" {if ($visite != Null) && ($visite.absent == 1)} checked{/if}>
		</div>

		<div class="form-group">
			<label for="motif">Motif de la visite</label><br>
			<textarea name="motif" id="motif" rows="4" class="form-control">{$visite.motif|default:''}</textarea>
		</div>

		</div>

		<div class="col-md-5 col-sm-10">

			<div class="form-group">
				<label for="traitement">Travail effectué</label><br>
				<textarea name="traitement" id="traitement" rows="4" class="form-control">{$visite.traitement|default:''}</textarea>
			</div>

			<div class="form-group">
				<strong>Confidentiel </strong>
				<input type="checkbox" name="prive" id="prive" value="1" {if ($visite == Null) || ($visite.prive == 1)} checked{/if}>
			</div>

			<div class="form-group">
				<label for="aSuivre">À suivre</label><br>
				<textarea name="aSuivre" id="aSuivre" class="form-control" rows="4">{$visite.aSuivre|default:''}</textarea><br>
			</div>
		</div> <!-- col-md... -->

		<div class="col-md-2 col-sm-2">
			<img src="../photos/{$eleve.photo}.jpg" class="photo img-responsive" alt="{$eleve.matricule}" title="{$eleve.prenom} {$eleve.nom} {$eleve.matricule}">
			<div class="btn-group-vertical">
				<button type="submit" class="btn btn-primary btn-lg" name="submit">Enregistrer</button>
				<button type="reset" class="btn btn-default btn-lg" name="reset">Annuler</button>
			</div>
		</div>

	</div> <!-- row -->
	<input type="hidden" name="id" value="{$visite.id|default:''}">
	<input type="hidden" name="matricule" value="{$eleve.matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
	<input type="hidden" name="proprietaire" value="{$proprietaire}">
	<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="enregistrer">

</form>

<form name="retour" id="retour" action="index.php" method="POST" class="microForm">
	<input type="hidden" name="action" value="ficheEleve">
	<input type="hidden" name="mode" value="wtf">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
	<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
	<button type="submit" class="btn btn-default pull-right"><i class="fa fa-arrow-left"></i> Retour sans enregistrer</button>
</form>


</div>  <!-- container -->

<script type="text/javascript">

	$("document").ready(function(){

		$("#modifVisite").validate({
			rules: {
				date: {
					required: true
					},
				timepicker: {
					required: true
					}
				}
		});

		$("#nomProf").click(function(){
			$("#prof").show();
		})

		$("#prof").change(function(){
			$("#acronyme").val($(this).val());
			var nom = $(this).find("option:selected").text();
			if (nom != 'Autre')
				$("#nomProf").html(nom);
				else $("#nomProf").html("");
			$("#prof").hide();
			$("#nomProf").show();
		})

		$("#datepicker" ).datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$('#timepicker').timepicker({
			defaultTime: 'current',
			minuteStep: 5,
			showSeconds: false,
			showMeridian: false
			}
		);

		$("#professeur").blur(function(){
			var acronyme = $(this).val().toUpperCase();
			$(this).val(acronyme);
			$("#listeProfs").val(acronyme);
			})

		$("#listeProfs").change(function(){
			var acronyme = $(this).val().toUpperCase();
			$("#professeur").val(acronyme);
			})
	})

</script>
