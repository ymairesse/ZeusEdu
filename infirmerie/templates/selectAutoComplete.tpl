<div id="selectAutocomplete" class="noprint" style="float:left;">
<form name="selecteurAuto" id="formSelecteurAuto" method="POST" action="index.php">

		<input type="text" id="nom" name="nom" size="15" value="{$eleve.nom|default:''}" placeholder="Nom de l'élève">
		<input type="text" id="prenom" name="prenom" size="15" value="{$eleve.prenom|default:''}" placeholder="Prénom de l'élève">
		<input type="text" id="classe" name="classe" size="4" value="{$eleve.classe|default:''}" placeholder="Classe">
		<input type="submit" value="OK" name="OK" id="envoi">

	<input type="hidden" id="matricule" name="matricule" value="">
	<input type="hidden" name="action" value="parEleve">
</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready(function() {

	function completer (matricule) {
		$("#corpsPage").hide();
		$("#pdfcsv").hide();
		$("#formSelecteurAuto").submit();
		}	
	
	$("#nom").autocomplete({
		source: "inc/searchNom.php?critere=nom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			completer (ui.item.matricule);
			}
		});

	$("#prenom").autocomplete({
		source: "inc/searchNom.php?critere=prenom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			completer (ui.item.matricule);
			}
		});
		
	$("#classe").autocomplete({
		source: "inc/searchNom.php?critere=classe",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			completer (ui.item.matricule);
			}
		});
	
	$("#formSelecteurAuto").submit(function(){
		var matricule = $("#matricule").val();
		if (matricule == '') return false;
			else $("#wait").css("z-index","999").show();
		})
	})
{/literal}
</script>