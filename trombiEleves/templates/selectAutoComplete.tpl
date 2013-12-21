<div id="selectAutocomplete" class="noprint" style="float:left;">
<form name="selecteurAuto" id="formSelecteurAuto" method="POST" action="index.php">
	<p class="ui-widget" style="margin:0">
		<input type="text" id="nom" name="nom" size="15" value="{$nom|default:''}" placeholder="Nom de l'élève">
		<input type="text" id="prenom" name="prenom" size="15" value="{$prenom|default:''}" placeholder="Prénom de l'élève">
		<input type="text" id="classe" name="classe" size="4" value="{$classe|default:''}" placeholder="classe">
		<input type="submit" value="OK" name="OK" id="envoi">
		<span id="photo" style="float:right"></span>
	</p>
	<input type="hidden" id="matricule" name="matricule" value="">
	<input type="hidden" name="action" value="parEleve">
	

</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready(function() {

		$("#matricule").attr('value','');

	$("#nom").autocomplete({
		source: "inc/searchNom.php?critere=nom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px'>");			
			$("#corpsPage").hide();
			$("#pdfcsv").hide();
			}
		});

	$("#prenom").autocomplete({
		source: "inc/searchNom.php?critere=prenom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px'>");		
			$("#corpsPage").hide();
			$("#pdfcsv").hide();
			}
		});
		
	$("#classe").autocomplete({
		source: "inc/searchNom.php?critere=classe",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px' alt='"+ui.item.matricule+"'>");
			$("#corpsPage").hide();
			$("#pdfcsv").hide();
			}
		});
	$("#formSelecteurAuto").submit(function(){
		if ($("#matricule").val() == '')
			return false;
			else $("#wait").css("z-index","999").show();
		})
	})
{/literal}
</script>