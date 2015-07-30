<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

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

<form enctype="multipart/form-data" name="notification" id="notification" method="POST" action="index.php" role="form" class="form-vertical">

	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="id" value="{$notification.id}">
	<input type="hidden" name="destinataire" value="{$notification.destinataire}">
	<input type="hidden" name="proprietaire" value="{$notification.proprietaire}">
	<input type="hidden" name="type" value="{$notification.type}">
	<input type="hidden" name="matricule" value="{$matricule|default:''}">
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<div class="panel panel-default">

				<div class="panel-heading">

					<div class="form-group">
						<label for="objet">Objet</label>
						<input type="text" maxlength="80" name="objet" id="objet" placeholder="Objet de votre note" class="form-control" value="{$notification.objet|default:''}">
					</div>

				</div>  <!-- panel-heading -->

				<div class="panel-body">

					<textarea id="texte" name="texte" rows="25" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true">{$notification.texte|default:''}</textarea>

				</div> <!-- panel-body -->

			</div>  <!-- panel -->

		</div>  <!-- col-md-...  -->

		<div class="col-md-3 col-sm-12">
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

			<div class="row panel panel-default">

				<div class="panel-heading">

					<h4 class="panel-title">Attributs de la publication</h4>

				</div>  <!-- pânel-heading.. -->

				<div class="panel-body">

					{assign var=niveau value=$niveauUrgence|default:0}
					<div class="form-group">
						<label for="urgence">Urgence</label><br>
						{foreach from=range(0,2) item=urgence}
							<label class="radio-inline urgence{$urgence}"><input type="radio" name="urgence" class="form-control-inline" value="{$urgence}"
							{if isset($notification.urgence) && ($notification.urgence == $urgence)}checked{/if}>Niv. {$urgence}</label>
						{/foreach}
						<p class="help-block">0 = faible 1 = moyen 2 = urgent</p>
					</div>

					<div class="form-group">
						<label for="dateDebut">Date de début</label>
						<input type="text" maxlength="10" name="dateDebut" id="dateDebut" placeholder="Début" class="datepicker" value="{$notification.dateDebut}">
					</div>

					<div class="form-group">
						<label for="dateFin">Date de fin</label>
						<input type="text" name="dateFin" id="dateFin" placeholder="Fin" class="datepicker" value="{$notification.dateFin}">
					</div>

					<div class="form-group">
						<label for="mail" {if isset($edition)}title="Non disponible en modification"{/if}>Envoi d'un mail</label>
						<input type="checkbox" name="mail" id="mail" class="form-control-inline" value="1"{if isset($notification.mail) && $notification.mail == 1} checked{/if}
						{if $notification.type == 'ecole' || isset($edition)} disabled{/if}>
						{* disabled pour l'envoi de mail à toute l'école afin d'éviter les over quota d'envois *}
						{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
					</div>

					<div class="form-group">
						<label for="accuse" {if isset($edition)}title="Non disponible en modification"{/if}>Accusé de lecture</label>
						<input type="checkbox" name="accuse" id="accuse" class="form-control-inline" value="1"{if isset($notification.accuse) && $notification.accuse == 1} checked{/if}
						{if $notification.type == 'ecole' || isset($edition)} disabled{/if}>
						{* disabled pour toute l'école car ingérable *}
						{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
					</div>

					<div class="btn-group pull-right">
						<a href="index.php?action=admin&amp;mode=edition" type="button" class="btn btn-default">Annuler</a>
						<button class="btn btn-primary" type="Submit" name="submit">Envoyer</button>
					</div>

				</div>  <!-- panel-body -->

			</div>  <!-- panel-info -->

		</div>  <!--col-md-... -->

	</div>  <!-- row -->

</form>


</div>  <!-- container -->


<script type="text/javascript">

	$( "#dateDebut").datepicker({
	format: "dd/mm/yyyy",
	clearBtn: true,
	language: "fr",
	calendarWeeks: true,
	autoclose: true,
	todayHighlight: true
	})
	.off('focus')
	.click(function () {
		  $(this).datepicker('show');
	  });

$( "#dateFin").datepicker({
	format: "dd/mm/yyyy",
	clearBtn: true,
	language: "fr",
	calendarWeeks: true,
	autoclose: true,
	todayHighlight: true
	});

</script>
