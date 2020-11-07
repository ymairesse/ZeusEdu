<div id="modalAddSubject" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddSubjectLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddSubjectLabel">{if isset($idSujet)}Modifier un sujet de{else}Ajouter un sujet à{/if} la catégorie <strong>{$categorie.libelle}</strong></h4>
      </div>
      <div class="modal-body">

          <form id="formAddSubject">

              <div class="form-group">
                  <label for="modalSubject">
                    {if isset($idSujet)}
                        Modification du sujet "{$sujet}" dans la catégorie "{$categorie.libelle}"
                    {else}
                        Nouveau sujet: {$categorie.libelle}
                    {/if}</label>
                  <textarea name="modalSubject" id="modalSubject" rows="2" cols="80" class="form-control" maxlength="80">{$sujet|default:''}</textarea>
                  <span class="help-block">Thème de ce nouveau sujet (80 caractères max)</span>
              </div>

              <div class="row">

                  <div class="col-xs-6">
                     <div class="checkbox">
                         <label><input type="checkbox" name="fbLike" id="fbLike" value="1" {if $fbLike|default:1 == 1} checked{/if}>Bouton <img src="images/defaultFB.png" alt="like" style="width:28px;height:28px;"> sur ce sujet (les contributeurs peuvent "liker" les posts)</label>
                     </div>
                 </div>

                 <div class="col-xs-6">
                     <h4>Sujet pour</h4>
                     <p>{if $categorie.userStatus == 'eleves'}<strong class="eleves">Élèves et professeurs{else}<strong class="profs">Professeurs{/if}</strong></p>

                     <label class="radio">
                         <input type="radio" name="forumActif" value="1" {if $forumActif|default:1 == 1}checked{/if}>
                         <i class="fa fa-ghost"></i> Visible pour tous les invités
                     </label>

                     <label class="radio">
                         <input type="radio" name="forumActif" value="2" {if $categorie.userStatus == 'profs'} disabled{/if}{if $forumActif|default:1 == 2}checked{/if}>
                         <i class="fa fa-ghost"></i> Invisible pour les élèves / visible pour les profs
                     </label>

                     <label class="radio">
                         <input type="radio" name="forumActif" value="0" {if $forumActif|default:1 == 0}checked{/if}>
                         <i class="fa fa-ghost"></i> Invisible pour tous les invités
                     </label>

                 </div>

              </div>

              <div id="selecteurCible">
                {if $categorie.userStatus == 'eleves'}
                    {include file="forum/modal/selectProfsEleves.tpl"}
                {else}
                    {include file="forum/modal/selectProfs.tpl"}
                {/if}
              </div>

              <input type="hidden" name="modalIdCategorie" id="modalIdCategorie" value="{$categorie.idCategorie}">
              <input type="hidden" name="modalIdSujet" id="modalIdSujet" value="{$idSujet|default:''}">

              <button type="button" class="btn btn-primary btn-block" id="btnModalSaveSubject">Enregistrer</button>
          </form>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        // activer le champ #modalSubject à l'ouverture du modal
        $('#modalAddSubject').on('shown.bs.modal', function(){
            $('#modalSubject').focus();
        })

        $('#formAddSubject').validate({
            rules: {
                modalSubject: {
                    required: true,
                },
                choixCibleEleve: {
                    required: true,
                }
            }
        })
    })

</script>
