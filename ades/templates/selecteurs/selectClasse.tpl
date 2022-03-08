<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" role="form" class="form-inline">
		<select name="classe" id="selectTrombi" class='form-control input-sm'>
		<option value="">Classe</option>
			{foreach from=$lesGroupes item=unGroupe}
				<option value="{$unGroupe}" {if isset($classe) && ($unGroupe == $classe)}selected{/if}>{$unGroupe}</option>
			{/foreach}
		</select>
		<button type="button" class="btn btn-primary btn-sm" id="envoiClasse">OK</button>
		<span id="ajaxLoader" class="hidden pull-right">
			<img src="images/ajax-loader.gif" alt="loading" class="img-responsive">
		</span>

	</form>

</div>

<script type="text/javascript">

	function showTrombi(classe) {
	$.post('inc/eleves/generateTrombi.inc.php', {
		classe: classe
		},
	function(resultat){
		$("#trombinoscope").show().html(resultat);
		$('#ficheEleve').hide();
		})
	}

	$(document).ready(function(){

		var classe = '{$classe}';
		if (classe != undefined){
			showTrombi(classe);
		}

		$('#envoiClasse').click(function(){
			var classe = $('#selectTrombi').val();
			if (classe != '') {
				showTrombi(classe);
				}
				else $("#trombinoscope").hide();
			})

		$('#selectTrombi').change(function(){
			var classe = $(this).val();
			if (classe != '')
				showTrombi(classe);
		})
	})

</script>
