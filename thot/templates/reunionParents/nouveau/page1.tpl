<div class="row">

    <div class="col-md-3 col-sm-4">
        {if $date != ''}
        <button class="btn btn-lg btn-danger" id="btnDelRp">Supprimer la RP du {$date|date_format:'%m/%d'}</button>
        {/if}

        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">Définition</h3>
            </div>

            <div class="panel-body">

                <form action="" id="setCanevas" method="" class="form-vertical disabled" role="form">

                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="text" class="form-control" id="datepicker" placeholder="Date" value="{$date|default:''}" {if $date != ''}disabled{/if}>
                        <p class="help-block">Date de la réunion</p>
                    </div>


                    <div class="form-group">
                        <label for="debut" class="sr-only">Heure de début</label>
                        <input type="text" class="form-control heure" id="debut" name="debut" placeholder="Heure de début" {if $date != ''} value='{$infoRp.heuresLimites.min}' disabled{/if}>
                        <p class="help-block">Heure de début</p>
                    </div>

                    <div class="form-group">
                        <label for="debut" class="sr-only">Heure de fin</label>
                        <input type="text" class="form-control heure" id="fin" name="fin" placeholder="Heure de fin" {if $date != ''} value='{$infoRp.heuresLimites.max}' disabled{/if}>
                        <p class="help-block">Heure de fin</p>
                    </div>


                    <div class="form-group">
                        <label for="intervalle" class="sr-only">Intervalle</label>
                        <input type="text" class="form-control" id="intervalle" name="intervalle" placeholder="Durée" {if $date != ''} value='-' disabled{/if}>
                        <p class="help-block">Durée d'un entretien (en minutes)</p>
                    </div>

                    <button type="button" class="btn btn-primary pull-right{if $date != ''} disabled{/if}" id="creation">Création <i class="fa fa-arrow-right"></i></button>
                    <div class="clearfix"></div>

                </form>

            </div>  <!-- panel-body -->

            <div class="panel-footer">
                <p>Le détail des RV sera disponible dans la zone centrale après la "création".</p>
            </div>

        </div>  <!-- panel -->

    </div>
    <!-- col-md-... -->

    <div class="col-md-7 col-sm-8">

        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">RV possibles</h3>
            </div>

            <div class="panel-body">

                <form action="index.php" method="POST" role="form" id="tableHoraire" name="table" class="form-inline">

                    <div class="row">

                        <div class="col-md-4 col-sm-6">

                            <div style="height:30em; overflow:auto;">

                                <table class="table table-condensed" id="plusIntervalle">
                                    <thead>
                                        <tr>
                                            <th>&nbsp;</th>
                                            <th>Heure</th>
                                            <th class="text-center">Publié<br>
                                            <input type="checkbox" id="attribHeures" title="Attribuer tout"{if $date != ''} disabled{/if}></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="3" class="alert alert-info">
                                            {if $date == ''}
                                                Le canevas de la réunion de parents apparaîtra ici lorsque le formulaire de la colonne de gauche sera complété.</td>
                                            {else}
                                                Seules les informations de la page 2 sont modifiables
                                            {/if}
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div>

                        </div>  <!-- col-md-... -->

                        <div class="col-md-8 col-sm-6">

                            <div style="height:30em; overflow:auto;">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Prof</th>
                                            <th class="text-center">Attribution<br>
                                            <input type="checkbox" id="attribProfs" title="Attribuer à tous"{if $date != ''} disabled{/if}></th>
                                            <th>Dir<br>
                                            <input type="checkbox" id="attribDir" title="Attribuer à tous"{if $date != ''} disabled{/if}></th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {assign var=i value=0}
                                        {foreach from=$listeProfs key=acronyme item=unProf}
                                            <tr>
                                                <td>
                                                    <span title="{$unProf.acronyme}">{$unProf.nom} {$unProf.prenom}</span>
                                                </td>
                                                <td class="text-center"><input type="checkbox" value="{$acronyme}" id="prof_{$acronyme}" name="prof[{$acronyme}]" class="cbProf"{if $date != ''} disabled{/if}></td>
                                                <td class="text-center"><input type="checkbox" value="{$acronyme}" name="dir[{$acronyme}]" class="dir"{if $date != ''} disabled{/if}>
                                                </td>
                                            </tr>
                                            {assign var=i value=$i+1}
                                        {/foreach}

                                    </tbody>
                                </table>
                            </div>

                        </div>  <!-- col-md-... -->

                    </div>  <!-- row -->

                    <input type="hidden" name="action" value="{$action}">
                    <input type="hidden" name="mode" value="enregistrer">
                    <input type="hidden" name="etape" value="etape1">
                    <input type="hidden" name="date" id="ladate" value="">
                    <button type="submit" class="btn btn-primary pull-right" id="submit" style="display:none">Enregistrer</button>
                    <div class="clearfix"></div>

                </form>

        </div>  <!-- panel-body -->

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

</div>
<!-- row -->

{include file='reunionParents/modal/modalDel.tpl'}
