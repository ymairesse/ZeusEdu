<div class="row">

	<div class="col-md-10 col-sm-10">

		<div class="row">

			<div class="col-md-4 col-sm-12">

				<div class="panel panel-default">
					<div class="panel-heading">
					<p class="panel-title">Personne responsable</hp>
					</div>
					<div class="panel-body">
					  <dl>
						  <dt>Responsable</dt>
							  <dd>{$eleve.nomResp}</dd>
						  <dt>e-mail</dt>
							  <dd><a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></dd>
						  <dt>Téléphone</dt>
							  <dd>{$eleve.telephone1}</dd>
						  <dt>GSM</dt>
							  <dd>{$eleve.telephone2}</dd>
						  <dt>Téléphone bis</dt>
							  <dd>{$eleve.telephone3}</dd>
						  <dt>Adresse</dt>
							  <dd>{$eleve.adresseResp}</dd>
						  <dt>Code Postal</dt>
							  <dd>{$eleve.cpostResp}
						  <dt>Commune</dt>
							  <dd>{$eleve.localiteResp}</dd>
					  </dl>
					</div>
				</div>
			</div>  <!-- col-md-... -->


			<div class="col-md-4 col-sm-12">

				<div class="panel panel-default">
					<div class="panel-heading">
						<p class="panel-title">Père de l'élève</p>
					</div>
					<div class="panel-body">
					  <dl style="list-unstyled">
						  <dt>Nom</dt>
							  <dd>{$eleve.nomPere}</dd>
						  <dt>e-mail</dt>
							  <dd><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></dd>
						  <dt>Téléphone</dt>
							  <dd>{$eleve.telPere|default:''}</dd>
						  <dt>GSM</dt>
							  <dd>{$eleve.gsmPere}</dd>
					  </dl>
					</div>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-12">

				<div class="panel panel-default">
					<div class="panel-heading">
						<p class="panel-title">Mère de l'élève</p>
					</div>
					<div class="panel-body">
						<dl>
							<dt>Nom</dt>
								<dd>{$eleve.nomMere}</dd>
							<dt>e-mail</dt>
								<dd><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></dd>
							<dt>Téléphone</dt>
								<dd>{$eleve.telMere|default:''}</dd>
							<dt>GSM</dt>
								<dd>{$eleve.gsmMere}</dd>
						</dl>
					</div>
				</div>

			</div> <!-- col-md-... -->

		</div>  <!-- row -->

	</div>  <!-- col-md- .... -->

	<div class="col-md-2 col-sm-2 hidden-print">

		<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="draggable photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

	</div>  <!-- col-md... -->

</div>  <!-- row -->
