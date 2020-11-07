<div id="modalGestSujets" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalGestSujetsLabel" aria-hidden="true">

  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalGestSujetsLabel">Gestion des sujets</h4>
      </div>

      <div class="modal-body">

          <form id="formCreateSubject">

              <div class="row">
                  <div class="col-md-5 col-xs-12">

                      <div class="form-group">
                          <label for="sujet">Sujet du forum</label>
                          <input type="text" name="sujet"
                            id="sujet"
                            value="{$infoSujet.sujet|default:''}"
                            class="form-control"
                            placeholder="Max 40 caractères"
                            maxlength="40">
                      </div>

                      <div class="panel panel-info">
                          <div class="panel-heading">
                              Choisir parme les catégories suivantes
                          </div>

                          <div class="panel-body" style="height:15em; overflow: auto;" id="modalListeCategories">
                              {if !isset($infoSujet.idsujet)}
                              {include file="forum/treeviewCategories.tpl"}
                              {else}
                              <p class="text-danger">La catégorie d'un sujet existant n'est pas modifiable</p>
                              {/if}
                          </div>

                      </div>

                      <div class="checkbox">
                          <label>
                              <input type="checkbox" name="fbLike" id="fbLike" value="1"
                                {if $infoSujet.fbLike|default:1 == 1} checked{/if}>
                                <span title='les contributeurs peuvent "liker" les posts'>Boutons <i class="fa fa-lg fa-thumbs-o-up"></i> sur ce sujet</span>
                          </label>
                      </div>

                  </div>

                  <div class="col-md-7 col-xs-12">

                      <div class="form-group">
                          <label for="categorie" class="sr-only">Catégorie sélectionnée</label>
                          <input type="text" name="categorie" id="categorie" class="form-control {$categorie.userStatus|default:''}" value="{$categorie.libelle|default:''}" readonly placeholder="Sél. une catégorie à gauche">
                          <span class="help-block" id="helpCategorie">
                              {if isset($infoSujet.idsujet)}
                                {if ($categorie.userStatus == 'profs')}
                                    Uniquement les enseignants
                                    {else}
                                    Élèves (et enseignants)
                                {/if}
                                {else}
                              Type de forum
                            {/if}
                        </span>

                      </div>

                    {assign var=fa value=$infoSujet.forumActif|default:Null}
                    {$fa = ($fa == Null) ? 1 : $fa}

                      Visibilité
                      <label class="radio-inline" title="Visible pour tous les invités">
                          <input type="radio" name="forumActif" value="1" {if $fa == 1}checked{/if}>
                          <strong style="color:#2b8a3e"> P <i class="fa fa-mortar-board"></i></strong> <strong style="color:#2b8a3e"> E <i class="fa fa-user" ></i></strong>
                      </label>
                      <label class="radio-inline" title="Visible pour les profs / Invisible pour les élèves">
                          <input type="radio" name="forumActif" value="2" {if $fa == 2}checked{/if}>
                          <strong style="color:#2b8a3e">P <i class="fa fa-mortar-board"></i></strong> <strong style="color:#f00">E <i class="fa fa-user"></i></strong>
                      </label>
                      <label class="radio-inline" title="Invisible pour tous les invités">
                          <input type="radio" name="forumActif" value="3" {if $fa == 3}checked{/if}>
                          <strong style="color:#f00">P <i class="fa fa-mortar-board"></i></strong> <strong style="color:#f00"> E <i class="fa fa-user"></i></strong>
                      </label>

                      {include file='forum/modal/selectProfsEleves.tpl'}

                      <input type="hidden" name="idCategorie" id="idCategorie" value="{$categorie.idCategorie|default:''}">
                      <input type="hidden" name="userStatus" id="userStatus" value="{$categorie.userStatus|default:''}">
                      {if isset($infoSujet.idsujet)}
                      <input type="hidden" name="idSujet" name="idSujet" value="{$infoSujet.idsujet}">
                      <input type="hidden" name="edition" id="edition" value="1">
                      {else}
                      <input type="hidden" name="edition" id="edition" value="0">
                      {/if}

                  </div>

              </div>

        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="btn-createSubject">{if isset($infoSujet.idsujet)}Modifier{else}Créer{/if} ce sujet</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formCreateSubject').validate({
            rules: {
                sujet: {
                    required: true
                },
                categorie: {
                    required: true
                }
            }
        })

        $('#modalListeCategories').on('click', '.treeview a', function(){
            var edition = $('#edition').val();
            // en édition, on ne peut pas modifier la catégorie
            if (edition == 0) {
                var idCategorie = $(this).data('idcategorie');
                var categorie = $(this).text().trim();
                var userStatus = $(this).data('userstatus');
                $('#categorie').val(categorie).removeClass('profs eleves').addClass(userStatus);
                if (userStatus == 'profs') {
                    $('#helpCategorie').text('Uniquement les enseignants');
                    $('#choixCibleEleve').attr('disabled', true);
                    $('.sousSelection').find('input:checkbox').attr('disabled', true);
                    }
                    else {
                        $('#helpCategorie').text('Élèves (et enseignants)');
                        $('#choixCibleEleve').attr('disabled', false);
                        $('.sousSelection').find('input:checkbox').attr('disabled', false);
                    }
                $('#idCategorie').val(idCategorie);
                $('#userStatus').val(userStatus);
            }
        })
    })

</script>
