<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		{if $userStatus == 'admin'}
			<select class="form-control" name="typeGestion" id="typeGestion">
				<option value="eleve" {if ($typeGestion == 'eleve')}selected{/if}>Par élève</option>
				<option value="prof"  {if ($typeGestion == 'prof')}selected{/if}>Par enseignant</option>
			</select>
		{/if}

		<select name="idRP" id="idRP" class="form-control">
			<option value="">Choisir une date</option>
			{if isset($listeDates)}
				{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate.idRP}" {if isset($idRP) && ($uneDate.idRP==$idRP)} selected="selected" {/if}>
					Réunion du {$uneDate.date}
				</option>
				{/foreach}
			{/if}
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
