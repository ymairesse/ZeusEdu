<div class="container">
	
<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>
	
<form name="modifVisite" id="modifVisite" method="POST" action="index.php" role="form" class="form-vertical">
	<div class="row">
		
		<div class="col-md-5 col-sm-12">
			
			<div class="form-group">
				<label for="professeur">Professeur</label>
					<div class="input-group">
						<input type="text" name="acronyme" id="professeur" value="{if ($visites != Null)}{$visites.$consultID.acronyme|default:''}{/if}" maxlength="3" class="form-control" placeholder="Abréviation">
						<span class="input-group-btn">
							<select name="listeProfs" id="listeProfs" class="btn" style="text-align: left">
								<option value="">Nom</option>
								{foreach from=$listeProfs key=acronyme item=prof}
								<option value="{$acronyme}"{if ($visites != Null) && ($acronyme == $visites.$consultID.acronyme)} selected="selected"{/if}>{$prof.nom} {$prof.prenom}</option>
								{/foreach}
							</select>
						</span>
					</div>
					<div class="help-group">Abréviation ou sélection dans la liste à droite</div>
			</div>
			
			
			<div class="form-group">
			<label for="date">Date</label>
				<input id="datepicker" size="10" maxlength="10" type="text" name="date" value="{$visites.$consultID.date|default:''}" class="form-control">
				<div class="help-group">Clic+Enter pour "Aujourd'hui"</div>
			</div>
			
			<div class="form-group">
				<label for="heure">Heure</label>
				<input id="timepicker" size="5" maxlength="5" type="text" name="heure" value="{$visites.$consultID.heure|truncate:5:''|default:''}" class="form-control">
				<div class="help-group">Clic+Enter pour "Maintenant"</div>
			</div>
		</div>
		
		<div class="col-md-5 col-sm-10">

			<div class="form-group">
				<label for="motif">Motif de la visite</label><br>
				<textarea name="motif" id="motif" rows="4" class="form-control">{$visites.$consultID.motif|default:''}</textarea>
			</div>
			
			<div class="form-group">
				<label for="traitement">Traitement</label><br>
				<textarea name="traitement" id="traitement" rows="4" class="form-control">{$visites.$consultID.traitement|default:''}</textarea>
			</div>

			<div class="form-group">
				<label for="aSuivre">À suivre</label><br>
				<textarea name="aSuivre" id="aSuivre" class="form-control" rows="1">{$visites.$consultID.aSuivre|default:''}</textarea><br>
			</div>
		</div> <!-- col-md... -->
		
		<div class="col-md-2 col-sm-2">
			<div class="btn-group-vertical pull-right">
				<button type="submit" class="btn btn-primary" name="submit">Enregistrer</button>
				<button type="reset" class="btn btn-default" name="reset">Annuler</button>
			</div>
			<img src="../photos/{$eleve.photo}.jpg" class="photo img-responsive" alt="{$eleve.matricule}" title="{$eleve.prenom} {$eleve.nom} {$eleve.matricule}">
		</div>
		
	</div> <!-- row -->
	<input type="hidden" name="consultID" value="{$consultID|default:''}">
	<input type="hidden" name="matricule" value="{$eleve.matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
	<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
	<input type="hidden" name="action" value="enregistrer">
	<input type="hidden" name="mode" value="visite">

</form>

	<form name="retour" id="retour" action="index.php" method="POST" class="microForm">
		<input type="hidden" name="action" value="parEleve">
		<input type="hidden" name="mode" value="wtf">
		<input type="hidden" name="matricule" value="{$matricule}">
		<input type="hidden" name="classe" value="{$eleve.classe}">
		<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
		<button type="submit" class="btn btn-primary">Retour sans enregistrer</button>
	</form>


</div>  <!-- container -->

<script type="text/javascript">

	$("document").ready(function(){
		
		$("#modifVisite").submit(function(){
			$.blockUI();
			$("#wait").show();
		});
		
		$("#plus").next().hide();
	
		$("#plus").click(function(){
			$(this).next().toggle();
			if ($("#prof").is(":visible"))
				$("#nomProf").hide();
				else $("#nomProf").show();
		})
		
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

