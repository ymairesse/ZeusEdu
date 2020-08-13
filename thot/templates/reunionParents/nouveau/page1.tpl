<div class="row">
    <div class="col-xs-12">
        {if isset($infoRp.idRP)}

        <button class="btn btn-block btn-danger" id="btn-DelRp" data-idrp="{$idRP|default:''}">Supprimer la RP du {$infoRp.date}</button>

        {/if}
    </div>

    <form action="index.php" method="POST" role="form" name="table" class="form-inline">

    <div class="col-md-3 col-sm-4">

        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">Définition</h3>
            </div>

            <div class="panel-body">

                <div class="form-group">
                  <p><strong>Type de Réunion de Parents</strong></p>

                  <label class="radio-inline">
                      {if $idRP != ''}
                          {if !(isset($infoRp)) || (isset($infoRp) && $infoRp.typeRP == 'profs')}
                          <i class="fa fa-check-circle-o"></i>
                          {else}
                            <i class="fa fa-circle-o"></i>
                          {/if}
                      {else}
                      <input type="radio" name="leType" value="profs"
                        {if !(isset($infoRp)) || (isset($infoRp) && $infoRp.typeRP == 'profs')}checked{/if}>
                      {/if}
                      Tous
                  </label>

                  <label class="radio-inline">
                      {if $idRP != ''}
                          {if !(isset($infoRp)) || (isset($infoRp) && $infoRp.typeRP == 'titulaires')}
                            <i class="fa fa-check-circle-o"></i>
                          {else}
                            <i class="fa fa-circle-o"></i>
                          {/if}
                      {else}
                      <input type="radio" name="leType" value="titulaires"
                      {if isset($infoRp) && $infoRp.typeRP == 'titulaires'}checked{/if}>
                      {/if}
                    Titulaires
                  </label>

                  <label class="radio-inline">
                      {if $idRP != ''}
                          {if !(isset($infoRp)) || (isset($infoRp) && $infoRp.typeRP == 'cible')}
                          <i class="fa fa-check-circle-o"></i>
                          {else}
                            <i class="fa fa-circle-o"></i>
                          {/if}
                      {else}
                      <input type="radio" name="leType" value="cible"
                        {if !(isset($infoRp)) || (isset($infoRp) && $infoRp.typeRP == 'cible')}checked{/if}>
                      {/if}
                      Ciblé
                  </label>

                    <p class="help-block">Concerne tous les enseignants ou seulement les titulaires</p>
                </div>

                <div class="form-group">
                    <label for="date" class="sr-only">Date</label>
                    <input type="text" class="form-control" id="datepicker" placeholder="Date"
                    value="{$infoRp.date|default:''}" {if isset($infoRp) && $infoRp.date != ''} disabled{/if}>
                    <p class="help-block">Date de la réunion</p>
                </div>

                <div class="form-group">
                    <label for="debut" class="sr-only">Heure de début</label>
                    <input type="text" class="form-control heure" id="debut" name="debut" placeholder="Heure de début"
                    {if isset($infoRp) && $infoRp.date != Null} value="{$infoRp.heuresLimites.min|default:''}" disabled{/if}>
                    <p class="help-block">Heure de début</p>
                </div>

                <div class="form-group">
                    <label for="debut" class="sr-only">Heure de fin</label>
                    <input type="text" class="form-control heure" id="fin" name="fin" placeholder="Heure de fin"
                    {if isset($infoRp) && $infoRp.date != ''} value='{$infoRp.heuresLimites.max}' disabled{/if}>
                    <p class="help-block">Heure de fin</p>
                </div>


                <div class="form-group">
                    <label for="intervalle" class="sr-only">Intervalle</label>
                    <input type="text" class="form-control" id="intervalle" name="intervalle" placeholder="Durée"
                    {if isset($infoRp) && $infoRp.date != ''} value='-' disabled{/if}>
                    <p class="help-block">Durée d'un entretien (en minutes)</p>
                </div>

                <div class="clearfix"></div>

                {* le bouton "Création" donne accès à l'étape suivante: création des heures de RV et des profs *}
                <button type="button" class="btn btn-primary pull-right{if $infoRp.date != ''} disabled{/if}" id="creation">Création <i class="fa fa-arrow-right"></i></button>

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

            <input type="hidden" name="idRP" value="{$idRP|default:Null}">
            <input type="hidden" name="action" value="{$action}">
            <input type="hidden" name="mode" value="enregistrer">
            <input type="hidden" name="etape" value="etape1">
            <input type="hidden" name="date" id="ladate" value="">
            <input type="hidden" name="typeRP" id="typeRP" value="">
            <input type="hidden" name="onglet" class="onglet" value="{$onglet}">
            <button type="submit" class="btn btn-primary pull-right" id="submit" style="display:none">Enregistrer</button>
            <div class="clearfix"></div>

        </div>  <!-- panel-body -->

        <div class="panel-footer">
            <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
        </div>

    </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-2 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Informations</h3>
            </div>
            <div class="panel-body" style="overflow: auto; height: 35em">
                <h4>Publication</h4>
                <p class="micro">Les périodes "publiées" sont disponibles pour les RV. Les enseignants peuvent publier des périodes "non publiées".</p>
                <p class="micro">Les périodes non publiées sont marquées "occupées" pour les parents.</p>

                <h4>Attribution</h4>
                <p class="micro">Les enseignants dont la case "attribution" est cochée se verront attribuer le canevas "publié" et créé dans la zone "Définition".</p>
                <p class="micro">Les enseignants qui seront absents pour la réunion de parents devraient voir la case "attribution" décochée. Les parents ne pourront prendre rendez-vous avec eux.</p>
                <h4>Direction</h4>
                <p class="micro">Les membres du personnel qui n'ont pas de cours peuvent accepter des RV si la case correspondante est cochée.</p>
                <h4>Effacement</h4>
                <p class="micro">L'effacement de la réunion de parents est définitif et inexorable. Tous les rendez-vous sont effacés. <br>À ne faire qu'après la date de la réunion.</p>
            </div>
            <div class="panel-footer">
                &nbsp;
            </div>
        </div>
        <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="clearfix"></div>

    </form>
</div>
<!-- row -->




<script type="text/javascript">

$(document).ready(function(){

    $("#submit").click(function(){
        var nbPeriodes = $('.cbHeure:checked').length;
        if (nbPeriodes == 0) {
            alert('Au moins une période de RV svp');
            return false;
        }
        var nbProfs = $('.cbProf:checked').length;
        if (nbProfs == 0) {
            alert('Au moins un professeur svp');
            return false;
        }

    })
})

</script>
