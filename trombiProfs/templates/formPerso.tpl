<div class="container">

	<div class="row">

		<div class="col-md-10 col-sm-10">

	    <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
			<li class="active"><a href="#tabs-1" data-toggle="tab">Informations personnelles</a></li>
			<li><a href="#tabs-2" data-toggle="tab">Informations professionnelles</a></li>
	    </ul>

		<div id="my-tab-content" class="tab-content">

		    <div class="tab-pane active" id="tabs-1">

				<h3>Informations Personnelles</h3>

				<div class="row">

					<div class="col-md-4 col-sm-12">
						<div class="panel panel-default">
							<div class="panel-head">
								<h3>Informations générales</h3>
							</div>
							<div class="panel-body">
								<dl>
								<dt>Abréviation: </dt>
									<dd>{$prof.acronyme}</dd>
								<dt>Nom: </dt>
									<dd>{$prof.nom}</dd>
								<dt>Prénom: </dt>
									<dd>{$prof.prenom}</dd>
								</dl>
							</div>
						</div>
					</div>

					<div class="col-md-4 col-sm-12">
						<div class="panel panel-default">
							<div class="panel-head">
								<h3>Contacts</h3>
							</div>
							<div class="panel-body">
								<dl>
								<dt>Mail: </dt>
									<dd><a href="mailto:{$prof.mail}">{$prof.mail|default:'--'}</a></dd>
								<dt>Téléphone: </dt>
									<dd>{$prof.telephone|default:'--'}</dd>
								<dt>GSM: </dt>
									<dd>{$prof.GSM|default:'--'}</dd>
								</dl>
							</div>
						</div>
					</div>


					<div class="col-md-4 col-sm-12">
						<div class="panel panel-default">
							<div class="panel-head">
								<h3>Adresse</h3>
							</div>
							<div class="panel-body">
								<dl>
									<dt>Adresse:</dt>
										<dd>{$prof.adresse|default:'--'}</dd>
									<dt>Code postal:</dt>
										<dd>{$prof.codePostal|default:'--'}</dd>
									<dt>Commune:</dt>
										<dd>{$prof.commune|default:'--'}</dd>
									<dt>Pays:</dt>
										<dd>{$prof.pays|default:'--'}</dd>
								</dl>
							</div>
						</div>
					</div>

				</div>  <!-- row -->

			</div>  <!-- tabs-1 -->

			<div class="tab-pane" id="tabs-2">
					<div class="panel panel-default">
						<div class="panel-head">
							<h3>Informations Professionnelles</h3>
						</div>
						<div class="panel-body">
							<p><label for="titulaire">Titulaire de: </label><strong>{", "|implode:$titulaire|default:'-'}</strong></p>

							<div class="table-responsive">
								<table class="table table-striped tableauAdmin">
									<tr>
										<th>Année</th>
										<th>Nom du cours</th>
										<th>Statut</th>
										<th>Nombre d'heures</th>
										<th>Abréviation</th>
									</tr>
								{foreach from=$cours item=unCours}
									<tr>
										<td>{$unCours.annee}e</td>
										<td>{$unCours.libelle}</td>
										<td>{$unCours.statut}</td>
										<td>{$unCours.nbheures}h</td>
										<td>{$unCours.coursGrp}</td>
									</tr>
								{/foreach}
								</table>
						</div>
						</div>
					</div>
			</div>  <!-- tabs-2 -->


		</div>  <!-- my-tab-... -->

		</div>  <!-- col-md... -->

		<div class="col-md-2 col-sm-2">

			{if isset($photo)}
				<img src="../photosProfs/{$photo}" class="photo img-responsive" title="{$prof.prenom} {$prof.nom}">
				{else}
					{if $prof.sexe == 'M'}
					<img src="../images/profMasculin.png" class="photo img-responsive" title="{$prof.prenom} n'a pas (encore) souhaité envoyer sa photo" alt"photo">
						{else}
						<img src="../images/profFeminin.png"  class="photo img-responsive" title="{$prof.prenom} n'a pas (encore) souhaité envoyer sa photo" alt"photo">
					{/if}
			{/if}

		</div>  <!-- col-md... -->


	</div> <!-- row -->

</div>  <!-- container -->
