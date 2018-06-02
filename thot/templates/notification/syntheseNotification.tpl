<div class="container-fluid">

	{if $notification.type == 'cours'}
	<h2>Notification pour le cours {$notification.destinataire}</h2> {/if}
	{if $notification.type == 'classes'}
	<h2>Notification pour la classe {$notification.destinataire}</h2> {/if}
	{if $notification.type == 'niveau'}
	<h2>Notification pour tous les élèves de {$notification.destinataire}e</h2> {/if}
	{if $notification.type == 'ecole'}
	<h2>Notification pour tous les élèves</h2> {/if}

		<div class="row">

			<div class="col md-9 col-xs-8">

					<div class="panel panel-default">

						<div class="panel-heading">

							<div class="form-group">
								<label>Objet</label>
								<div id="objet">{$notification.objet|default:''}</div>
							</div>

						</div>
						<!-- panel-heading -->

						<div class="panel-body">

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
						            <label for="dateDebut">Date début</label>
						            <p class="form-control-static"  title="La notification apparaît à partir de cette date">{$notification.dateDebut}</p>
						        </div>
							</div>

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
	 					            <label for="dateFin">Date fin</label>
	 					            <p class="form-control-static" title="La notification disparaît à partir de cette date">{$notification.dateFin}</p>
	 					        </div>
							</div>

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
						            <p title="Un mail d'avertissement est envoyé">Envoi<br>mail
						            {if isset($notification.mail) && $notification.mail==1 } <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i> {/if}
						            </p>
						        </div>
							</div>

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
						            <p title="Un accusé de lecture est demandé">Accusé<br>lecture
						            {if isset($notification.accuse) && $notification.accuse==1 } <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i>{/if}
						            </p>
						        </div>
							</div>

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
									<p title="La notification n'est pas effacée après la date finale">Perma-<br>nent
									{if (isset($notification.freeze)) && ($notification.freeze==1 )} <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i> {/if}
									</p>
								</div>
							</div>

							<div class="form-group col-md-2 col-xs-4">
								<div class="form-group">
									<p title="Notification par mail aux parents (qui ont accepté ces envois)">Mail<br>parents
									{if (isset($notification.parents)) && ($notification.parents==1 )} <i class="fa fa-check-square-o fa-lg"></i>{else}<i class="fa fa-square-o fa-lg"></i> {/if}
									</p>
								</div>
							</div>

							<div class="clearfix">
							</div>

							<div style="min-height:10em;">
								<label>Votre texte</label>
								{$notification.texte|default:''}
							</div>

							{if (isset($notification.files))}
							<h4>Fichier(s) joint(s)</h4>
							{foreach $notification.files as $file}
								{$file|replace:'|//|':'/'|replace:'//':'/'}
							{/foreach}

							{/if}

						</div>
						<!-- panel-body -->

						<div class="panel-footer">
							<!-- vide -->
						</div>

				</div>
				<!-- panel -->

			</div>
				<!-- col-md-...  -->

			<div class="col-md-3 col-xs-4">
				{if ($notification.type != 'niveau') && ($notification.type != 'ecole')}
				<!-- le choix d'élèves en particulier n'est possible que pour les classes et les cours -->
					{include file="notification/syntheseListeEleves.tpl"}
					{else}
					<p class="notice">Il n'est pas possible de sélectionner certains élèves dans ce mode.</p>
				{/if}
			</div>
			<!--col-md-... -->

		</div>
		<!-- row -->

	</div>
	<!-- container -->
