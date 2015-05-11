<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		
		<input type="hidden" name="matricule" id="matricule" value="">

		<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control-inline">
			
		<select name="classe" id="selectClasse" class="form-control-inline">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
			{/foreach}
		</select>

		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	
		<input type="hidden" name="action" value="{$action|default:'wtf'}" id="action">
		<input type="hidden" name="etape" value="showEleve">
	
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#selectClasse").val() != '') || ($("#matricule").val() != '')) {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
		})
	
	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		$("#action").val('parClasses');
		$("#matricule").val('');
		var classe = $(this).val();
		if (classe != '')
			$("#formSelecteur").submit();
	});
	
	$("#envoi").click(function(){
		$("#action").val('parClasses');
		})
	
	$("#nom").keypress(function(){
		$("#action").val('parEleve');
		$("#selectClasse").val('');
		})

	$("#nom").typeahead({
		minLength: 2,
		updater: function (item) {
			return item;
			},
		afterSelect: function(item){
			$.ajax({
				url: 'inc/searchMatricule.php',
				type: 'POST',
				data: 'query=' + item,
				dataType: 'text',
				async: true,
				success: function(data){
					if (data != '') {
						$("#matricule").val(data);
						$("#formSelecteur").submit();
						}
					}
				})
			},
		source: function(query, process){
			$.ajax({
				url: 'inc/searchNom.php',
				type: 'POST',
				data: 'query=' + query,
				dataType: 'JSON',
				async: true,
				success: function (data) {
					$("#matricule").val('');
					process(data);
					}
				}
				)
			}
		})	

})

</script>