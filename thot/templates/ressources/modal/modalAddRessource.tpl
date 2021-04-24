{debug}
<div id="modalAddRessource" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddRessourceLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddRessourceLabel">Ajouter une ressource</h4>
      </div>
      <div class="modal-body">

          <form id="formAddRessource">

          <p>Vous allez créer une nouvelle ressource du type <strong>{$nomType}</strong></p>
          <div class="row">

              <div class="col-xs-12 col-md-6">
                 <div class="form-group">
                     <label for="description">Nom de cette ressource</label>
                     <input type="text" name="description" id="description" value="{$post.description|default:''}" class="form-control" maxlength="32" required>
                     <div class="help-block">Local C22, tablette, PC portable,...</div>
                 </div>
             </div>

             <div class="col-xs-12 col-md-6">
                 <div class="form-group">
                     <label for="reference">Référence</label>
                     <input type="text" name="reference" id="reference" value="{$post.reference|default:''}" {if isset($post.idRessource)}readonly{/if} class="form-control" maxlength="32">
                    <div class="help-block">
                     {if isset($post.idRessource)}
                        La référence ne peut être modifiée
                        {else}
                        Ceci doit être une référence unique (étiquette, numéro de série,...)
                     {/if}
                     </div>

                 </div>
             </div>

             <div class="col-xs-6 col-md-6">
                 <div class="form-group">
                     <label for="localisation">Localisation</label>
                     <input type="text" name="localisation" id="localisation" value="{$post.localisation|default:''}" class="form-control" maxlength="20">
                     <div class="help-block">Lieu de stockage éventuel, bâtiment,...</div>
                 </div>
             </div>

             <div class="col-xs-2">
                 <div class="checkbox">
                     <label><input type="checkbox" name="hasCaution" id="hasCaution" value="1" {if $post.hasCaution|default:0 == 1}checked{/if}>Caution?</label>
                 </div>
             </div>

             <div class="col-xs-4">
                 <div class="form-group">
                     <label for="montant">Montant</label>
                     <input type="text" name="caution" id="caution" value="{$post.caution|default:''}" class="form-control" disabled>
                     <div class="help-block">Montant de la caution</div>
                 </div>
             </div>

             <div class="col-xs-12">
                 <div class="form-group">
                     <label for="etat">État</label>
                     <textarea name="etat" id="etat" rows="3" class="form-control" placeholder="État de cette ressource">{$post.etat|default:''}</textarea>
                     <div class="help-block">Description des avaries éventuelles</div>
                 </div>
             </div>

          </div>

          <input type="hidden" name="idType" value="{$idType}">
          <input type="hidden" name="idRessource" value="{$post.idRessource|default:''}">

      </form>
      </div>

      <div class="modal-footer">
          <button type="button" class="btn btn-default" id="btn-reset">Annuler</button>
          <button type="button" class="btn btn-primary" id="btn-save">Enregistrer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formAddRessource').validate({
            rules: {
                caution: {
                    required: function(){
                        return $('#hasCaution').is(':checked');
                    }
                },
                description: { required: true },
                reference: { required: true },
                localisation: { required: true }
            }
        })

    })

</script>