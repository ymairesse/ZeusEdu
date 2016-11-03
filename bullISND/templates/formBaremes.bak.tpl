<div class="container">

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<h2>Voir et modifier les pondérations</h2>
			Bulletin en cours: {$bulletin}
			<h3 title="{$intituleCours.coursGrp}">
				{$intituleCours.annee} : {$intituleCours.statut}
				{if $intituleCours.nomCours}  {$intituleCours.nomCours}
				{else} {$intituleCours.libelle}
				{/if}
				{$intituleCours.nbheures}h ({$listeClasses}) </h3> {if $matricule != 'all'}
			<strong>{$nomEleve.nom} {$nomEleve.prenom} {$nomEleve.classe}</strong> {else} Pondération pour tous les élèves {/if}

			<form name="formPonderations" method="POST" action="index.php" id="formPonderations" class="form-vertical" role="form">
				<table class="table table-condensed">
					<tr>
						<td style="width:10em">Période</td>
						<td>Formatif</td>
						<td>Certificatif</td>
					</tr>

					{section name=periodes start=1 loop=$nbPeriodes+1}
					{assign var=ponderation value=$ponderations.$coursGrp.$matricule}
					{assign var=n value=$smarty.section.periodes.index}
					<tr>
						<td>{$n}: <strong>{$periodes.{$n-1}}</strong></td>
						<td>
							<input type="text" class="poids form-control" value="{$ponderation.$n.form}" {if ($bulletin> $n)} disabled {/if} name="formatif_{$n}" maxlength="3">
						</td>
						<td>
							<input type="text" class="poids form-control" value="{$ponderation.$n.cert}" {if ($bulletin> $n)} disabled {/if} name="certif_{$n}" maxlength="3"
						</td>
					</tr>
					{/section}
				</table>
				<input type="hidden" name="coursGrp" value="{$coursGrp}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				<input type="hidden" name="etape" value="{$etape}">
				<div class="btn-group pull-right">
					<a class="btn btn-danger" type="button" href="index.php?action=gestionBaremes&amp;mode=voir&amp;coursGrp={$coursGrp}">Retour sans enregistrer</a>
					<button type="reset" class="btn btn-default">Annuler</button>
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</div>
				<div class="clearfix"></div>
			</form>

		</div>
		<!-- col-md... -->

		<div class="col-md-6 col-sm-12">

			{include file="ponderation/noticeBaremes.html"}

		</div>
		<!-- col-md... -->

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {

		$("input").tabEnter();
		$(".poids").each(function(index, value) {
			$(this).attr("tabIndex", index + 1)
		})

		$("#formPonderations").validate();

		$(".poids").each(function(item) {
			$(this).rules("add", {
				number: true,
				min: 0
			})
		})

		$(".readonly").html(" > Plus modifiable, bulletin distribué");

		$("#formPonderations").submit(function() {
			if ($("#formPonderations").valid()) {
				$.blockUI();
				$("#wait").show();
			} else alert("Veuillez corriger les données");
		})

	});
</script>
