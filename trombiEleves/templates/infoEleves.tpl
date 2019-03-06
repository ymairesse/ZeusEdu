<div class="container-fluid">

<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom}: {$eleve.groupe}</h2>

<div class="row">

	<div class="col-md-10 col-sm-9">

		<ul id="tabs" class="nav nav-pills" data-tabs="tabs">
			<li><a href="#tabs-0" data-toggle="tab" data-tab="0" class="tabulation">Coordonnées de l'élève</a></li>
			<li><a href="#tabs-1" data-toggle="tab" data-tab="1" class="tabulation">Responsable</a></li>
			<li><a href="#tabs-2" data-toggle="tab" data-tab="2" class="tabulation">Père</a></li>
			<li><a href="#tabs-3" data-toggle="tab" data-tab="3" class="tabulation">Mère</a></li>
			<li><a href="#tabs-4" data-toggle="tab" data-tab="4" class="tabulation">Cours</a></li>
			<li><a href="#tabs-5" data-toggle="tab" data-tab="5" class="tabulation">EDT</a> </li>
			<li><a href="#tabs-6" data-toggle="tab" data-tab="6" class="tabulation">EBS{if $eleveEBS|count > 0} <i class="fa fa-user-circle-o" style="color:#f00"></i>{/if}</a> </li>
		</ul>

		<div id="my-tab-content" class="tab-content">

			<div class="tab-pane active" id="tabs-0">

				<h3>Coordonnées de l'élève</h3>

				<div class="row">

					<div class="col-md-6 col-sm-12">

						<div class="panel panel-default">

							<div class="panel-body">

								<div class="input-group">
									<label>Classe</label>
									<p class="form-control-static">{$eleve.classe}</p>
									<div class="help-block">{if $eleve.classe != $eleve.groupe} - <small>{$eleve.groupe}{/if} [Titulaire(s): {", "|implode:$titulaires}]</small></div>
								</div>

								<div class="input-group">
									<label>Date de naissance</label>
									<p class="form-control-static">{$eleve.DateNaiss}</p>
									<div class="help-block"><small>[Âge approx. {$eleve.age.Y} ans
									{if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if}
									{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></div>
								</div>

								<div class="input-group">
									<label>Commune de naissance</label>
									<p class="form-control-static">{$eleve.commNaissance|default:'-'}</p>
								</div>

							</div>

						</div>

					</div>  <!-- col-md-... -->

					<div class="col-md-6 col-sm-12">

						<div class="panel panel-default">

							<div class="panel-body">

								<div class="input-group">
									<label>Adresse</label>
									<p class="form-control-static">{$eleve.adresseEleve}</p>
								</div>
								<div class="input-group">
									<label>Code Postal</label>
									<p class="form-control-static">{$eleve.cpostEleve}</p>
								</div>
								<div class="input-group">
									<label>Commune</label>
									<p class="form-control-static">{$eleve.localiteEleve}</p>
								</div>
								<div class="input-group">
									<label>Mail</label>
									<p class="form-control-static"><a href="mailto:{$eleve.user}@{$eleve.mailDomain}">{$eleve.user}@{$eleve.mailDomain}</a></p>
								</div>

							</div>

						</div>

					</div>  <!-- col-md-... -->

				</div>  <!-- row -->

			</div>  <!-- tabs-1 -->

			<div class="tab-pane" id="tabs-1">

				<h3>Coordonnées de la personne responsable</h3>

					<div class="row">

						<div class="col-md-6 col-sm-12">

							<div class="panel pane-default">

								<div class="panel-body">

									<div class="input-group">
										<label>Responsable</label>
										<p class="form-control-static">{$eleve.nomResp}</p>
									</div>
									<div class="input-group">
										<label>e-mail</label>
										<p class="form-control-static"><a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></p>
									</div>
									<div class="input-group">
										<label>Adresse</label>
										<p class="form-control-static">{$eleve.adresseResp}</p>
									</div>
									<div class="input-group">
										<label>Code Postal</label>
										<p class="form-control-static">{$eleve.cpostResp} {$eleve.localiteResp}</p>
									</div>

								</div>

							</div>

						</div>  <!-- col-md-... -->

						<div class="col-md-6 col-sm-12">

							<div class="panel panel-default">

								<div class="panel-body">

									<div class="input-group">
										<label>Téléphone</label>
										<p class="form-control-static">{$eleve.telephone1}</p>
									</div>
									<div class="input-group">
										<label>GSM</label>
										<p class="form-control-static">{$eleve.telephone2}</p>
									</div>
									<div class="input-group">
										<label>Téléphone bis</label>
										<p class="form-control-static">{$eleve.telephone3}</p>
									</div>

								</div>

							</div>

						</div>  <!-- col-md-... -->

					</div>  <!-- row -->
			</div>

			<div class="tab-pane" id="tabs-2">

				<h3>Coordonnées du père de l'élève</h3>

					<div class="row">

						<div class="col-md-6 col-sm-12">

							<div class="panel panel-default">

								<div class="panel-body">

									<div class="input-group">
										<label>Nom</label>
										<p class="form-control-static">{$eleve.nomPere}</p>
									</div>
									<div class="input-group">
										<label>e-mail</label>
										<p class="form-control-static"><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></p>
									</div>

								</div>

							</div>

						</div>  <!-- col-md-... -->

						<div class="col-md-6 col-sm-12">

							<div class="panel panel-default">
								<div class="panel-body">

									<div class="input-group">
										<label>Téléphone</label>
										<p class="form-control-static">{$eleve.telPere}</p>
									</div>
									<div class="input-group">
										<label>GSM</label>
										<p class="form-control-static">{$eleve.gsmPere}</p>
									</div>

								</div>

							</div>

						</div>  <!-- col-md- ... -->

					</div>  <!-- row -->

			</div>

			<div class="tab-pane" id="tabs-3">

				<h3>Coordonnées de la mère de l'élève</h3>

					<div class="row">

						<div class="col-md-6 col-sm-12">

							<div class="panel panel-default">
								<div class="panel-body">

									<div class="input-group">
										<label>Nom</label>
										<p class="form-control-static">{$eleve.nomMere}</p>
									</div>

									<div class="input-group">
										<label>e-mail</label>
										<p class="form-control-static"><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></p>
									</div>

								</div>

							</div>

						</div>  <!-- col-md-... -->

						<div class="col-md-6 col-sm-12">

							<div class="panel panel-default">
								<div class="panel-body">

									<div class="input-group">
										<label>Téléphone</label>
										<p class="form-control-static">{$eleve.telMere}</p>
									</div>
									<div class="input-group">
										<label>GSM</label>
										<p class="form-control-static">{$eleve.gsmMere}</p>
									</div>

								</div>

							</div>


						</div>  <!-- col-md-... -->

					</div>  <!-- row -->

			</div>

			<div class="tab-pane" id="tabs-4">

				<div class="panel panel-default">

					<div class="panel-body">
						<h3>Cours de l'élève</h3>

						<table class="table table-hover">
							<thead>
								<tr>
									<th>Cours</th>
									<th>Abréviation</th>
									<th>Nb heures</th>
									<th>Statut</th>
									<th>Professeurs</th>
								</tr>
							</thead>
							{foreach from=$listeCours key=coursGrp item=unCours}
							<tr>
								<td>{$unCours.libelle}</td>
								<td>{$unCours.coursGrp}</td>
								<td>{$unCours.nbheures}h</td>
								<td>{$unCours.statut}</td>
								<td>{$unCours.nom} {$unCours.prenom}
							</tr>
							{{/foreach}}

						</table>

					</div>

				</div>
			</div>

			<div class="tab-pane" id="tabs-5">

				<div class="panel panel-default">

					<div class="panel-body">

						{if isset($imageEDT) && ($imageEDT != '')}
							<img src="../edt/eleves/{$imageEDT}" alt="{$imageEDT}" class="img img-responsive">
							{else}
							<p>Image non disponible</p>
							{/if}

					</div>

				</div>
			</div>

			<div class="tab-pane" id="tabs-6">

				<div class="panel panel-default">

					<div class="panel-body">

						{include file="infoEBS.tpl"}

					</div>

				</div>
			</div>

		</div>

		</div>  <!-- col-md-... -->

		<div class="col-md-2 col-sm-3">

			<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" id="photo" style="width:150px;" class="img-responsive photoEleve">

		</div>

</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){

		var onglet = {$onglet};
		if (onglet == '')
			onglet = 0;
		$('.tabulation[data-tab="' + onglet +'"]').trigger('click');

		$('.tabulation').click(function(){
			var onglet = $(this).data('tab');
			$('#onglet').val(onglet);
		})
	})

</script>
