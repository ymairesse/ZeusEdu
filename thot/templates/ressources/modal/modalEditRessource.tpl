<div id="modalEditRessource" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditRessourceLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditRessourceLabel">
            {if $addEditClone == 'add'}
                Création
            {elseif $addEditClone == 'edit'}
                Modification
            {else}
                Clonage{/if}
            d'une ressource</h4>
      </div>
      <div class="modal-body">
        <form id="formEditRessource">

            <div class="row">

                <div class="col-xs-12 col-md-6">
                    <div class="form-group">
                        <label for="type">Type de ressource</label>
                        <select class="form-control" name="idType">
                            <option value="">Type de ressource</option>
                            {foreach from=$listeTypes key=unIdType item=type}
                            <option value="{$unIdType}"{if $post.idType == $unIdType} selected{/if}>{$type}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

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
                        <input type="text"
                        name="reference" id="reference" value="{$post.reference|default:''}"
                        class="form-control" maxlength="32">
                       <div class="help-block">
                        {if isset($post.idRessource)}
                           La référence ne peut être modifiée
                           {else}
                           Référence unique (étiquette, n° de série,...)
                        {/if}
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-md-6">
                    <div class="form-group">
                        <label for="localisation">Localisation</label>
                        <input type="text" name="localisation" id="localisation" value="{$post.localisation|default:''}" class="form-control" maxlength="20">
                        <div class="help-block">Lieu de stockage, bâtiment,...</div>
                    </div>
                </div>

                <div class="col-xs-2 col-md-2">
                    <div class="checkbox">
                        <label><input type="checkbox" name="hasCaution" id="hasCaution" value="1" {if $post.hasCaution==1}checked{/if}>Caution?</label>
                    </div>
                </div>

                <div class="col-xs-4 col-md-4">
                    <div class="form-group">
                        <label for="montant">Montant</label>
                        <input type="text" name="caution" id="caution" value="{$post.caution|default:''}" class="form-control" {if $post.hasCaution == 0}disabled{/if}>
                        <div class="help-block">Montant de la caution</div>
                    </div>
                </div>

                <div class="col-xs-12 col-md-6">
                    <div class="checkbox">
                        <label><input type="checkbox" name="indisponible" id="indisponible" value="1" {if $post.indisponible==1}checked{/if}>
                            Temporairement indisponible
                        </label>
                    </div>
                </div>

                <div class="col-xs-12 col-md-6">
                    <div class="form-group">
                        <input type="text"
                            name="longTermeBy"
                            id="longTermeBy"
                            value="{$post.longTermeBy|default:''}"
                            class="form-control"
                            placeholder="Matricule ou acronyme">
                        <div class="help-block">Emprunt à long terme <span id="emprunteur" style="color: red">
                            {if $post.groupe != Null}{$post.groupe} {$post.nomEleve} {$post.prenomEleve}{/if}
                            {if $post.nomProf != Null}{$post.prenomProf} {$post.nomProf}{/if}
                            </span>
                        </div>
                    </div>

                </div>

                <div class="col-xs-12">
                    <div class="form-group">
                        <label for="etat">État</label>
                        <textarea name="etat" id="etat" rows="3" class="form-control" placeholder="État de cette ressource">{$post.etat|default:''}</textarea>
                        <div class="help-block">Description des avaries éventuelles</div>
                    </div>
                </div>

            </div>   {* row *}

            <input type="hidden" name="idRessource" value="{$post.idRessource|default:''}">
            <input type="hidden" name="addEditClone" value="{$addEditClone}">

        </form>

      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-primary" id="btn-save">Enregistrer</button>
      </div>
    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        var validator = $('#formEditRessource').validate({
            rules: {
                idType: { required: true},
                caution: {
                    required: function(){
                        return $('#hasCaution').is(':checked');
                    }
                },
                // longTermeBy: {
                //     required: function(){
                //         return $('#indisponible').is(':checked');
                //     }
                // },
                description: { required: true },
                reference: { required: true },
                localisation: { required: true }
            }
        });

        // $('#indisponible').change(function(){
        //     var checked = $(this).is(':checked');
        //     $('#longTermeBy').val('').attr('disabled', !checked);
        //     if (!checked) {
        //         $('#emprunteur').text('');
        //     }
        // })

        $('#longTermeBy').blur(function(){
            var qui = $(this).val();
            if (qui == '') {
                // $('#indisponible').prop('checked', false);
                // $('#longTermeBy').attr('disabled', true);
                $('#emprunteur').text('');
                validator.resetForm();
            }
            else {
                $.post('inc/ressources/search4qui.inc.php', {
                    qui: qui
                }, function(resultat){
                    $('#emprunteur').text(resultat);
                })
            }
        })

    })

</script>
