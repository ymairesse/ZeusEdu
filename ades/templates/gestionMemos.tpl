<div class="container-fluid">

<h2>Gestion des textes enregistrés</h2>

<div class="row">

	<div class="col-md-9 col-sm-12">
		{if $listeMemos == array()}
			<p class="avertissement">Rien à traiter...</p>
		{else}

			<ul class="nav nav-tabs">
				{foreach from=$listeMemos key=champ item=listeTextes name=boucle}
					<li {if $smarty.foreach.boucle.index == 0}class="active"{/if}>
						<a data-toggle="tab" href="#{$champ}">{$champ}</a>
					</li>
				{/foreach}
			</ul>

			<div class="tab-content">
				{foreach from=$listeMemos key=champ item=listeTextes name=boucle}
					<div id="{$champ}" class="tab-pane fade {if $smarty.foreach.boucle.index == 0}in active{/if}">
						<table class="table table-hover ">
						<tr>
							<th style="width:4em">Propriétaire</th>
							<th>Texte</th>
							<th style="width:2em">&nbsp;</th>
							<th style="width:2em">&nbsp;</th>
						</tr>
							{foreach from=$listeTextes key=id item=lesItems}
							<tr data-id="{$id}">
								<td>
									<span class="btn btn-sm {if $lesItems.free == 1}btn-info{else}btn-default{/if} btn-share"
									type="button"
									data-id="{$id}">
										{$lesItems.user}
									</span>
								</td>
								<td>
									<div class="input-group">
										<input type="text" class="form-control input-sm record"
											data-id="{$id}"
											value="{$lesItems.texte}"
											maxlength="150"
											{if $acronyme != $lesItems.user}disabled{/if}>
										<span class="input-group-btn">
											<button type="button" class="btn btn-success btn-sm oki" data-id="{$id}" title="Enregistrer">
											<i class="fa fa-save"></i>
											</button>
										</span>
									</div>

								</td>
								<td>
									{if $acronyme == $lesItems.user}
										<button type="button"
										class="btn btn-sm {if $lesItems.free == 1}btn-info{else}btn-default{/if} btn-share"
 										data-id="{$id}"
										title="Partager ce texte">
											<i class="fa fa-share"></i>
										</button>
									{/if}
								</td>
								<td>
									{if $acronyme == $lesItems.user}
										<button type="button" class="btn btn-danger btn-sm suppr" title="Effacer ce texte">
											<i class="fa fa-times"></i>
										</button>
									{/if}
								</td>
							</tr>
							{/foreach}
						</table>
					</div>
				{/foreach}
			</div>

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

	$('.oki').click(function(){
		var id = $(this).data('id');
		var texte = $('input:text[data-id="'+id+'"]').val();

		if (texte != '') {
		 	$.post("inc/saveTexte.inc.php", {
		 		'texte': texte,
				'id': id,
		 		 },
				function (resultat) {
					if (resultat == 1)
						bootbox.alert({
							title: 'Enregistrement',
							message: 'Enregistrement de <strong>'+texte+'</strong>'
						})
					}
				);
		 	}
		})

	$('.suppr').click(function(){
		var id = $(this).closest('tr').data('id');
		var texte = $('input:text[data-id="' + id +'"]').val();
		bootbox.confirm({
			title: 'Suppression',
			message: 'Veuillez confirmer l\'effacement du texte <br><strong>'+texte+'</strong>',
			callback: function(result){
				if (result == true) {
					$.post('inc/delTexte.inc.php', {
						'id': id
						},
						function () {
							$('tr[data-id="'+id+'"]').remove();
							}
						)
					}
				}
			})
		})

		$('.btn-share').click(function(){
			var id = $(this).closest('tr').data('id');
			$.post('inc/shareTexte.inc.php', {
				id: id
			}, function(resultat){
				if (resultat == 1)
					$('.btn-share[data-id="'+id+'"]').removeClass('btn-default').addClass('btn-info');
					else $('.btn-share[data-id="'+id+'"]').removeClass('btn-info').addClass('btn-default');
			})
		})

	})

</script>
