<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		{if $userStatus == 'admin'}
		<select name="typeGestion" id="type">
			<option
				value="eleve"
				{if isset($type) && ($type == 'eleve')} selected{/if}
				{if isset($type) && ($type == 'titulaires')} disabled{/if}>
				Par élève
			</option>
			<option id="optProf"
				value="prof"
				{if isset($type) && ($type == 'prof')} selected{/if}>Par enseignant</option>
		</select>
		{/if}

		<select name="date" id="date">
			<option value="">Date de réunion de parents</option>
			{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate}"{if isset($date) && ($uneDate == $date)} selected="selected"{/if}>
					{$uneDate}
				</option>
			{/foreach}
		</select>

		<button type="submit" class="btn btn-primary btn-sm">OK</button>

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">
		<input type="hidden" name="etape" value="show">
		<input type="hidden" name="typeRP" id="typeRP" value="{$typeRP|default:''}">

	</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#date").change(function(){
		var date = $(this).val();
		$.post('inc/reunionParents/chercheTypeRP.inc.php', {
			date: date
			},
		function(resultat){
			// on ne doit pas pouvoir sélectionner les RV par élèves si la RP est par titulaire
			if (resultat == 'profs') {
				$("#typeGestion option[value='eleve']").prop('disabled', false);
				}
				else {
					$("#typeGestion option[value='eleve']").prop('disabled', true);
					$("#typeGestion option[value='prof']").prop('selected', true);
				}
			$("#typeRP").val(resultat);
		})
		// $("#wait").show();
		//$.blockUI();
		// $("#formSelecteur").submit();
		})

})

</script>
