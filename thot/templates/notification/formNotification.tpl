<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container-fluid">

		<input type="hidden" name="id" id="id" value="{$notification.id}">
		<input type="hidden" name="destinataire" id="destinataire" value="{$destinataire|default:''}">
		<input type="hidden" name="matricule" id="matricule" value="{$notification.matricule|default:''}">
		<input type="hidden" name="leType" id="leType" value="{$type|default:''}">

		<div class="panel panel-default hidden" id="editorPanel">

			<div class="panel-body">

				<div class="row">
					<div class="col-xs-8">
						<input type="text" maxlength="80" name="objet" id="objet" placeholder="Objet de votre annonce" class="form-control" value="{$notification.objet|default:''}">
					</div>
					<div class="col-xs-4">
						<div class="btn-group btn-group-justified">
							<div class="btn-group">
								<button type="button" class="btn btn-primary" id="submitNotif"><i class="fa fa-paper-plane"></i> Envoyer</button>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-default" id="reset"><i class="fa fa-refresh"></i> Annuler</button>
							</div>
						</div>
					</div>
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="dateDebut">Date début</label>
					<input type="text" name="dateDebut" id="dateDebut" placeholder="Début" class="datepicker form-control" value="{$notification.dateDebut}" title="La notification apparaît à partir de cette date">
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="dateFin">Date fin</label>
					<input type="text" name="dateFin" id="dateFin" placeholder="Fin" class="datepicker form-control" value="{$notification.dateFin}" title="La notification disparaît à partir de cette date">
					<div class="help-block">Déf:+1mois</div>
				</div>
				<div class="form-group col-md-2 col-xs-4">
					<label for="mail" title="Un mail d'avertissement est envoyé">Envoi<br>mail</label>
					<input type="checkbox" name="mail" id="mail" class="form-control-inline cb" value="1"
					{if isset($notification.mail) && $notification.mail==1 } checked='checked' {/if}
					{if isset($edition)} disabled{/if}>
					{* disabled pour l'envoi de mail à toute l'école ou à tout un niveau afin d'éviter les overquotas d'envois *}
					{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="accuse" title="Un accusé de lecture est demandé">Accusé<br>lecture</label>
					<input type="checkbox" name="accuse" id="accuse" class="form-control-inline cb" value="1"
					{if isset($notification.accuse) && $notification.accuse==1 } checked='checked' {/if}
					 {if isset($edition)} disabled{/if}>
					{* disabled pour toute l'école car ingérable *}
					{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				<div class="form-group col-md-2 col-xs-4">
		            <label for="freeze" title="Notification permanente, n'est pas effacée après la date finale">Perma-<br>nent</label>
		            <input type="checkbox" name="freeze" id="freeze" class="form-control-inline cb" value="1"
		            {if (isset($notification.freeze)) && ($notification.freeze==1 )} checked{/if}
					{if isset($edition)} disabled{/if}>
		        </div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="parents" title="Notification par mail aux parents (qui ont accepté ces envois)">Mail<br>Parents</label>
					<input type="checkbox" name="parent" id="parent" class="form-control-inline cb" value="1"
					{if (isset($notification.parents)) && ($notification.parents==1 )} checked{/if}
					 {if isset($edition)} disabled{/if}>
				</div>

				<div class="clearfix">
				</div>

				{* emplacement du textarea -> CKEDITOR *}
				<textarea id="texte" name="texte" rows="25" class="ckeditor form-control hidden" placeholder="Frappez votre texte ici" autofocus="true" required>{$notification.texte|default:''}</textarea>
				{* emplacement du textarea -> CKEDITOR *}

				{include file="../../../widgets/fileTree/templates/treeview4PJ.tpl"}

			</div>
			<!-- panel-body -->

			<div class="panel-footer">
				{if $notification.type == 'niveau' || $notification.type == 'ecole'}
		            <p>L'envoi de mails est désactivé pour les notifications à tout un niveau ou à toute l'école</p>
		        {/if}
		        {if $notification.type == 'ecole'}
		            <p>La demande d'accusé de lecture est désactivée pour les notifications à l'ensemble de l'école</p>
		        {/if}
		        {if isset($edition)}
		            Certaines options ne sont pas modifiables
		        {/if}
			</div>

		</div>
		<!-- panel -->

	</div>
	<!-- container -->

<script type="text/javascript">

	$(document).ready(function() {

		CKEDITOR.replace('texte');

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
			// pour ne pas ignorer le "textarea" qui sera caché
			ignore: [],
			rules: {
				texte: {
					required: function(){
						CKEDITOR.instances['texte'].updateElement();
					},
					minlength: 20
				},
				objet: {
					required: true
					},
				dateDebut: {
					required: true,
					minlength: 10
					},
				dateFin: {
					required: true,
					minlength: 10
					},
				'membres[]': {
					required: true,
					minlength: 1
					},
				},
			messages: {
				'objet': 'Veuillez indiquer un objet pour votre annonce',
				'membres[]': 'Sélectionner au moins un élève',
				'texte': 'Un texte significatif svp',
				},
			errorPlacement: function(error, element) {
				if (element.hasClass('cb')){
					error.insertBefore(element.closest('ul'));
					}
					else {
						error.insertAfter(element);
					}
			}
		});

	})

</script>
