<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

	<form name="mailing" id="mailing" class="form-vertical">

	<div class="row">

		<div class="col-md-3 col-xs-12 selectMail">

				{include file="destinataires.tpl"}

		</div>  <!-- col-md-... -->

		<div class="col-md-9 col-xs-12">

			<div class="panel panel-default">

				<div class="panel-header">
					<h3>Votre mail</h3>
				</div>

				<div class="panel-body">

					<div class="row">

						<div class="col-md-4 col-sm-12">
							<div class="form-group">
								<label for="expediteur">Expéditeur</label>
								{if $userStatus == 'direction' || $userStatus == 'admin'}
								{* permission de choisir le nom de l'expéditeur parmi les autres admins *}
									<select name="mailExpediteur" id="expediteur" class="form-control">
										<option value="{$NOREPLY}">{$NOMNOREPLY}</option>
										{foreach from=$listeDirection key=acro item=someone}
											<option value="{$someone.mail}"{if $acronyme == $acro} selected="selected"{/if}>{$someone.nom}</option>
										{/foreach}
									</select>
								{else}
									<input type="hidden" name="mailExpediteur" value="{$identite.mail}">
									<p class="form-control-static" style="font-weight:bold">{$identite.prenom} {$identite.nom}</p>
								{/if}
							</div>  <!-- form-group -->
						</div>

						<div class="col-md-4 col-sm-6 checkbox">
							<label><input type="checkbox" name="publier" id="publier" value="1"> Publier aux valves</label>
						</div>

						<div class="col-md-4 col-sm-6 form-group">
							<label for="fin">Effacé après le</label>
							<input type="text" name="fin" id="fin" class="datepicker form-control" value="" placeholder="Date de fin" disabled required>
						</div>

					</div>

					<div class="form-group">
						<span id="grouper" title="créer un groupe" style="display:none"><img src="images/groupe.png" alt="grouper"></span>
						<label>Destinataire(s):</label>
						<span class="form-control-static" id="destinataires"></span>
						<label for="mails[]" class="error" style="display:none">Veuillez sélectionner au moins un destinataire</label>
					</div>

					<div class="form-group" id="nomGroupe" style="display:none">
						<label for="groupe">Nom du groupe</label>
						<input type="text" id="groupe" name="groupe" placeholder="Nom du groupe" class="form-control">
						<div class="help-block">Choisissez un nom pour ce nouveau groupe de mailing</div>
					</div>

					<div class="row">
						<div class="form-group col-xs-9">
							<label for="objet" class="sr-only">Objet</label>
							<input type="text" name="objet" id="objet" placeholder="Objet de votre mail" class="form-control">
						</div>
						<div class="col-xs-3">
							<button class="btn btn-primary btn-block" type="button" id="btn-envoi">Envoyer</button>
						</div>
					</div>

					<div class="row">
						{include file="../../widgets/fileTree/templates/treeview4PJ.tpl"}
					</div>

					<div class="form-group">
						<label for="texte">Votre message</label>
						<textarea id="texte" name="texte" rows="15" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true"></textarea>
					</div>

						<label class="pull-right">Ajout de disclaimer
							<input type="checkbox" name="disclaimer" id='disclaimer' value="1" checked>
						</label>
					<div class="clearfix"></div>

					<input type="hidden" id="nomExpediteur" name="nomExpediteur" value="{$identite.prenom} {$identite.nom}">
					<input type="hidden" name="submitted" id="submitted" value="">

				</div>  <!-- panel-body -->

			</div>  <!-- panel -->

		</div>  <!-- col-md-... -->

		</div>  <!-- row -->

	</form>

</div>  <!-- container -->


<script type="text/javascript">

$(document).ready(function(){

	$('#mailing').validate({
		ignore: [],
		rules: {
			objet: {
				required: true
			},
			fin: {
				required: "#publier:checked"
			},
			"mails[]": {
				required: true,
				minlength: 1,
			},
			texte: {
				required: function() {
					CKEDITOR.instances.texte.updateElement();
					}
			}
		}
	})

	$('#btn-envoi').click(function(){
		if ($('#mailing').valid() && $('#submitted').val() == '') {
			var formulaire = $('#mailing').serialize();
			$.post('inc/sendMail.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#submitted').val('submitted');
				$('#btn-envoi').text('Mail envoyé').attr('disabled', true);
				// $('#btn-addPJ').attr('disabled', true);
				$('input:checkbox, input:text, textarea, select').attr('disabled', true);
				CKEDITOR.instances['texte'].setReadOnly(true);
				bootbox.alert({
					title: "Envoi de message",
					message: resultat
				});
			})
		}
	})

	$('#publier').change(function(){
		if ($('#publier').is(':checked'))
			$('#fin').attr('disabled', false);
			else $('#fin').attr('disabled', true).val('');
	})

	$('.datepicker').datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$(".teteListe").click(function(){
		if ($(this).parent().next().hasClass('listeMails'))
			$(this).parent().next().toggle();
			else alert("Cette liste est vide");
		})

	$(".checkListe").click(function(event){
		event.stopPropagation();  // ne pas ouvrir ou fermer la liste en plus de cocher les éléments
		$(this).parent().next().find('.selecteur').trigger('click');
		})

	$(".labelpj").hide();
	$("#pj0").show();

	// $(".pj").change(function(){
	// 	if ($(this).val() != '') {
	// 		var numero = eval($(this).attr('id').substr(3,1))+1;
	// 		$("#pj"+numero).fadeIn('slow');
	// 		}
	// 	})

	$("#expediteur").change(function(){
		var expediteur = $("#expediteur option:selected").text();
		$("#nomExpediteur").val(expediteur);;
		})

	$("#mailing").submit(function(){
		var okObjet = true; var okMail = true; var okTexte = true;
		var message = '';
		if ($("#objet").val() == '') {
			okObjet = false;
			message = 'Votre message n\'a pas d\'objet.\n';
			}
		if ($("#destinataires").text() == '') {
			okMail = false;
			message += 'Veuillez sélectionner au moins une adresse mail.\n';
			}
		value = CKEDITOR.instances['texte'].getData();
		if (value.trim() == '') {
			okTexte = false;
			message += 'Votre mail est vide.';
			}

		if (okObjet && okMail && okTexte) {
			$("#wait").show();
			return true
			}
			else {
				alert(message);
				return false;
				}
			});

	$(".selecteur").click(function(){
		var nb = $(".selecteur:input:checked").length;
		if (nb > 0) $("#grouper").show();
			else $("#grouper").hide();
		if (nb < 4) {
			var checkedValues = $('.selecteur:input:checkbox:checked').map(function() {
				destinataire = this.value.split('#');
				return destinataire[0];
			}).get();
			$("#destinataires").text(checkedValues);
			}
			else $("#destinataires").text(nb+" destinataires");
		})

	$(".labelProf").click(function(){
		$(this).prev().trigger('click');
		})

	$("#grouper").click(function(){
		var listeMails = $(".mails:input:checkbox:checked");
		$("#nomGroupe").fadeIn(1000);
		$("#groupe").focus();
		})

	})

</script>
