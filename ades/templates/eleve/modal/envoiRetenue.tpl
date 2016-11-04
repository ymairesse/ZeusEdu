<!-- boîte modale d'envoi d'une retenue -->
<div class="modal fade" id="modalSendRetenue" tabindex="-1" role="dialog" aria-labelledby="titleSendRetenue" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="sendRetenue">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleSendRetenue">Envoi d'une retenue</h4>
            </div>
            <div class="modal-body">

                <div id="listeParents"></div>

                <textarea name="texteRetenue" id='texteRetenue' class="form-control" rows="4" cols="40">{include file="retenues/texteRetenue.html"}</textarea>
                <strong class="pull-right">{if $identite.sexe == 'F'}Mme{else}M.{/if} {$identite.prenom|truncate:1:''}. {$identite.nom} - {$identite.titre}</strong>

            </div>
            <div class="modal-footer">
                <input type="hidden" name="idFait" id="modalIdFait" value="">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btnSendRetenue" disabled="disabled">Envoyer</button>
                </div>
            </div>
        </form>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#modalSendRetenue").on('click', '.sendTo', function(){
            if ($('.sendTo:checked').length > 0)
                $("#btnSendRetenue").attr('disabled', false);
                else $("#btnSendRetenue").attr('disabled', true);
        })

        $(".send-eDoc").click(function() {
            var idFait = $(this).data('idfait');
            var matricule = $("#selectEleve").val();
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
            var idfait = $("#modalIdFait").val();
            var texteRetenue = $("#texteRetenue").val();
            var sendTo = $(".sendTo")
            // création du document
            $.post('inc/retenues/printRetenue.inc.php', {
                    idfait: idfait
                },
                function(resultat) {
                    var fileName = resultat;
                    var data = $("#sendRetenue").serialize();
                    $.post('inc/retenues/sendDocument.inc.php', {
                        post: data,
                        fileName: fileName
                        },
                        function(resultat) {
                            if (resultat == 1)
                                $("#mailOK").removeClass('hidden');
                                else $("#mailKO").removeClass('hidden');
                        });
                });
            // envoi du mail

            $("#modalSendRetenue").modal('hide');
        })

    })
</script>
