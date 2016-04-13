<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">

	{if $notification.type == 'cours'}
	<h2>Notification pour le cours {$notification.destinataire}</h2> {/if} {if $notification.type == 'classes'}
	<h2>Notification pour la classe {$notification.destinataire}</h2> {/if} {if $notification.type == 'niveau'}
	<h2>Notification pour tous les élèves de {$notification.destinataire}e</h2> {/if} {if $notification.type == 'ecole'}
	<h2>Notification pour tous les élèves</h2> {/if}

	<form enctype="multipart/form-data" name="notification" id="notification" method="POST" action="index.php" role="form" class="form-vertical">

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="enregistrer">
		<input type="hidden" name="id" value="{$notification.id}">
		<input type="hidden" name="destinataire" id="destinataire" value="{$notification.destinataire}">
		<input type="hidden" id="classe" name="classe" value="{$classe|default:''}">
		<input type="hidden" id="coursGrp" name="coursGrp" value="{$coursGrp|default:''}">
		<input type="hidden" id="niveau" name="niveau" value="{$niveau|default:''}">
		<input type="hidden" name="proprietaire" value="{$notification.proprietaire}">
		<input type="hidden" name="type" id="type" value="{$notification.type}">
		<input type="hidden" name="matricule" value="{$matricule|default:''}">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">

		<div class="row">

			{if ($notification.type == 'niveau') || ($notification.type == 'ecole')}
			<div class="col-md-10 col-sm-12">
				{else}
				<div class="col md-8 col-sm-8">
					{/if}
					<div class="panel panel-default">

						<div class="panel-heading">

							<div class="form-group">
								<label for="objet">Objet</label>
								<input type="text" maxlength="80" name="objet" id="objet" placeholder="Objet de votre note" class="form-control" value="{$notification.objet|default:''}">
							</div>

						</div>
						<!-- panel-heading -->

						<div class="panel-body">

							<textarea id="texte" name="texte" rows="25" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true">{$notification.texte|default:''}</textarea>

							{assign var=niveau value=$niveauUrgence|default:0} {assign var=texteNiveau value=['faible', 'moyen','urgent']}
							<div class="form-group">
								<label for="urgence">Urgence</label>
								<br>
								{foreach from=range(0,2) item=urgence}
								<label class="radio-inline urgence{$urgence}" style="width:30%">
									<input type="radio" name="urgence" class="form-control-inline" value="{$urgence}"
									{if isset($notification.urgence) && ($notification.urgence==$urgence)}checked{/if}>
									{$texteNiveau.$urgence}
								</label>
								{/foreach}
							</div>

							<div class="btn-group pull-right">
								<button type="reset" class="btn btn-default">Annuler</button>
								<button type="submit" class="btn btn-primary">Envoyer</button>
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
					{include file="notification/listeEleves.tpl"}
				</div>
				{/if}

				<div class="col-md-2 col-sm-12">

					{include file="notification/attributs.tpl"}

				</div>
				<!--col-md-... -->

			</div>
			<!-- row -->

	</form>

	</div>
	<!-- container -->


	<script type="text/javascript">

		$(document).ready(function() {

			$("#dateDebut").datepicker({
					format: "dd/mm/yyyy",
					clearBtn: true,
					language: "fr",
					calendarWeeks: true,
					autoclose: true,
					todayHighlight: true
				})
				.off('focus')
				.click(function() {
					$(this).datepicker('show');
				});

			$("#dateFin").datepicker({
				format: "dd/mm/yyyy",
				clearBtn: true,
				language: "fr",
				calendarWeeks: true,
				autoclose: true,
				todayHighlight: true
			});

			$("#notification").validate({
				rules: {
					'objet': 'required'
				}
			});

		})

	</script>
