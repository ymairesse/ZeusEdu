<div class="row">

	<div class="col-md-4 col-sm-12">

		<div class="panel panel-default">
			<div class="panel-heading">
			<h3 class="panel-title">Coordonnées de la personne responsable</h3>
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
				<h3 class="panel-title">Coordonnées du père de l'élève</h3>
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
				<h3 class="panel-title">Coordonnées de la mère de l'élève</h3>
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
