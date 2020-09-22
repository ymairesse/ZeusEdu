<div id="modalPrintJDC" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalPrintJDCLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
				<h4 class="modal-title" id="modalPrintJDCLabel">Impression du JDC</h4>
			</div>
			<div class="modal-body row">

				<form id="printForm">
					<div class="col-xs-6">
						<div class="form-group">
							<label for="modalDepuis">Depuis</label>
							<input type="text" name="from" id="from" class="datepicker form-control" value="{$dateDepuis}">
							<div class="helpBlock">
								Date de début d'impression
							</div>
						</div>
					</div>
					<div class="col-xs-6">
						<div class="form-group">
							<label for="modalDepuis">Jusqu'à</label>
							<input type="text" name="to" id="to" class="datepicker form-control" value="">
							<div class="helpBlock">
								Date de fin d'impression
							</div>
						</div>
					</div>

					<div class="col-xs-12" id="modalListeCours">
						<label for="coursGrp">Choix du/des cours</label>
						<select class="form-control" name="coursGrp" id="coursGrp">
							<option value="all">Tout imprimer</option>
							{foreach from=$listeCoursProf key=leCoursGrp item=data}
								<option value="{$leCoursGrp}">
									[{$leCoursGrp}] {if $data.nomCours != ''}{$data.nomCours}{else}{$data.libelle}{/if}
								</option>
							{/foreach}
						</select>
					</div>

					<div class="col-xs-12">
						<div class="form-group">
							<label for="printOptions">Sélection des catégories</label>
							<select class="form-control" name="printOptions[]" id="printOptions" multiple>
								{foreach from=$categories key=idCategorie item=data}
									<option value="{$data.idCategorie}" selected>{$data.categorie}</option>
								{/foreach}
							</select>
							<div class="helpBlock">Maintenir une touche CTRL enfoncée pour choisir plusieurs catégories</div>
						</div>
					</div>

					<div class="clearfix"></div>
				</form>

			</div>
			<div class="modal-footer">
				<div class="btn-group">
					<button type="button" class="btn btn-default"data-dismiss="modal">Annuler</button>
					<button type="button" class="btn btn-primary" id="btnModalPrintJDC">Générer le PDF <i class="fa fa-file-pdf-o fa-lg text-danger"></i></button>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(".datepicker").datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true,
			daysOfWeekDisabled: [0,6],
			}
		);

		$('#printForm').validate({
			rules: {
				from: {
					required: true
				},
				to: {
					required: true
				}
			}
		})

	})

</script>
