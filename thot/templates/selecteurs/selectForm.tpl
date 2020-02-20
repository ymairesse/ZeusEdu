<div id="selecteur" class="selecteur noprint" style="clear:both">

	<div class="col-xs-9">
		<form name="selectFormulaire" id="selectFormulaire" method="POST" action="index.php" role="form" class="form-inline">

			<select name="idFormulaire" id="idFormulaire" class="form-control">
				<option value="">Formulaire</option>
				{foreach from=$listeFormulaires key=id item=form}
					<option value="{$id}"{if isset($formId) && ($formId == $id)} selected="selected"{/if}>
						{$form.titre|truncate:50:'...'} [{$form.type} -> {$form.destinataire}]
					</option>
				{/foreach}
			</select>
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode|default:null}">
			<input type="hidden" name="etape" value="showForm">

		</form>

	</div>

	<div class="col-xs-3">

		<form action="index.php" method="POST" id="newForm" name="newForm">
			<button type="submit" class="btn btn-primary btn-block">Nouveau formulaire</button>
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="newForm">
		</form>

	</div>


</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#selectFormulaire").change(function(){
		$("#wait").show();
		$.blockUI();
		$("#formSelecteur").submit();
		})

	$("#idFormulaire").change(function(){
		$("#selectFormulaire").submit();
	})
})

</script>
