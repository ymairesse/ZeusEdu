<div id="modalFiltrer" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalFiltrerLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalFiltrerLabel">Définition du filtre</h4>
      </div>
      <div class="modal-body">

          <form id="formFiltre">
            <p>Période à considérer</p>

                <div class="conteneur">
                {foreach from=$periodesDelibes item=periode}
                  <div class="radio">
                      <label>
                          <input type="radio" name="periodeSelect" id="periodeSelect" value="{$periode}" {if $periode == $periodeSelect}checked{/if}>Période {$periode}
                      </label>
                  </div>
                {/foreach}
                </div>

            <p>Mentions à sélectionner</p>

                {foreach from=$listeMentions item=mention}
                    <label class="checkbox-inline">
                        <input type="checkbox" class="cb" name="listeMentions[]" value="{$mention}"{if $mentionsSelect != Null && in_array($mention, $mentionsSelect)} checked{/if}>
                        {$mention}
                    </label>
                {/foreach}
            </form>
      </div>

      <div class="modal-footer">

          <button type="button" class="btn btn-success pull-left" id="clearFiltre">Supprimer le filtrage</button>

          <div class="btn-group">
              <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
              <button type="button" class="btn btn-primary" id='activerFiltre'>Activer le filtre</button>
          </div>

      </div>

    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#clearFiltre').click(function(){
            $('.cb').prop('checked', false);
        })

        $('#formFiltre').validate({
            rules: {
                periodeSelect: {
                    required: true,
                }
            },
            messages: {
                periodeSelect: ' Veuillez choisir une période de référence ci-dessus '
            },
            errorPlacement: function(error, element) {
                    error.appendTo( element.parents('.conteneur') );
                },
            errorClass: "echec"
        });
    })

</script>
