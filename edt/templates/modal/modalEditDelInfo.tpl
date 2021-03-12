<div id="modalEditDelInfo" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditDelInfoLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditDelInfoLabel">Ajouter / Modifier / Supprimer une info</h4>
      </div>
      <div class="modal-body">
        <form id="modalEdit" name="modalEdit">

        <div class="form-group">
            <label for="info">Information</label>
            <input type="text" name="info" id="modalInfo" value="{$info.info}" class="form-control" size="40">
            <div class="help-block">Max 40 caractères</div>
        </div>
        <input type="hidden" name="date" value="{$date}">
        <input type="hidden" name="id" value="{$info.idEDTinfo|default:-1}">
        <input type="hidden" name="type" value="{$info.type|default:$type}">
        </form>

      </div>
      <div class="modal-footer">

        {if (($acronyme == $info.proprio) || ($userStatus == 'admin') && ($info != Null))}
            <button type="button" class="btn btn-danger pull-left" id="btn-modalDelInfo" data-id="{$info.idEDTinfo}">Supprimer cette mention</button>
            <button type="button" class="btn btn-primary" id="btn-modalSaveInfo" data-id="{$info.idEDTinfo}">Enregistrer</button>
        {elseif $info == Null}
            <button type="button" class="btn btn-primary" id="btn-modalSaveInfo" data-id="{$info.idEDTinfo}">Enregistrer</button>
        {else}
            Vous n'êtes pas propriétaire de cette information
        {/if}
      </div>
    </div>
  </div>
</div>
