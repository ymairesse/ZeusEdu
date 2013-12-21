1<form method="POST" action="">
	<p class="ui-widget">
	<input type="text" id="nom" name="nom" value="{$nom}" placeholder="Nom de l'élève">
	<input type="text" id="prenom" name="prenom" value="{$prenom}"  placeholder="Prénom de l'élève">
	<input type="text" id="classe" name="classe" size="4" value="{$classe}" >
	</p>
	<input type="hidden" id="matricule" name="matricule" value="">
	<input type="submit" value="OK" id="OK">
	<input type="reset" value="Annuler" id="reset">
	<div id="photo"></div>
</form>

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
	$("#matricule").attr('value','');

    $("#nom").autocomplete({
		source: "inc/searchNom.php?critere=nom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px'>");			
			}
		});

	$("#prenom").autocomplete({
		source: "inc/searchNom.php?critere=prenom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px'>");		
			}
		});
		
	$("#classe").autocomplete({
		source: "inc/searchNom.php?critere=classe",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px' alt='"+ui.item.matricule+"'>");
			}
		});
	})
{/literal}
</script>