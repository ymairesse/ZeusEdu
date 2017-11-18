<div class="container">

	<div class="selecteur noprint">

		<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		Titulaire de
		<select name="groupe" id="groupe" class="form-control">
			<option value=''>Classe</option>
			{foreach from=$lesGroupes item=classe}
				<option value='{$classe}' {if isset($groupe) && ($groupe == $classe)} selected="selected"{/if}>{$classe}</option>
			{/foreach}
		</select>

		<select name="acronyme" id="acronyme" class="form-control">
			<option value="">Sélectionner un nom</option>
			{foreach from=$listeProfs key=abreviation item=unProf}
				<option value="{$abreviation}"{if isset($acronyme) && ($abreviation eq $acronyme)} selected="selected"{/if}>
					{$unProf.nom} {$unProf.prenom} [{$abreviation}]</option>
			{/foreach}
		</select>

		<input type="hidden" name="action" value="classeTitu">
		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>

		</form>
	</div>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

	$("#formSelecteur").submit(function(){
		if (($("#acronyme").val() == '') && ($("#groupe").val() == ''))
			return false;
			else $("#wait").show();
	})

	$("#acronyme").change(function(){
		$("#groupe").val('');
		$("#formSelecteur").submit();
		})

	$("#groupe").change(function(){
		$("#acronyme").val('');
		$("#formSelecteur").submit();
		})

})

</script>
