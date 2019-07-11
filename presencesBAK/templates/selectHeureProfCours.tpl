<div class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		{if $userStatus == 'admin'}
			<label for="freeDate" title="{if $freeDate}{$date} {else}Aujourd'hui{/if}">
				<input type="checkbox" value="1" id="freeDate" name="freeDate"{if $freeDate} checked="checked"{/if} class="form-control">
			Date
			</label>
			<input type="text" name="date" id="datepicker" maxlength="10" value="{$date}"{if !($freeDate)} style="display:none"{/if} class="form-control">
		{/if}


		<select name="selectProf" id="selectProf" class="form-control">
		<option value="">Professeur</option>
			{foreach from=$listeProfs item=unProf}
				<option value="{$unProf.acronyme}"
					{if isset($acronyme) && ($unProf.acronyme == $acronyme)}selected{/if}>
					{$unProf.nom|truncate:15} {$unProf.prenom}
				</option>
			{/foreach}
		</select>


		<span id="selectCoursGrp">
		{if $listeCoursGrp}
		<select name="coursGrp" id="coursGrp" class="form-control input-sm">
			<option value="">Sélectionnez un cours</option>
		{foreach from=$listeCoursGrp key=cours item=data}
			<option value="{$cours}"{if $cours == $coursGrp} selected="selected"{/if}>
				{$data.libelle|truncate:25} ({$data.classes})
			</option>
		{/foreach}
		</select>
		{else}
		<select name="coursGrp" id="coursGrp" class="form-control input-sm">
			<option value=''>Cours</option>
		</select>
		{/if}
		</span>

		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
	</form>


	{if (empty($listePeriodes))}
	<div id="dialog" title="Avertissement">
		<p>Attention! Les périodes de cours ne sont pas encore définies. Contactez l'administrateur</p>
	</div>
	{/if}

</div>

<script type="text/javascript">

	var freeDate = false;

	$(document).ready (function() {

		// ajustement de la liste des cours en fonction du prof sélectionné
		$("#selectProf").change(function(){
			var acronyme = $(this).val();
			if (acronyme != '')
				$.post("inc/listeCoursProf.inc.php", {
					'acronyme': acronyme
					},
					function (resultat){
						$("#selectCoursGrp").html(resultat)
					}
				)
			})

		$("#datepicker").datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$("#freeDate").click(function(){
			freeDate = !(freeDate);
			if (freeDate)
				$("#datepicker").show()
				else $("#datepicker").hide();
			})

		// si le cours change
		// on emploie "on" puisque la liste est générée à chaque changement de prof
		$("#selectCoursGrp").on("change","#coursGrp", function(){
			$("#formSelecteur").submit();
			})

		// si la période choisie change
		$("#selectPeriode").change(function(){
			$("#formSelecteur").submit();
			})

		// on vérifie que le formulaire peut être soumis si toutes les informations sont présentes
		$("#formSelecteur").submit(function(){
			if (($("#selectProf").val() == '') || ($("#coursGrp").val() == '') || $("#selectPeriode").val() == '') {
				return false;
				}
			})

	})

</script>
