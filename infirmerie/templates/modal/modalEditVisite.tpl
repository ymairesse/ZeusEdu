<div id="modalEditVisite" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditVisiteLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditVisiteLabel">Visite à l'infirmerie de {$dataEleve.nom} {$dataEleve.prenom} : {$dataEleve.classe}</h4>
      </div>
      <div class="modal-body">

  		<form id="form-editVisite">
  			<div class="row">

  				<div class="col-md-5 col-sm-12 row">

					<label for="acronyme">Professeur</label>
					<div class="input-group">

						<input type="text" class="form-control" name="acronyme" id="acronyme" style="width:30%" value="{$visite.acronyme}">

						<select name="listeProfs" class="form-control" id="listeProfs" style="width:70%">
							<option value="">Nom</option>
							{foreach from=$listeProfs key=acronyme item=prof}
							<option value="{$acronyme}"{if ($visite != Null) && ($acronyme == $visite.acronyme)} selected="selected"{/if}>{$prof.nom} {$prof.prenom}</option>
							{/foreach}
						</select>

					</div>

					 <div class="help-group">Abréviation ou sélection dans la liste à droite</div>


  					<div class="form-group">
  					<label for="date">Date</label>
  						<input id="datepicker" size="10" maxlength="10" type="text" name="date" value="{$visite.date|default:''}" class="form-control">
  						<div class="help-group">Clic+Enter pour "Aujourd'hui"</div>
  					</div>

  					<div class="form-group">
  						<label for="heure">Heure</label>
  						<input id="timepicker"
							size="5" maxlength="5"
							type="text"
							name="heure"
							value="{$visite.heure|truncate:5:''|default:''}"
							class="form-control">
  					</div>
  				</div>

  				<div class="col-md-5 col-sm-10">

  					<div class="form-group">
  						<label for="motif">Motif de la visite</label><br>
  						<textarea name="motif" id="motif" rows="4" class="form-control">{$visite.motif|default:''}</textarea>
  					</div>

  					<div class="form-group">
  						<label for="traitement">Traitement</label><br>
  						<textarea name="traitement" id="traitement" rows="4" class="form-control">{$visite.traitement|default:''}</textarea>
  					</div>

  					<div class="form-group">
  						<label for="aSuivre">À suivre</label><br>
  						<textarea name="aSuivre" id="aSuivre" class="form-control" rows="1">{$visite.aSuivre|default:''}</textarea><br>
  					</div>
  				</div> <!-- col-md... -->

  				<div class="col-md-2 col-sm-2">
  					<img src="../photos/{$dataEleve.photo}.jpg" class="photo img-responsive" alt="{$dataEleve.matricule}" title="{$dataEleve.prenom} {$dataEleve.nom} {$dataEleve.matricule}">
  				</div>

  			</div> <!-- row -->
  			<input type="hidden" name="consultID" value="{$consultID|default:''}">
			<input type="hidden" name="matricule" value="{$dataEleve.matricule}">

  		</form>
      </div>
      <div class="modal-footer">
		  <button type="button" class="btn btn-primary" name="btn-saveVisite" id="btn-saveVisite">Enregistrer</button>
		  <button type="reset" class="btn btn-default" name="reset">Annuler</button>
      </div>
    </div>
  </div>
</div>



</div>  <!-- container -->

<script type="text/javascript">

	$("document").ready(function(){

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
