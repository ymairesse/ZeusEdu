<h2>Gestion des listes de destinataires</h2>
<div id="tabs">

	<ul>
	<li><a href="#tabs-1">Suppressions</a></li>
	<li><a href="#tabs-2">Ajouts</a></li>
	<li><a href="#tabs-3">Publication et abonnements</a></li>
	</ul>

	<div id="tabs-1">
		{include file="supprMailing.inc.tpl"}
	</div>

	<div id="tabs-2">
		{include file="addMailing.inc.tpl"}
	</div>

	<div id="tabs-3">
		{include file="abonnements.inc.tpl"}
	</div>

</div>

<script type="text/javascript">

<!-- quel est l'onglet actif? -->
var onglet = "{$onglet|default:''}";

$(document).ready(function(){

	<!-- si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet' -->
	$("#tabs ul li a").click(function(){
		var no = $(this).attr("href").substr(6,1);
		$(".onglet").val(no-1);
		});

	$("#tabs").tabs();

	<!-- activer l'onglet dont le numéro a été passé -->
	$('#tabs').tabs("option", "active", onglet);

	$("h4.teteListe").click(function(){
		var id = $(this).find("input").val();
		$(".blocMails").fadeIn();
		$("#blocMails_"+id).fadeToggle('slow');
		})

	$(".checkListe").click(function(event){
		event.stopPropagation();
		})

	$(".checkListe").click(function(){
		var id=$(this).prop("id").substr(6,99);
		$("#blocMails_"+id).find('.selecteur').trigger('click');
		$("#selectionDest").text($(".blocMails").find("input:checkbox:checked").length);
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
		$("#selectionSuppr").text(0)
		})


	$("#deleteList").submit(function(){
		if (!(confirm('Les éléments sélectionnés seront effacés. Veuillez confirmer.')))
			return false;
			else {
				$("#wait").show();
				}
		})

	$("#confirmDelete").dialog({
		modal: true,
		buttons: {
            "OK": function() {
                $( this ).dialog("close");
            }
        }
		});

	$("#dialogNom").dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			OK: function(){
				$(this).dialog("close");
				$("#nomListe").focus();
				}
			}
		});

	$("#creationListe").dialog({
		autoOpen: true,
		modal: true,
		buttons: {
			OK: function(){
				$(this).dialog("close");
				}
			}
		});

	$("#dialogNomListe").dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			OK: function() {
				$(this).dialog("close");
				$("#selectListe").focus();
				}
			}
		});

	$("#dialogueMembres").dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			OK: function() {
				$(this).dialog("close");
				}
			}
		})

	$("#dialogueAjout").dialog({
		autoOpen: true,
		modal: true,
		buttons: {
			OK: function() {
				$(this).dialog("close");
				}
			}
		})

	$("#creation").submit(function(){
		if ($("#nomListe").val() == '') {
			$("#dialogNom").dialog("open");
			return false;
			}
		})

	$("#ajoutMembres").submit(function(){
		if ($("#selectListe").val() == '') {
			$("#dialogNomListe").dialog("open");
			return false;
			}
		if ($(".mailsAjout:input:checkbox:checked").length == 0) {
			$("#dialogueMembres").dialog("open");
			return false;
			}

		})

	$(".mailsSuppr").click(function(){
		$("#selectionDest").text($(".blocMails").find("input:checkbox:checked").length);
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
