<!-- boîte modale d'envoi d'une retenue -->
<div class="modal fade" id="modalSendRetenue" tabindex="-1" role="dialog" aria-labelledby="titleSendRetenue" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleSendRetenue">Envoi d'une retenue</h4>
            </div>
            <div class="modal-body">

                <div id="listeParents"></div>

                <textarea name="texteRetenue" class="form-control" rows="4" cols="40">{include file="eleve/texteRetenue.html"}</textarea>
                <strong class="pull-right">{if $identite.sexe == 'F'}Mme{else}M.{/if} {$identite.prenom|truncate:1:''}. {$identite.nom} - {$identite.titre}</strong>

            </div>
            <div class="modal-footer">
                <input type="hidden" name="idFait" id="modalIdFait" value="">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" id="btnSendRetenue">Envoyer</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

$(document).ready(function(){

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
        $("#modalSendRetenue").modal('show');
    })
    
})

</script>
