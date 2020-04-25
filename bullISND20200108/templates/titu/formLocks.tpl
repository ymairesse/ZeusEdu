<div class="modal-body">

    <form name="formLocks" id="formLocks">

        <p>Vous souhaitez</p>

                <label><input type="radio" value="0" name="action" checked> Dé-verrouiller</label><br>
                <label><input type="radio" value="1" name="action"> Verrouiller <strong>les cotes</strong></label><br>
                <label><input type="radio" value="2" name="action"> Verrouiller <strong>cotes & remarques</strong></label>

            <br>

            <p style="font-size: larger" class="pull-right">Pour <strong>{$cible}</strong></p>

            <div class="clearfix"> </div>

            <input type="hidden" name="type" value="{$type}">
            <input type="hidden" name="coursGrp" value="{$coursGrp}">
            <input type="hidden" name="classe" value="{$classe}">
            <input type="hidden" name="matricule" value="{$matricule}">
            <input type="hidden" name="periode" value="{$periode}">

    </form>

</div>

<div class="modal-footer">
    <div class="btn-group pull-right">
        <button type="reset" class="btn btn-default" data-dismiss="modal">Annuler</button>
        <button type="button" class="btn btn-primary" id="btnPutLocks">Action</button>
    </div>
</div>
