<div id="modalDelRV" class="modal fade">

    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>

            <div class="modal-body">
                <form id="form-confirmDel">
                    <p>Voulez vous vraiment supprimer ce RV avec <strong>{$infoRV.formule} {$infoRV.prenomParent} {$infoRV.nomParent}</strong> <br>
                    parent de <strong>{$infoRV.prenomEleve} {$infoRV.nomEleve} de {$infoRV.groupe}</strong>?</p>
                    <p>Un mail depuis votre adresse mail professionnelle (<a href="mailto:{$mailExpediteur}">{$mailExpediteur}</a>) confirmant cette suppression sera envoyé à l'adresse <a href="mailto:{$infoRV.mail}">{$infoRV.mail}</a>. Ci-dessous, le texte de ce mail. Veuillez compléter la raison de l'annulation <span style="background:pink">dans le cadre coloré </span>.</p>
                    <div  style="font-style: italic">

                        {$texte}

                    </div>
                    <input type="hidden" name="idRV" id="idRV" value="{$infoRV.idRV}">
                    <input type="hidden" name="idRP" id="idRP" value="{$infoRV.idRP}">
                    <input type="hidden" name="matricule" id="matricule" value="{$infoRV.matricule}">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" id="modalConfirmDelRV">Confirmer</button>
            </div>
        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#form-confirmDel').validate({
            rules: {
                raison: {
                    required: true
                }
            }
        })
    })

</script>
