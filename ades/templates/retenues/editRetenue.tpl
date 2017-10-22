<h3>Dates et modification des dates de retenues</h3>

	<form role="form" name="dateRetenue" id="dateRetenue" action="index.php" method="POST" class="form-vertical">

		<div class="row">

			<div class="col-md-4 col-sm-12">

				<div class="form-group">
					<label for="typeRetenue">Type de retenue</label>
					<select name="typeRetenue" id="typeRetenue" class="form-control">
						<option value="">Type de retenue</option>
						{foreach from=$typesRetenues key=idType item=leTypeRetenue}
							<option value="{$idType}" {if $idType == $typeRetenueCourant} selected="selected"{/if}>{$leTypeRetenue.titreFait}</option>
						{/foreach}
					</select>
					<p class="help-block">Sélectionnez le type de retenue</p>
				</div>

				<div class="form-group">
					<label for="datepicker">Date</label>
					<div class="input-group">
						<input id="datepicker" name="dateRetenue" type="text" value="{$retenue.dateRetenue|default:''}" class="datepicker form-control">
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
					</div>
					<p class="help-block">Choisissez la date de la retenue</p>
				</div>

				<div class="form-group bootstrap-timepicker">
					<label for="timepicker">Heure</label>
					<div class="input-group">
						<input type="text" id="heure" value="{$retenue.heure}" name="heure" class="timepicker form-control">
						<span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
					</div>
					<p class="help-block">Choisissez l'heure de la retenue</p>
				</div>

			</div>  <!-- md-col-... -->

			<div class="col-md-4 col-sm-12">

				<div class="form-group">
					<label for="duree">Durée</label>
					<select name="duree" id="duree" class="form-control">
						<option value=''>Durée</option>
						<option value='1'{if $retenue.duree == 1} selected="selected"{/if}>1h</option>
						<option value='2'{if $retenue.duree == 2} selected="selected"{/if}>2h</option>
						<option value='3'{if $retenue.duree == 3} selected="selected"{/if}>3h</option>
					</select>
					<p class="help-block">Choisissez la durée de la retenue</p>
				</div>

				<div class="form-group">
					<label for="local">Local</label>
					<input type="text" name="local" value="{$retenue.local}" maxlength="30" id="local" class="form-control" autocomplete="on">
					<p class="help-block">Choisissez un local</p>
				</div>

				<div class="form-group">
					<label for="places">Places</label>
					<input type="text" name="places" value="{$retenue.places}" maxlength="2" id="places" class="form-control">
					<p class="help-block">Nombre de places disponibles</p>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-12">

				<div class="form-group">
					<label>Occupation</label>
					<p class="form-control-static">{$retenue.occupation}</p>
					<input type="hidden" name="occupation" id="occupation" value="{$retenue.occupation}">
					<p class="help-block">Occupation actuelle (non modifiable)</p>
				</div>

				<div class="form-group">
					<label for="visible">Visible</label>
					<input type="checkbox" id="visible" name="affiche" class="form-control-inline" value="O"{if $retenue.affiche == 'O'} checked="checked"{/if}>
					<p class="help-block">Cette retenue apparaît dans les listes?</p>
				</div>

				<div class="form-group">
					<label for="recurrence">Répéter</label>
					<input type="text"
							name="recurrence"
							id="recurrence"
							value="0"
							class="form-control"
							{if $retenue.idretenue != ''} disabled{/if}>
					<p class="help-block">Nombre de semaines successives pour la retenue</p>
				</div>


			</div>  <!-- col-md-... -->

			<div class="btn-group pull-right">
				<button class="btn btn-default" type="reset">Annuler</button>
				<button class="btn btn-primary" type="submit">Enregistrer</button>
			</div>
			<input type="hidden" name="action" value="retenues">
			<input type="hidden" name="mode" value="Enregistrer">
			<input type="hidden" name="idRetenue" value="{$retenue.idretenue}">

		</div>  <!-- row -->

	</form>

<script type="text/javascript">

	$.validator.addMethod(
		"dateFr",
		function(value, element) {
			return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
		},
		"date au format jj/mm/AAAA svp"
	);

	$(document).ready(function(){

		$("#heure").timepicker({
			defaultTime: 'current',
			minuteStep: 5,
			showSeconds: false,
			showMeridian: false
			});

		$( "#datepicker").datepicker({
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$("#dateRetenue").validate({
			rules: {
				typeRetenue: {
					required: true
					},
				duree: {
					required:true
					},
				dateRetenue: {
					required: true,
					dateFr: true
					},
				local: {
					required:true
					},
				places: {
					required: true,
					min: $("#occupation").val(),
					max: 30
					},
				recurrence: {
					required: true,
					number: true,
					range:[0,30]
				}
				},
			errorElement: "span"
			});

		})

</script>
