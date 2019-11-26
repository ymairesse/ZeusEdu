<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<select name="coursGrp" id="coursGrp" class="form-control input-sm">
			<option value="">Cours</option>
			{foreach from=$listeCours key=k item=unCours}
			<option value="{$k}" {if $k == $coursGrp} selected="selected" {/if}>
				{if isset($unCours.nomCours)} [{$unCours.nomCours}] {/if} {$unCours.statut} {$unCours.nbheures}h {$unCours.libelle} - {$unCours.annee} ({$k})
			</option>
			{/foreach}
		</select>
		<input type="text" name="date" id="date" class="datepicker" maxlength="10" size="10" value="{$date}" placeholder="Date">
		<button type="submit" class="btn btn-primary btn-sm">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">
		<input type="hidden" name="etape" value="showListe">

	</form>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$( ".datepicker").datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$("#date").change(function(){
			if (($(this).val() != '') && ($("#classe").val() != ''))
				$("#envoi").show();
				$("#formSelecteur").submit();
			})

		$("#coursGrp").change(function() {
			$("#wait").show();
			$.blockUI();
			$("#formSelecteur").submit();
		})
	})
</script>
