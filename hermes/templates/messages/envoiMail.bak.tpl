<div id="mail" class="tab-pane fade">

    <form name="mailing" id="mailing" class="form-vertical">

        <div class="row">

            <div class="col-md-3 col-xs-12 selectMail">

                {include file="destinataires.tpl"}

            </div>
            <!-- col-md-... -->

            <div class="col-md-9 col-xs-12">

                <div class="panel panel-default">

                    <div class="panel-header">
                        <h3>Votre mail</h3>
                    </div>

                    <div class="panel-body">

                        <div class="row">
                            <div class="col-md-4 col-sm-12">
                                <div class="form-group">
                                    <label for="expediteur">Expéditeur</label> {if $userStatus == 'direction' || $userStatus == 'admin'}
                                    <select name="mailExpediteur" id="expediteur" class="form-control">
                                    <option value="{$NOREPLY}">{$NOMNOREPLY}</option>
                                    {foreach from=$listeDirection key=acro item=someone}
                                        <option value="{$someone.mail}"{if $acronyme == $acro} selected="selected"{/if}>{$someone.nom}</option>
                                    {/foreach}
                                </select> {else}
                                    <input type="hidden" name="mailExpediteur" value="{$identite.mail}">
                                    <p class="form-control-static" style="font-weight:bold">{$identite.prenom} {$identite.nom}</p>
                                    {/if}
                                </div>
                                <!-- form-group -->
                            </div>

                            <div class="col-md-2 col-sm-3 checkbox">
                                <label><input type="checkbox" name="publier" id="publier" value="1"> Épingler</label>
                            </div>

                            <div class="col-md-3 col-sm-3 form-group">
                                <label for="fin">Effacé après le</label>
                                <input type="text" name="fin" id="fin" class="datepicker form-control" value="" placeholder="Date de fin" disabled required>
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <button type="button" class="btn btn-info btn-block" id="btn-addPJ"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i> Ajouter PJ</button>

                                <ul id="PjFiles" class="list-unstyled" style="max-height:5em; overflow:auto;">
                                </ul>
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

                    </div>
                    <!-- panel-body -->

                </div>
                <!-- panel -->

            </div>
            <!-- col-md-... -->

        </div>
        <!-- row -->

    </form>

</div>


<div id="modalTreeView" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalTreeViewLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalTreeViewLabel">Sélection des PJ</h4>
      </div>
      <div class="row modal-body">

		  <div class="col-xs-9" id="listeFichiers">
			  <div class="input-group">
				<div class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" id="root"><i class="fa fa-home"></i> </button>
				</div>
				<input type="text" name="arborescence" id="arborescence" value="/" class="form-control input-sm" readonly>
			  </div>

				<div style="max-height:25em; overflow: auto;">
					{include file='treeview4PJ.tpl'}
				</div>

		  </div>

		  <div class="col-xs-3">
			  <div class="dropzone" id="myDropZone" style="height:25em;">
			  </div>
		  </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

var nbFichiersMax = 5;
var maxFileSize = 25;

Dropzone.options.myDropZone = {
    maxFilesize: maxFileSize,
    maxFiles: nbFichiersMax,
    acceptedFiles: "image/jpeg,image/png,image/gif,application/pdf,.psd,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.odg,.csv,.txt,.pdf,.zip,.7z,.ggb,.mm,.xcf,.xmind,.rtf,bz2",
    url: "inc/upload.inc.php",
    queuecomplete: function() {
        // raffraichissement de la liste des fichiers
        var arborescence = $('#arborescence').val();
		var level;
		if (arborescence == '/')
			level = 0;
			else level = $('.activeDir').next('ul').data('level');
        $.post('inc/refreshFileList.inc.php', {
            arborescence: arborescence,
            level: level
        }, function(resultat){
			if (level > 0)
            	$('.activeDir').next('ul').replaceWith(resultat);
				else {
					$('.folder').last().nextAll('li').remove();
					$('.folder').last().after(resultat);
				}
        })
    },
    accept: function(file, done) {
        done();
    },
    init: function() {
        this.on("maxfilesexceeded", function(file) {
                alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
            }),
            this.on("sending", function(file, xhr, formData) {
                formData.append("arborescence", $("#arborescence").val());
            }),
            this.on('queuecomplete', function() {
                var dz = this;
                setTimeout(function() {
                    dz.removeAllFiles();
                }, 3000);
            })
    }
};

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

	$('#listeFichiers').on('click', 'a.fileName', function(){
		$(this).prev('input:checkbox').click();
	})

	$('#root').click(function(){
		$('#modalTreeView li a').removeClass('activeDir');
		$('#arborescence').val('/');
	})

	$('#btn-envoi').click(function(){
		if ($('#mailing').valid() && $('#submitted').val() == '') {
			var formulaire = $('#mailing').serialize();
			$.post('inc/sendMail.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#submitted').val('submitted');
				$('#btn-envoi').text('Mail envoyé').attr('disabled', true);
				$('#btn-addPJ').attr('disabled', true);
				$('input:checkbox, input:text, textarea, select').attr('disabled', true);
				CKEDITOR.instances['texte'].setReadOnly(true);
				bootbox.alert({
					title: "Envoi de message",
					message: resultat
				});
			});

		}
	})

	$('#publier').change(function(){
		if ($('#publier').is(':checked'))
			$('#fin').attr('disabled', false);
			else $('#fin').attr('disabled', true).val('');
	})

	$('#btn-addPJ').click(function(){
		$('#modalTreeView').modal('show');
	})

	$("#modalTreeView").on('click', '.dirLink', function(event) {
		$(this).next('.filetree').toggle('slow');
		$(this).closest('li').toggleClass('expanded');
		$('.dirLink').removeClass('activeDir');
		$(this).addClass('activeDir');
		$('#arborescence').val($(this).data('dir'));
	})

	$('#modalTreeView').on('click', '.selectFile', function(){
		var fileName = $(this).closest('li').data('filename');
		var path = $(this).closest('li').data('path');

		if ($(this).prop('checked') == true) {
			$('#PjFiles').append('<li><a href="javascript:void(0)" class="delPJ" data-path="'+ path + '" data-filename="' + fileName + '"><i class="fa fa-times text-danger" title="Supprimer"></i></a> ' + fileName + '<input type="hidden" name="files[]" value="' + path + '|//|' + fileName + '"></li>');
		}
		else {
			$('#PjFiles').find('[data-path="' + path + '"][data-filename="' + fileName + '"]').parent().remove();
		}
	})

	$('body').on('click', '.delPJ', function(){
		var fileName = $(this).data('filename');
		var path = $(this).data('path');
		$('.file[data-path="' + path + '"][data-filename="' + fileName + '"]').find('input').prop('checked', false);
		$(this).parent().remove();
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

	$(".pj").change(function(){
		if ($(this).val() != '') {
			var numero = eval($(this).attr('id').substr(3,1))+1;
			$("#pj"+numero).fadeIn('slow');
			}
		})

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
