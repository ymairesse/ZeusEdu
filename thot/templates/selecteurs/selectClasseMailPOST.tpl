<div class="row">

	<div class="col-md-6 col-sm-12">
		<div class="noprint" style="clear:both">

			<form name="selecteur" id="formSelecteurClasse" method="POST" action="index.php" role="form" class="form-inline selecteur">
				<select name="classe" id="selectClasse" class="form-control input-sm">
				<option value="">Classe</option>
					{foreach from=$listeClasses item=uneClasse}
						<option value="{$uneClasse}" {if (isset($classe) && ($uneClasse == $classe)) || $listeClasses|count == 1}selected{/if}>{$uneClasse}</option>
					{/foreach}
				</select>
				<button type="submit" class="btn  btn-primary btn-sm">OK</button>
				<input type="hidden" name="mode" value="gestParents">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="etape" value="show">
				<input type="hidden" name="type" value="classe">
			</form>

		</div>
	</div>
	<div class="col-md-6 col-sm-12">
		<div class="noprint">
			<form name="selecteurMail" id="formSelecteurMail" method="POST" action="index.php" role="form" class="form-inline selecteur">
				<input type="text" name="mail" value="{$mail|default:''}" class="form-control input-sm" placeholder="Adresse mail">
				<button type="submit" class="btn btn-primary btn-sm" name="button">Chercher</button>
				<input type="hidden" name="mode" value="searchMail">
				<input type="hidden" name="action" value="admin">
		</div>
	</div>

</div>

<script type="text/javascript">

	$(document).ready (function() {

		$("#formSelecteurClasse").submit(function(){
			$("#wait").show();
			$.blockUI();
		})

		$("#selectClasse").change(function(){
			if ($(this).val() != '') {
				$("#formSelecteurClasse").submit();
			}
		})

	})

</script>
