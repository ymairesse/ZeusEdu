<script type="text/javascript">
{literal}
	$(document).ready(function() {

		$("#matricule").attr('value','');

		$('input[type="text"]').focus(function() {
			if( $(this).attr('value') == $(this).attr('defaultValue') ){
			$(this).attr('value', '');
			$(this).addClass("inputNormal").removeClass("inputDefault");
			};
		});
		
		$('input[type="text"]').blur(function(){
			if( $(this).attr('value') == '' ){
				$(this).attr('value', $(this).attr('defaultValue'));
				$(this).addClass("inputDefault").removeClass("inputNormal");
			};
		} );

	$("#nom").autocomplete({
		source: "inc/searchNom.php?critere=nom",
		minLength: 2,
		select: function(event,ui) {
			$("#matricule").val(ui.item.matricule);
			$("#prenom").val(ui.item.prenom).removeClass("inputDefault");
			$("#classe").val(ui.item.classe).removeClass("inputDefault");
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
			$("#nom").val(ui.item.nom).removeClass("inputDefault");
			$("#classe").val(ui.item.classe).removeClass("inputDefault");
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
			$("#nom").val(ui.item.nom).removeClass("inputDefault");
			$("#prenom").val(ui.item.prenom).removeClass("inputDefault");
			$("#photo").html("<img class='photoEleve' src='../photos/"+ui.item.matricule+".jpg' width='100px' alt='"+ui.item.matricule+"'>");
			$("#corpsPage").hide();
			$("#pdfcsv").hide();
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
<div id="selectAutocomplete" class="noprint" style="float:left;">
<form name="selecteurAuto" id="formSelecteurAuto" method="POST" action="index.php">
	<p class="ui-widget" style="margin:0">
		<input type="text" id="nom" name="nom" size="15" value="nom de l'élève" class="inputDefault">
		<input type="text" id="prenom" name="prenom" size="15" value="prenom de l'élève" class="inputDefault">
		<input type="text" id="classe" name="classe" size="4" value="classe" class="inputDefault">
		<input type="submit" value="OK" name="OK" id="envoi">
		<span id="photo" style="float:right"></span>
	</p>
	<input type="hidden" id="matricule" name="matricule" value="">
	<input type="hidden" name="action" value="parEleve">
	

</form>
</div>
