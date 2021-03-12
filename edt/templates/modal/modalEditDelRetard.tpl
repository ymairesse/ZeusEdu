<div id="modalEditDelRetard" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditDelRetardLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditDelRetardLabel">Ajouter / Modifier / supprimer une info</h4>
      </div>
      <div class="modal-body">
        <form id="modalEdit">
            <div class="col-xs-3 {if $type=='info'}hidden{/if}">
                <div class="form-group">
                    <input type="text" name="acronyme" id="acronyme" value="{$info.acronyme}" class="form-control" size="7" placeholder="ABREV" style="text-transform:uppercase" {if $type=='info'}disabled{/if} tabindex="1">
                </div>
            </div>
            <div class="col-xs-9 {if $type=='info'}hidden{/if}">
                <div class="form-group">
                    <select class="form-control" name="listeProfs" id="listeProfs" {if $type=='info'}disabled{/if} tabindex="2">
                        <option value="">Sélection du prof</option>
                        {if isset($listeProfs)}
                        {foreach from=$listeProfs key=unAcronyme item=data}
                        <option value="{$unAcronyme}"{if $unAcronyme == $info.acronyme} selected{/if}>{$data.nom} {$data.prenom}</option>
                        {/foreach}
                        {/if}
                    </select>
                </div>
            </div>

            <div class="col-xs-12">
                <div class="form-group">
                    <label for="info">Information</label>
                    <input type="text" name="info" id="modalInfo" value="{$info.info}" class="form-control" maxlength="80" tabindex="3">
                    <div class="help-block">Max 80 caractères</div>
                </div>
                <input type="hidden" name="date" value="{$date}">
                <input type="hidden" name="id" value="{$info.idEDTinfo|default:-1}">
                <input type="hidden" name="type" value="{$info.type|default:$type}">
            </div>
            <div class="clearfix"></div>
        </form>

      </div>
      <div class="modal-footer">
        {if (($acronyme == $info.proprio) || ($userStatus == 'admin') && ($info != Null))}
            <button type="button" class="btn btn-danger pull-left" id="btn-modalDelInfo" data-id="{$info.idEDTinfo}" tabindex="5">Supprimer cette mention</button>
            <button type="button" class="btn btn-primary" id="btn-modalSaveRetard" data-id="{$info.idEDTinfo}" tabindex="4">Enregistrer</button>
        {elseif $info == Null}
            <button type="button" class="btn btn-primary" id="btn-modalSaveRetard" data-id="{$info.idEDTinfo}" tabindex="4">Enregistrer</button>
        {else}
            Vous n'êtes pas propriétaire de cette information
        {/if}
      </div>
    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        {if $type == 'retard'}
        $('#acronyme').prop('required', true);
        $('#modalEditDelRetard').on('shown.bs.modal', function () {
            $('#acronyme').focus();
        })
        {else}
        $('#modalEditDelRetard').on('shown.bs.modal', function () {
            $('#modalInfo').focus();
        })
        {/if}

        // $('#modalEdit').validate({
        //     rules: {
        //         acronyme: {
        //             required: true;
        //         }
        //     }
        // });
    })

</script>
