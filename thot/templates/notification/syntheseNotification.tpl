<div class="container">

	{if $notification.type == 'cours'}
	<h2>Notification pour le cours {$notification.destinataire}</h2> {/if}
	{if $notification.type == 'classes'}
	<h2>Notification pour la classe {$notification.destinataire}</h2> {/if}
	{if $notification.type == 'niveau'}
	<h2>Notification pour tous les élèves de {$notification.destinataire}e</h2> {/if}
	{if $notification.type == 'ecole'}
	<h2>Notification pour tous les élèves</h2> {/if}

		<div class="row">

			{if ($notification.type == 'niveau') || ($notification.type == 'ecole')}
			<div class="col-md-10 col-sm-12">
				{else}
				<div class="col md-8 col-sm-8">
					{/if}
					<div class="panel panel-default">

						<div class="panel-heading">

							<div class="form-group">
								<label>Objet</label>
								<div id="objet">{$notification.objet|default:''}</div>
							</div>

						</div>
						<!-- panel-heading -->

						<div class="panel-body">
							<div>
								<label>Votre texte</label>
								{$notification.texte|default:''}
							</div>

							<div class="form-group">
								<label for="urgence">Urgence</label>
								{assign var=texteNiveau value=['faible', 'moyen','urgent']}
								{assign var=urgence value=$notification.urgence}
								<p class="urgence{$urgence}" style="width:30%">Niveau d'urgence: {$texteNiveau.$urgence}</p>
							</div>

						</div>
						<!-- panel-body -->

					</div>
					<!-- panel -->

				</div>
				<!-- col-md-...  -->


				{if ($notification.type != 'niveau') && ($notification.type != 'ecole')}
				<!-- le choix d'élèves en particulier n'est possible que pour les classes et les cours -->
				<div class="col-md-2 col-sm-4">
					{include file="notification/syntheseListeEleves.tpl"}
				</div>
				{/if}

				<div class="col-md-2 col-sm-12">

					{include file="notification/syntheseAttributs.tpl"}

				</div>
				<!--col-md-... -->

			</div>
			<!-- row -->

	</div>
	<!-- container -->
