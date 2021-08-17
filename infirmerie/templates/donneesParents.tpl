<div class="row">

	<div class="col-md-4 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3>Personne responsable</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Responsable</dt><dd>{$dataEleve.nomResp}</dd>
					<dt>e-mail</dt><dd><a href="mailto:{$dataEleve.courriel}">{$dataEleve.courriel}</a></dd>
					<dt>Téléphone</dt><dd>{$dataEleve.telephone1}</dd>
					<dt>GSM</dt><dd>{$dataEleve.telephone2}</dd>
					<dt>Téléphone bis</dt><dd>{$dataEleve.telephone3}</dd>
					<dt>Adresse</dt><dd>{$dataEleve.adresseResp}</dd>
					<dt>Code Postal</dt><dd>{$dataEleve.cpostResp}
					<dt>Commune</dt><dd>{$dataEleve.localiteResp}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-3 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3>Père de l'élève</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt><dd>{$dataEleve.nomPere}</dd>
					<dt>e-mail</dt><dd><a href="mailto:{$dataEleve.mailPere}">{$dataEleve.mailPere}</a></dd>
					<dt>Téléphone</dt><dd>{$dataEleve.telPere|default:''}</dd>
					<dt>GSM</dt><dd>{$dataEleve.gsmPere}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-3 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3>Mère de l'élève</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt><dd>{$dataEleve.nomMere}</dd>
					<dt>e-mail</dt><dd><a href="mailto:{$dataEleve.mailMere}">{$dataEleve.mailMere}</a></dd>
					<dt>Téléphone</dt><dd>{$dataEleve.telMere|default:''}</dd>
					<dt>GSM</dt><dd>{$dataEleve.gsmMere}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-2 col-sm-6">

		<img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" class="draggable photo img-responsive thumbnail" title="{$dataEleve.prenom} {$dataEleve.nom}" style="float:right">

	</div>

</div>  <!-- row -->
