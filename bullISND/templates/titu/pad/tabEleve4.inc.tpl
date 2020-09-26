<div class="row">

	<div class="col-md-4 col-sm-12">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Personne responsable</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Responsable</dt>
					<dd>{$eleve.nomResp}</dd>
					<dt>e-mail</dt>
					<dd><a href="mailto:{$eleve.courriel}">{$eleve.courriel}</a></dd>
					<dt>Téléphone</dt>
					<dd>{$eleve.telephone1|default:'-'}</dd>
					<dt>GSM</dt>
					<dd>{$eleve.telephone2|default:'-'}</dd>
					<dt>Téléphone bis</dt>
					<dd>{$eleve.telephone3|default:'-'}</dd>
					<dt>Adresse</dt>
					<dd>{$eleve.adresseResp}</dd>
					<dt>Code Postal</dt>
					<dd>{$eleve.cpostResp}</dd>
					<dt>Commune</dt>
					<dd>{$eleve.localiteResp}</dd>
				</dl>
			</div>

		</div>

	</div>
	<!-- col-md-4 -->

	<div class="col-md-4 col-sm-12">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Père de l'élève</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt>
					<dd>{$eleve.nomPere}</dd>
					<dt>e-mail</dt>
					<dd><a href="mailto:{$eleve.mailPere}">{$eleve.mailPere|default:'-'}</a></dd>
					<dt>Téléphone</dt>
					<dd>{$eleve.telPere|default:'-'}</dd>
					<dt>GSM</dt>
					<dd>{$eleve.gsmPere|default:'-'}</dd>
				</dl>
			</div>

		</div>

	</div>
	<!-- col-md-4 -->

	<div class="col-md-4 col-sm-12">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Mère de l'élève</h3>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt>
					<dd>{$eleve.nomMere}</dd>
					<dt>e-mail</dt>
					<dd><a href="mailto:{$eleve.mailMere}">{$eleve.mailMere|default:'-'}</a></dd>
					<dt>Téléphone</dt>
					<dd>{$eleve.telMere|default:'-'}</dd>
					<dt>GSM</dt>
					<dd>{$eleve.gsmMere|default:'-'}</dd>
				</dl>
			</div>

		</div>

	</div>
	<!-- col-md-4 -->

</div>
<!-- row -->
