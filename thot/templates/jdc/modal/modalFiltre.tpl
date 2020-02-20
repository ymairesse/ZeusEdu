<div id="modalFiltre" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalFiltreLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalFiltreLabel">Filtrer par type</h4>
      </div>
      <div class="modal-body">
          <p>Veuillez sélectionner les items à montrer dans le JDC</p>
          <form id="formTypes">
          {foreach from=$listeTypes key=type item=libelle}
              <div class="checkbox">
                  <label>
                      <input class="checkType" type="checkbox" value="{$type}" {if isset($typesJDC.$type) && ($typesJDC.$type == 1)}checked{/if} class="types" name="types[]"> {$libelle}
                  </label>
              </div>
          {/foreach}
          <div style="border-top: 1px solid #888">
          <label for="checkAllFiltre"><input type="checkbox" id="checkAllFiltre" checked> Sélectionner/désélectionner tout</label>
          </div>
          </form>

      </div>
      <div class="modal-footer">
          <div class="btn-group">
              <button type="reset" class="btn btn-default" data-dismiss="modal">Annuler</button>
              <button type="button" class="btn btn-primary" id="confirmFiltre">Confirmer</button>
          </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $('#checkAllFiltre').change(function(){
        var checked = $(this).prop('checked');
        $('.checkType').each(function(){
            $(this).prop('checked', checked);
        })
    })

</script>
