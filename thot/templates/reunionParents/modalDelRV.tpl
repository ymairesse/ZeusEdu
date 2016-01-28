<div id="modalDelRV" class="modal fade">
Coucou
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>

            <div class="modal-body">
                <form action="index.php" method="POST" class="form-vertical" role="form" id="modalDel">
                <p>Voulez vous vraiment supprimer ce RV avec <strong id="nomParent"></strong>?</p>
                <p>Attention, un mail d'avertissement de cette annulation sera envoyé à cette personne.</p>

                <input type="hidden" name="id" id="id" value="">
                <input type="hidden" name="action" value="{$action}">
                <input type="hidden" name="mode" value="{$mode}">
                <input type="hidden" name="etape" value="delRV">
                <button type="submit" class="btn btn-danger pull-right">Confirmer l'annulation du RV</button>
                <div class="clearfix"></div>
                </form>
            </div>
        </div>

    </div>

</div>
