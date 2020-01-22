<div class="container">

	<h2>Liste des partages</h2>

	<div class="row">

		<div class="col-md-9 col-sm-10">

			<h3>{if (isset($coursGrp))}
				{$listeCours.$coursGrp.nomCours|default:''} - [{$coursGrp}] {$listeCours.$coursGrp.statut} {$listeCours.$coursGrp.libelle} {$listeCours.$coursGrp.nbheures}h
			{/if}
			{if isset($classe)}
				Classe: {$classe}
			{/if}
			</h3>

			<table class="table table-hover table-condensed">
			<tr>
				<th style="width:30em" title="{$matricule}">Nom</th>
				<th>Partages</th>
			</tr>
			{foreach from=$listeEleves key=matricule item=eleve}
			<tr>
				<td>{$eleve.classe} {$eleve.nom} {$eleve.prenom}</td>
				<td>
					{if isset($listePartages[$matricule])}
						{assign var=lesPartages value=$listePartages[$matricule]}
						{foreach from=$lesPartages key=guest item=data}
							<button class="btn btn-default btn-xs {$data.mode} btn-partage"
							 	data-matricule="{$matricule}"
								data-guest="{$guest}"
								data-id="{$data.id}"
								title="{$listeProfs.$guest.prenom|default:''} {$listeProfs.$guest.nom|default:''}">
								{$guest}
							</button>
						{/foreach}
					{else}
					&nbsp;
					{/if}
				 </td>
			</tr>
			{/foreach}

			</table>
		</div>  <!-- col-md... -->


		<div class="col-md-3 col-sm-2">

		<h4>Légende</h4>
		<table class="table table-condensed">
			<tr>
			<td style="width:30em;" class="r">Lecture seule (pas de modification)</td>
			<td style="width:30em" class="rw">Lecture et écriture (modifications autorisées</td>
			</tr>
		</table>

		</div>  <!-- col-md-4 -->

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){

		$('.btn-partage').click(function(){
			var matricule = $(this).data('matricule');
			var id = $(this).data('id');
			var guest = $(this).data('guest');
			var bouton = $(this);
			bootbox.confirm({
                title: 'Confirmation',
                message: '<i class="fa fa-exclamation-triangle fa-2x" style="color:red"></i> Fin du partage avec "<strong>' + guest + '</strong>"?',
                callback: function(result){
                    if (result == true) {
						$.post('inc/endSharePad.inc.php', {
							matricule: matricule,
							guest: guest,
							id: id
						}, function(resultat){
							if (resultat > 0)
								bouton.remove();
						})
					}
				}
			})
		})

	})

</script>
