<div class="container-fluid">

<h2>Gestion des textes enregistrés</h2>

<div id="success"></div>

<div class="row">

	<div class="col-md-9 col-sm-12">
		{if $listeMemos == array()}
			<p class="avertissement">Rien à traiter...</p>
			{else}

				{foreach from=$listeMemos key=titre item=listeTextes}
					<table class="table table-hover ">
					<thead>
						<tr>
							<th colspan="3"><h3>{$titre}</h3></th>
						<tr>
					</thead>
					<tr>
						<th style="width:4em">Proprio</th>
						<th>Texte</th>
						<th style="width:2em">&nbsp</th>
					</tr>
						{foreach from=$listeTextes key=id item=lesItems}
						<tr>
							<td>{$lesItems.user}</td>
							<td>
								{if $acronyme == $lesItems.user}
								<form class="form-inline microForm" role="form">
									<div class="form-group">
										<label class="sr-only" for="texte_{$titre}_{$id}">Texte</label>
										<input type="text" class="form-control input-sm record" id="texte_{$titre}_{$id}" name="texte_{$titre}_{$id}" value="{$lesItems.texte}" maxlength="150" size="80"  title="Cliquer pour modifier">
									</div>

									<div class="form-group">
										<a href="#" class="btn btn-default oki" style="display: none"><span class="glyphicon glyphicon-floppy-disk" title="Enregistrer"></a>
									</div>

									<input type="hidden" name="id_{$titre}_{$id}" value="{$id}" class="id">
									<input type="hidden" name="user_{$lesItems.user}" value="{$lesItems.user}" class="user">
									<input type="hidden" name="champ_{$titre}_{$id}" value="{$titre}" class="champ">
								</form>
								{else}
								{$lesItems.texte}
								{/if}
							</td>
							<td class="delete" title="Effacer ce texte">
								{if $acronyme == $lesItems.user}
									<button type="button" class="btn btn-default btn-sm suppr"><span class="glyphicon glyphicon-remove" style="color:red; font-size:130%; cursor:pointer"></span></button>
									{else}
									&nbsp;
								{/if}
							</td>
						</tr>
						{/foreach}
					</table>
				{/foreach}

		{/if}
	</div>

	<div class="col-md-3 col-sm-12">
		<div class="notice">
			<p>Les textes automatiques sont enregistrés en même temps que l'on introduit un fait disciplinaire.</p>
			<p>Le présent utilitaire ne sert qu'à corriger des textes incorrects ou à les supprimer</p>

		</div>
	</div>

</div>



</div>


<script type="text/javascript">

	$(document).ready(function(){

	$(".record").click(function(){
		$(this).parent().next().find('.oki').fadeIn();
		})

	$(".oki").click(function(){
		var oki = $(this);
		var okiForm = $(this).closest('form');
		var texte = okiForm.find('input.record').val();
		var id= okiForm.find('input.id').val();
		var champ = okiForm.find('input.champ').val()
		var user = okiForm.find('input.user').val()

		if (texte != '') {
			$.post("inc/saveTexte.inc.php", {
				'texte': texte,
				 'qui': user,
				 'champ': champ,
				 'id': id,
				 'user': user
				 },
					function (resultat) {
						oki.fadeOut();
						$("#success").html(resultat);
						}
					);
			}
		})

	$(".suppr").click(function(){
		var sup = $(this);
		var id=$(this).parent().prev().find(".id").val();
		if (id != '' && confirm('Voulez-vous vraiment supprimer ce texte?')) {
			$.post('inc/delTexte.inc.php', {
				'id': id
				},
				function (resultat) {
					sup.parent().parent().remove();
					$("#success").html(resultat);
					}
				)
			}
		})

	})

</script>
