<div class="container">
<h2>Gestion des listes de destinataires</h2>

	<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
        <li class="active"><a href="#tabs-1" data-toggle="tab">Suppressions</a></li>
        <li><a href="#tabs-2" data-toggle="tab">Ajouts</a></li>
        <li><a href="#tabs-3" data-toggle="tab">Publication et abonnements</a></li>
    </ul>

    <div id="my-tab-content" class="tab-content">

		<div class="tab-pane active" id="tabs-1">
			{include file="inc/supprMailing.inc.tpl"}
		</div>

		<div class="tab-pane" id="tabs-2">
			{include file="inc/addMailing.inc.tpl"}
		</div>

		<div class="tab-pane" id="tabs-3">
			{include file="inc/abonnements.inc.tpl"}
		</div>

	</div>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

	$(".checkListe").click(function(event){
		event.stopPropagation();
		})

	$(".checkListe").click(function(){
		var id=$(this).prop("id").substr(6,99);
		$("#blocMails_"+id).find('.selecteur').trigger('click');
		$("#selectionDest").text($("input.mailsSuppr:checked").length);
		})

	$(".label").click(function(){
		$(this).prev().trigger('click');
		})

	$(".mailsAjout").click(function(){
		var nb = $(".mailsAjout:input:checkbox:checked").length
		$("#selectionAdd").text(nb);
		})
	$("#resetAdd").click(function(){
		$("#selectionAdd").text(0);
		})
	$("#resetDel").click(function(){
		$("#selectionDest").text(0)
		})


	$("#deleteList").submit(function(){
		if (!(confirm('Les éléments sélectionnés seront effacés. Veuillez confirmer.')))
			return false;
			else {
				$("#wait").show();
				}
		})

	$("#creation").submit(function(){
		if ($("#nomListe").val() == '') {
			alert('Veuille donner un nom pour cette liste');
			return false;
			}
		})


	$(".mailsSuppr").click(function(){
		$("#selectionDest").text($("input.mailsSuppr:checked").length);

		})

	$("#selectListe").change(function(){
		var id = $(this).val();
		$.post( "inc/listContent.inc.php", {
			id: id
			},
			function (resultat){
				$("#listeExistants").html(resultat);
				});
		});

})

</script>
