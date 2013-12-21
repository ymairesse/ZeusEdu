<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
		<input type="hidden" name="matricule" id="matricule">
		<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève">
			
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)}selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
		</select>

	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action|default:'wtf'}" id="action">

	<input type="hidden" name="etape" value="showEleve">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#selectClasse").val() != '') || ($("#matricule").val != '')) {
			$("#wait").show();
			//$.blockUI();
			}
			else return false;
	})
	
	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		if (classe != '')
			$("#formSelecteur").submit();
	});
	
	
	$("#nom").autocomplete({
		source: "inc/searchNom.php?critere=nom",
		minLength: 2,
		select: function(event,ui) {
			var matricule = ui.item.matricule;
			$("#matricule").val(matricule);
			$("#action").val('parEleve');
			$("#formSelecteur").submit();
			}
		});
	
	$("#envoi").click(function(){
		$("#action").val('parClasses');
		})

})
{/literal}
</script>