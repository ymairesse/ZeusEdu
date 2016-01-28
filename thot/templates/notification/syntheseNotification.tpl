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
					<div class="champ" style="min-height:15em">{$notification.texte}</div>

				</div>  <!-- panel-body -->

			</div>  <!--panel -->

		</div>  <!--col-md-... -->

		<div class="col-md-3 col-sm-12">

			<h4>Attributs de la publication</h4>

			{if $notification.type == 'eleves'}
				<img src="../photos/{$detailsEleve.photo}.jpg" alt="{$detailsEleve.matricule}" class="img-responsive img-thumbnail photo pull-right" style="width:50px">
			{/if}
			{if $notification.type == 'classes'}
				<span class="geant pull-right">{$notification.destinataire}</span>
			{/if}
			{if $notification.type == 'niveau'}
				<span class="geant pull-right">{$notification.destinataire}<sup>e</sup></span>
			{/if}
			{if $notification.type == 'ecole'}
				<span class="geant pull-right">Tous</span>
			{/if}

			<div class="champ">
			<p class="urgence{$notification.urgence}">Urgence: {$notification.urgence}</p>
			<p><span class="urgence0">0 = faible</span> <span class="urgence1">1 = moyen</span> <span class="urgence2">2=urgent</span></p>

			<p><strong>Date de début:</strong> {$notification.dateDebut}</p>
			<p><strong>Date de fin:</strong> {$notification.dateFin}</p>

			<p><strong>Envoi d'un mail:</strong> {if $notification.mail == 1} <i class="fa fa-envelope fa-lg text-success"></i>{else} <i class="fa fa-minus-circle fa-lg"></i> {/if} </p>

			<p><strong>Accusé de lecture:</strong> {if $notification.accuse == 1}<i class="fa fa-check fa-lg text-success"></i>{else} <i class="fa fa-minus-circle fa-lg"></i> {/if}</p>

			<p><strong>Permanent:</strong> {if $notification.freeze == 1} <i class="fa fa-thumb-tack text-success fa-lg"></i> {else} <i class="fa fa-minus-circle fa-lg"></i> {/if}</p>
			</div>  <!-- champ -->
		</div>  <!--col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container -->
