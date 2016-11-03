<div class="container">

	<div class="row">

		<div class="col-md-10 col-sm-12">

			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Voir et modifier les pondérations par périodes</h3>
				</div>
				<div class="panel-body">
					<h4>{$intituleCours.coursGrp} | {$intituleCours.nomCours} {$intituleCours.nbheures}h {$intituleCours.statut} ({$listeClasses})</h4>
					<div class="table-responsive">
						<table class="table table-condensed table-bordered">
							<thead>
								<tr>
									<th>&nbsp;</th>
									<th>&nbsp;</th>
									{section name=lesPeriodes start=1 loop=$nbPeriodes+1} {assign var=n value=$smarty.section.lesPeriodes.index-1}
									<th colspan="2">Pér. {$n+1}
										<br>{$periodes.$n}</th>
									{/section}
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tr>
								<th>&nbsp;</th>
								<th>Élève(s)</th>
								{section name=lesPeriodes start=1 loop=$nbPeriodes+1}
								<th style="width:4em">TJ</th>
								<th style="width:4em">Cert.</th>
								{/section}
								<th>&nbsp;</th>
							</tr>

							{assign var=listePonderations value=$ponderations.$coursGrp} {foreach from=$listePonderations key=matricule item=periodes}
							<tr>
								{if $matricule == 'all'}
								<td>
									<button type="button" class="btn btn-success btn-xs btnPlus hide" title="Modifier la pondération pour cet élève uniquement" data-coursgrp="{$coursGrp}" data-bulletin="{$bulletin}">
										<i class="fa fa-plus"></i>
									</button>
								</td>
								<td>
									<select name="matricule" class="listeEleves form-control">
										<option value="">Tous les élèves</option>
										{foreach from=$listeEleves key=leMatricule item=eleve}
										<option value="{$leMatricule}">{$eleve.nom} {$eleve.prenom} ({$eleve.classe})</option>
										{/foreach}
									</select>
								</td>
								{else}
								<td>
									<button type="button" class="btn btn-danger btn-xs btnMoins" title="Supprimer cette pondération particulière" data-coursgrp="{$coursGrp}" data-bulletin="{$bulletin}" data-matricule="{$matricule}">
										<i class="fa fa-minus"></i>
									</button>
								</td>
								<td>
									{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} ({$listeEleves.$matricule.classe})
								</td>
								{/if} {section name=lesPeriodes start=1 loop=$nbPeriodes+1} {assign var=noPeriode value=$smarty.section.lesPeriodes.index}
								<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.form|default:'&nbsp;'}</td>
								<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.cert|default:'&nbsp;'}</td>
								{/section}
								<td class="cote">
									<button type="button"
									class="btn btn-sm btn-primary modPonderation"
									title="Modifier pour {if $matricule == 'all'}tous les élèves{else}cet élève{/if}" data-matricule="{$matricule}"
									data-coursgrp="{$coursGrp}"
									data-bulletin="{$bulletin}">
										<i class="fa fa-pencil"></i>
									</button>
								</td>
							</tr>
							{/foreach}
						</table>
					</div>
				</div>
				<div class="panel-footer">

				</div>
			</div>


		</div>
		<!-- col-md... -->

		<div class="col-md-2 col-sm-12">
			{include file="ponderation/noticeBaremes.html"}
		</div>
		<!-- col-md... -->

	</div>
	<!-- row -->

	{include file="ponderation/modal/modPonderation.tpl"}
	{include file="ponderation/modal/modalDelPonderation.tpl"}

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {

		$(document).ajaxStart(function() {
			$('body').addClass("wait");
		}).ajaxComplete(function() {
			$('body').removeClass("wait");
		});

		$(".listeEleves").change(function() {
			var matricule = $(this).val();
			if (matricule > 0)
				$(this).closest('tr').find('.btnPlus').removeClass('hide');
			else $(this).closest('tr').find('.btnPlus').addClass('hide');
		})

		$(".btnMoins").click(function() {
			var matricule = $(this).data('matricule');
			var coursGrp = $(this).data('coursgrp');
			// indiquer le destinataire dans la boîte modale
			$.post('inc/ponderation/destinataire.inc.php', {
					matricule: matricule
				},
				function(resultat) {
					$("#delDestinataire").html(resultat);
				});
			$.post('inc/ponderation/delPonderation.inc.php', {
				coursGrp: coursGrp,
				matricule: matricule
			}, function(resultat) {
				$("#delPonderation").html(resultat)
			});
			$("#modalDelPonderation").modal('show');
		})

		$(".btnPlus").click(function() {
			var matricule = $(this).closest('tr').find('select').val();
			var coursGrp = $(this).data('coursgrp');
			var bulletin = $(this).data('bulletin');
			// noter la valeur de l'input #matricule dans la boîte modale
			$("#matricule").val(matricule);
			// indiquer le destinataire dans la boîte modale
			$.post('inc/ponderation/destinataire.inc.php', {
					matricule: matricule
				},
				function(resultat) {
					$("#destinataire").html(resultat);
				});
			// noter les valeurs de pondérations dans le formulaire de la boîte modale
			$.post('inc/ponderation/addPonderation.inc.php', {
					matricule: matricule,
					coursGrp: coursGrp,
					bulletin: bulletin
				},
				function(resultat) {
					$("#formPonderations table tbody").html(resultat);
				});
			$("#modPonderation").modal('show');

		})

		$(".modPonderation").click(function() {
			var matricule = $(this).data('matricule');
			var coursGrp = $(this).data('coursgrp');
			var bulletin = $(this).data('bulletin');
			// noter la valeur de l'input #matricule dans la boîte modale
			$("#matricule").val(matricule);
			// indiquer le destinataire dans la boîte modale
			$.post('inc/ponderation/destinataire.inc.php', {
					matricule: matricule
				},
				function(resultat) {
					$("#destinataire").html(resultat);
				});
			// noter les valeurs de pondérations dans le formulaire de la boîte modale
			$.post('inc/ponderation/modPonderation.inc.php', {
					matricule: matricule,
					coursGrp: coursGrp,
					bulletin: bulletin
				},
				function(resultat) {
					$("#formPonderations table tbody").html(resultat);
				});
			$("#modPonderation").modal('show');
		})

	})
</script>
