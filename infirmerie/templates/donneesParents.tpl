<div class="row">

	<div class="col-md-4 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Coordonnées de la personne responsable</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Responsable</dt><dd>{$eleve.nomResp}</dd>
					<dt>e-mail</dt><dd><dd><a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></</dd>>
					<dt>Téléphone</dt><dd>{$eleve.telephone1}</dd>
					<dt>GSM</dt><dd>{$eleve.telephone2}</dd>
					<dt>Téléphone bis</dt><dd>{$eleve.telephone3}</dd>
					<dt>Adresse</dt><dd>{$eleve.adresseResp}</dd>
					<dt>Code Postal</dt><dd>{$eleve.cpostResp}
					<dt>Commune</dt><dd>{$eleve.localiteResp}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-3 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Coordonnées du père de l'élève</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt><dd>{$eleve.nomPere}</dd>
					<dt>e-mail</dt><dd><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere}</a></dd>
					<dt>Téléphone</dt><dd>{$eleve.telPere|default:''}</dd>
					<dt>GSM</dt><dd>{$eleve.gsmPere}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-3 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Coordonnées de la mère de l'élève</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt><dd>{$eleve.nomMere}</dd>
					<dt>e-mail</dt><dd><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere}</a></dd>
					<dt>Téléphone</dt><dd>{$eleve.telMere|default:''}</dd>
					<dt>GSM</dt><dd>{$eleve.gsmMere}</dd>
				</dl>
			</div>
		</div>
	</div>
	
	<div class="col-md-2 col-sm-6">
		
		<img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" class="draggable photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}" style="float:right">

	</div>

</div>  <!-- row -->