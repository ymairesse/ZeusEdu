<link rel="stylesheet" href="../widgets/flashInfo/widget.css" type="text/css" media="screen, print">

{if $userStatus == 'admin'}
	<button type="button" class="btn btn-primary pull-right" id="btn-newNews">Nouvelle annonce</button>
{/if}
<div class="clearfix"></div>

<div id="listeAnnonces">
	{if isset($listeFlashInfos) && $listeFlashInfos|@count > 0}

	{include file="./listeAnnonces.tpl"}
	{include file="./modal/modalLecture.tpl"}
	{include file="./modal/modalDelNews.tpl"}

	{/if}  {* flashinfo count > 0 *}
</div>

{include file="./modal/modalEditNews.tpl"}

<script type="text/javascript">

$(document).ready(function(){

	$('#listeAnnonces').on('click', '.btn-edit', function(){
		var id = $(this).closest('li').data('id');
		var module = "{$module}";
		$.post('../widgets/flashInfo/inc/createEditNews.inc.php', {
			id: id,
			module: "{$module}"
		},
		function(resultat){
			$('#editNews').html(resultat);
			$('#modalEditNews').modal('show');
		})
	})

	$('#modalEditNews').on('click', '#saveNews', function(){
		if ($('#editFlash').valid()) {
			CKEDITOR.instances.editor.updateElement();
			var formulaire = $("#editFlash").serialize();
			$.post('../widgets/flashInfo/inc/saveFlashInfo.inc.php', {
				formulaire: formulaire
				},
				function(resultat){
					if (resultat == 1) {
						bootbox.alert({
							message: 'Annonce enregistrée'
							})
						}
						else bootbox.alert({
							message: 'L\'annonce n\'a pas été enregistrée'
						})
				$('#modalEditNews').modal('hide');
				var module = "{$module}";
				// raffraîchir la liste des annonces
				$.post('../widgets/flashInfo/inc/listeAnnonces.inc.php', {
					module: module
				}, function(resultat){
					$('#listeAnnonces').html(resultat);
					// var texte = $('#listeAnnonces').html();
				})
			})
		}
	})

	$('#modalEditNews').on('shown.bs.modal', function () {
	   $('#titre').focus();
	});

	$('#btn-newNews').click(function(){
		var module = "{$module}";
		$.post('../widgets/flashInfo/inc/createEditNews.inc.php', {
			module: module
		},
			function(resultat){
				$('#editNews').html(resultat);
				$('#modalEditNews').modal('show');
			})
	})

	$('#listeAnnonces').on('click', '.btn-del', function(){
		var id = $(this).closest('li').data('id');
		var titre = $(this).closest('li').data('titre');;
		$('#btn-modalDelNews').data('id', id);
		$("#newsTitle").html(titre);
		$('#modalDel').modal('show');
	})

	$('#btn-modalDelNews').click(function(){
		var id = $(this).data('id');
		var module = "{$module}"
		$.post('../widgets/flashInfo/inc/delNews.inc.php', {
			id: id,
			module: module
			}, function (resultat){
				if (resultat >= 0) {
					$('li.uneNews[data-id="' + resultat + '"]').remove();
					bootbox.alert({
						message: 'Cette annonce a été effacée'
					});
				}
		})
		$('#modalDel').modal('hide');
	})

	$('#listeAnnonces').on('click', '.btn-titleNews, #btn-eye', function(){
		var texteHTML = $(this).closest('li').data('texte');
		var titre = $(this).closest('li').data('titre');
		$('#modalLecture .texteNews').html(texteHTML);
		$('#modalLecture .modal-title').html(titre);
		$('#modalLecture').modal('show');
	})

})

</script>
