<form class="form-vertical" action="index.php" method="POST" role="form" name="formDel">
    <div class="alert alert-warning">
        <i class="fa fa-info-circle fa-2x"></i> Veuillez confirmer la suppression de la pondération particulière pour cet élève
    </div>

    <table class="table table-condensed table-bordered">
        <thead>
            <tr>
                {foreach from=$NOMSPERIODES item=periode}
                <th colspan="2">{$periode}</th>
                {/foreach}
            </tr>
            <tr>
                {foreach from=$NOMSPERIODES item=periode}
                <th>Form.</th>
                <th>Cert.</th>
                {/foreach}
            </tr>
        </thead>
        <tbody>
            <tr>
                {foreach from=$ponderation key=wtf item=pond}
                <td>{$pond.form}</td>
                <td>{$pond.cert}</td>
                {/foreach}
            </tr>
        </tbody>
    </table>

    <input type="hidden" name="action" value="gestionBaremes">
    <input type="hidden" name="mode" value="delPonderation">
    <input type="hidden" id="matricule" name="matricule" value="{$matricule}">
    <input type="hidden" name="coursGrp" value="{$coursGrp}">

    <div class="btn-group pull-right">
      <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
      <button type="submit" class="btn btn-primary">Supprimer</button>
    </div>
    <div class="clearfix"></div>
</form>
