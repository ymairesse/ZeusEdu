<div id="modalDelRV" class="modal fade">

    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>

            <div class="modal-body">

                <p>Voulez vous vraiment supprimer ce RV avec les parents de <strong id="modalNomEleve"></strong>?</p>

                <form name="delRV" id="delRV" class="form-vertical" role="form" method="POST" action="index.php">
                    <p>Attention, un mail à votre nom confirmant cette annulation sera envoyé à cette personne.</p>
                    <label for="raison">Raison de l'annulation</label>
                    <textarea name="raison" id="raison" cols="60" rows="3" placeholder="Votre texte ici" class='required'></textarea>

                    <input type="hidden" name="date" value="{$date}">
                    <input type="hidden" name="type" value="{$type}">
                    <input type="hidden" name="id" id="modalId" value="">
                    <input type="hidden" name="action" value="{$action}">
                    <input type="hidden" name="mode" value="delRV">
                    <button type="submit" class="btn btn-danger pull-right" id="confirmDel">Confirmer l'annulation du RV</button>
                    <div class="clearfix"></div>
                </form>

            </div>
        </div>

    </div>

</div>
