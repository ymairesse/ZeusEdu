<div class="row">

    <form id="formPage1">

    <div class="col-md-2 col-sm-4">

        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">Définition</h3>
            </div>

            <div class="panel-body">

                <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">

                <div class="form-group">
                  <p><strong>Type de Réunion de Parents</strong></p>

                  <label class="radio-inline">
                      {if isset($idRP)}
                          {if !(isset($infoRP)) || (isset($infoRP) && $infoRP.typeRP == 'profs')}
                          <i class="fa fa-check-circle-o"></i>
                          {else}
                            <i class="fa fa-circle-o"></i>
                          {/if}
                      {else}
                      <input type="radio" name="leType" class="leType" value="profs"
                        {if !(isset($infoRP)) || (isset($infoRP) && $infoRP.typeRP == 'profs')}checked{/if}>
                      {/if}
                      Tous
                  </label>

                  <label class="radio-inline">
                      {if isset($idRP)}
                          {if !(isset($infoRP)) || (isset($infoRP) && $infoRP.typeRP == 'titulaires')}
                            <i class="fa fa-check-circle-o"></i>
                          {else}
                            <i class="fa fa-circle-o"></i>
                          {/if}
                      {else}
                      <input type="radio" name="leType" class="leType" value="titulaires"
                      {if isset($infoRP) && $infoRP.typeRP == 'titulaires'}checked{/if}>
                      {/if}
                    Titulaires
                  </label>

                    <p class="help-block">Concerne tous les enseignants ou seulement les titulaires</p>
                </div>

                <div class="form-group">
                    <label for="datepicker" class="sr-only">Date</label>
                    <input type="text" class="form-control" id="datepicker" placeholder="Date" name="dateReunion"
                    value="{$infoRP.date|default:''}">
                    <p class="help-block">Date de la réunion</p>
                </div>

                <div class="form-group">
                    <label for="debut" class="sr-only">Heure de début</label>
                    <input type="text" class="form-control heure" name="debut" placeholder="Heure de début" id="debut"
                    {if isset($infoRP) && $infoRP.date != Null} value="{$infoRP.heuresLimites.min|default:''}" disabled{/if}>
                    <p class="help-block">Heure de début</p>
                </div>

                <div class="form-group">
                    <label for="debut" class="sr-only">Heure de fin</label>
                    <input type="text" class="form-control heure" name="fin" placeholder="Heure de fin" id="fin"
                    {if isset($infoRP) && $infoRP.date != ''} value='{$infoRP.heuresLimites.max}' disabled{/if}>
                    <p class="help-block">Heure de fin</p>
                </div>

                <div class="form-group">
                    <label for="duree" class="sr-only">Intervalle</label>
                    <input type="text" class="form-control" id="duree" name="duree" placeholder="Durée"
                    {if isset($infoRP) && $infoRP.date != ''} value='-' disabled{/if}>
                    <p class="help-block">Durée d'un entretien (en minutes)</p>
                </div>

                <div class="form-group">
                    <label for="motif" class="sr-only">Motif de la RP</label>
                    <input type="text" class="form-control" name="motif" value="{$infoRP.motif|default:''}" placeholder="Motif de la RP" maxlength="20">
                    <p class="help-block">Bulletin, Consultation copies, Recours,... (20 caractères max)</p>
                </div>

                <div class="clearfix"></div>

                {* le bouton "Création" donne accès à l'étape suivante: création des heures de RV et des profs *}
                {if !isset($idRP)}
                    <button type="button" class="btn btn-primary btn-block" id="creation">Générer la réunion <i class="fa fa-arrow-right"></i></button>
                {else}
                    <button type="button" class="btn btn-danger btn-block" id="btn-delRP" data-idrp="{$idRP|default:''}">Supprimer la RP du {$infoRP.date}</button>
                {/if}

            </div>  <!-- panel-body -->

            <div class="panel-footer">
                <p>Le détail des RV sera disponible dans la zone centrale après la "création".</p>
            </div>

        </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-7 col-sm-8">
        {if isset($readonly) && ($readonly == 1)}
        <div class="alert alert-info">
            Cette page n'est plus modifiable après enregistrement.
        </div>
        {/if}

        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">RV possibles</h3>
            </div>

            <div class="panel-body">

                <div class="col-md-4 col-sm-6">

                    <div style="height:30em; overflow:auto;" id='tableHoraire'>

                        {if isset($listeHeuresRP)}
                            {include file='reunionParents/nouveau/listeHeures.tpl'}
                        {else}
                            {include file='reunionParents/nouveau/listeHeuresVide.tpl'}
                        {/if}

                    </div>

                </div>  <!-- col-md-... -->

                <div class="col-md-8 col-sm-6">

                    <div style="height:30em; overflow:auto;" id="listeProfs">

                    {if isset($listeProfs)}
                    {include file='reunionParents/nouveau/listeProfs.tpl'}
                    {/if}

                    </div>

                </div>  <!-- col-md-... -->


            <input type="hidden" name="dateReunion" id="dateReunion" value="">
            <input type="hidden" name="typeRP" id="leType" value="">
            <button type="button" class="btn btn-primary pull-right" id="saveRP" style="display: none;">Enregistrer cette RP</button>
            <div class="clearfix"></div>

            <div class="panel-footer">
                Attention! Les informations de ce cadre ne sont que partiellement modifiables par la suite
            </div>

        </div>  <!-- panel-body -->

    </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-3 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Informations</h3>
            </div>
            <div class="panel-body" style="overflow: auto; height: 35em">
                <h4>Publication</h4>
                <p>Les périodes "publiées" sont disponibles pour les RV. Les enseignants peuvent publier des périodes "non publiées".</p>
                <p>Les périodes non publiées sont marquées "occupées" pour les parents.</p>

                <h4>Attribution</h4>
                <p>Les enseignants dont la case "attribution" est cochée se verront attribuer le canevas "publié" et créé dans la zone "Définition".</p>
                <p>Les enseignants qui seront absents pour la réunion de parents devraient voir la case "attribution" décochée. Les parents ne pourront prendre rendez-vous avec eux.</p>
                <h4>Direction</h4>
                <p>Les membres du personnel qui n'ont pas de cours peuvent accepter des RV si la case correspondante est cochée.</p>
                <h4>Effacement</h4>
                <p>L'effacement de la réunion de parents est définitif et inexorable. Tous les rendez-vous sont effacés. <br>À ne faire qu'après la date de la réunion.</p>
            </div>
            <div class="panel-footer">
                &nbsp;
            </div>
        </div>
        <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="clearfix"></div>
    <input type="hidden" name="idRP" value="{$idRP|default:''}">
    </form>
</div>
<!-- row -->


<script type="text/javascript">

$(document).ready(function(){

    var idRP = $('#formPage1 input[name="idRP"]').val();
    if (idRP != '')
        $('#formPage1 input').attr('disabled', true);
        else $('#formPage1 input').attr('disabled', false);

    $('#formPage1').validate({
        rules: {
            leType: {
                required: true
            },
            dateReunion: {
                required: true
            },
            debut : {
                required: true
            },
            fin: {
                required: true
            },
            duree: {
                required: true,
                number: true,
                max: 60
            }
        }
    })

})

</script>
