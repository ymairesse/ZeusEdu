{if $userStatus == 'admin'}
	<button type="button" class="btn btn-primary pull-right" id="btn-newNews">Nouvelle annonce</button>
{/if}
<div class="clearfix"></div>

{if isset($listeFlashInfos) && $listeFlashInfos|@count > 0}

	<h3>Annonces</h3>
	<div id="listeAnnonces">
		{include file="flashInfo/listeAnnonces.tpl"}
	</div>

	{include file="flashInfo/modal/modalLecture.tpl"}
	{include file="flashInfo/modal/modalDelNews.tpl"}

{/if}  {* flashinfo count > 0 *}

{include file="flashInfo/modal/modalEditNews.tpl"}

<script type="text/javascript">

$(document).ready(function(){

	$('#listeAnnonces').on('click', '.btn-edit', function(){
		var id = $(this).closest('li').data('id');
		$.post('inc/flashInfo/createEditNews.inc.php', {
			id: id
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
			$.post('inc/flashInfo/saveFlashInfo.inc.php', {
				formulaire: formulaire
				},
				function(resultat){
					if (resultat == 1) {
						// raffraîchir la liste des annonces
						$.post('inc/flashInfo/listeAnnonces.inc.php', {
						}, function(resultat){
							$('#listeAnnonces').html(resultat);
						});
						bootbox.alert({
							message: 'Annonce enregistrée'
						})
						}
						else bootbox.alert({
							message: 'L\'annonce n\'a pas été enregistrée'
						})
				$('#modalEditNews').modal('hide');
			})
		}
	})

	$('#modalEditNews').on('shown.bs.modal', function () {
	   $('#titre').focus();
	});

	$('#btn-newNews').click(function(){
		$.post('inc/flashInfo/createEditNews.inc.php', {
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
		$.post('inc/flashInfo/delNews.inc.php', {
			id: id
			}, function (resultat){
				if (resultat >= 0) {
					$('li.uneNews[data-id="' + resultat + '"]').remove();
					bootbox.alert({
						message: 'Cette nouvelle a été effacée'
					});
				}
		})
		$('#modalDel').modal('hide');
	})

	$('#listeAnnonces').on('click', '.btn-titleNews, #btn-eye', function(){
		var texteHTML = $(this).closest('li').data('texte');
		var titre = $(this).data('titre');
		$('#modalLecture .texteNews').html(texteHTML);
		$('#newsTitle').html(titre);
		$('#modalLecture').modal('show');
	})

})

</script>
