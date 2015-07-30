<div class="container">

	{if $notification.type == 'eleves'}
		<h2>Notification pour {$detailsEleve.prenom} {$detailsEleve.nom} [ {$detailsEleve.groupe} ]</h2>
	{/if}
	{if $notification.type == 'classes'}
		<h2>Notification pour la classe {$notification.destinataire}</h2>
	{/if}
	{if $notification.type == 'niveau'}
		<h2>Notification pour tous les élèves de {$notification.destinataire}e</h2>
	{/if}
	{if $notification.type == 'ecole'}
		<h2>Notification pour tous les élèves</h2>
	{/if}

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<form name="retour" method="POST" action="index.php" role="form" class="form-horizontal pull-right">
				<input type="hidden" name="onglet" value="{$onglet|default:0}">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="edition">
				<button type="submit" class="btn btn-primary">Retour</button>
			</form>

			<div class="panel panel-default">

				<div class="panel-heading">

					<h4>Objet: {$notification.objet}</h4>

				</div>  <!-- panel-heading -->

				<div class="panel-body">

					<h4>Notification</h4>
					<div class="champ">{$notification.texte}</div>

				</div>  <!-- panel-body -->

			</div>  <!--panel -->

		</div>  <!--col-md-... -->

		<div class="col-md-3 col-sm-12">

			<h4>Attributs de la publication</h4>
			<div class="champ">
			<p class="urgence{$notification.urgence}">Urgence: {$notification.urgence}</p>
			<p><span class="urgence0">0 = faible</span> <span class="urgence1">1 = moyen</span> <span class="urgence2">2=urgent</span></p>

			<p><strong>Date de début:</strong> {$notification.dateDebut}</p>
			<p><strong>Date de fin:</strong> {$notification.dateFin}</p>

			<p><strong>Mail(s) envoyé(s):</strong> <span class="badge">{$nbMails}</span></p>
			<p><strong>Accusé(s) de lecture:</strong> <span class="badge">{$nbAccuses}</span></p>
			</div>  <!-- champ -->
		</div>  <!--col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container -->
