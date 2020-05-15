<div class="modal fade" id="modalSendRetenue" tabindex="-1" role="dialog" aria-labelledby="titleSendRetenue" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="formSendRetenue">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="titleSendRetenue">Envoi d'une retenue</h4>
                </div>
                <div class="modal-body">

                    <div id="listeParents"></div>

                    <textarea name="texteMail" id='texteMail' class="form-control">
                    {include file="retenues/texteRetenue.html"}
                    </textarea>
                    <strong class="pull-right">{if $identite.sexe == 'F'}Mme{else}M.{/if} {$identite.prenom|truncate:1:''}. {$identite.nom} - {$identite.titre}</strong>

                </div>
                <div class="modal-footer">
                    <input type="hidden" name="idFait" id="modalIdFait" value="">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default" id="btnReset">Annuler</button>
                        <button type="button" class="btn btn-primary" id="btnSendRetenue" disabled="disabled">Envoyer</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">

    function sendFile(file, el) {
    	var form_data = new FormData();
    	form_data.append('file', file);
    	$.ajax({
    		data: form_data,
    		type: "POST",
    		url: 'editor-upload.php',
    		cache: false,
    		contentType: false,
    		processData: false,
    		success: function(url) {
    			$(el).summernote('editor.insertImage', url);
    		}
    	});
    }

    function deleteFile(src) {
    	$.ajax({
    		data: { src : src },
    		type: "POST",
    		url: 'inc/deleteImage.inc.php',
    		cache: false,
    		success: function(resultat) {
    			console.log(resultat);
    			}
    	} );
    }

    $(document).ready(function() {

        $('#texteMail').summernote({
    		lang: 'fr-FR', // default: 'en-US'
    		height: null, // set editor height
    		minHeight: 150, // set minimum height of editor
    		focus: true, // set focus to editable area after initializing summernote
    		toolbar: [
    		  ['style', ['style']],
    		  ['font', ['bold', 'underline', 'clear']],
    		  ['font', ['strikethrough', 'superscript', 'subscript']],
    		  ['color', ['color']],
    		  ['para', ['ul', 'ol', 'paragraph']],
    		  ['table', ['table']],
    		  ['insert', ['link', 'picture', 'video']],
    		  ['view', ['fullscreen', 'codeview', 'help']],
    		],
    		maximumImageFileSize: 2097152,
    		dialogsInBody: true,
    		callbacks: {
    			onImageUpload: function(files, editor, welEditable) {
    				for (var i = files.length - 1; i >= 0; i--) {
    					sendFile(files[i], this);
    				}
    			},
    			onMediaDelete : function(target) {
    				deleteFile(target[0].src);
    			}
    		}
    	});

        $("#modalSendRetenue").on('click', '.sendTo', function() {
            if ($('.sendTo:checked').length > 0)
                $("#btnSendRetenue").attr('disabled', false);
            else $("#btnSendRetenue").attr('disabled', true);
        })

        $(".send-eDoc").click(function() {
            var idFait = $(this).data('idfait');
            var matricule = $(this).data('matricule');
            $.post('inc/docsSend/getMailsParents.inc.php', {
                    matricule: matricule
                },
                function(resultat) {
                    $("#listeParents").html(resultat);
                })
            $("#modalIdFait").val(idFait);
            $("#btnSendRetenue").attr('disabled', true);
            $("#modalSendRetenue").modal('show');
        })

        $("#btnSendRetenue").click(function() {
            var formulaire = $('#formSendRetenue').serialize();
            // création du document dans le répoertoire de l'utilisateur actif
            $.post('inc/retenues/printRetenue.inc.php', {
                    formulaire: formulaire
                },
                function(fileName) {
                    // et maintenant, on envoie le document en PJ
                    $.post('inc/retenues/sendDocument.inc.php', {
                        formulaire: formulaire,
                        fileName: fileName
                        },
                        function(resultat) {
                            var title= "Envoi de mail";
                            if (resultat == 1) {
                                var message = "Mail(s) envoyé(s)"
                            } else {
                                var message = "Le mail n'a pas pu être envoyé"
                            }
                            bootbox.alert({
                                title: title,
                                message: message
                            })
                        });
                });
                $("#modalSendRetenue").modal('hide');
            })

    })
</script>
