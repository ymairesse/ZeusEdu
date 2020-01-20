<div id="mesEleves" class="tab-content">

	{if $elevesSuivis|@count > 0}
    {foreach from=$elevesSuivis key=anneeScolaire item=mesEleves}
        <div class="tab-pane {if $anneeScolaire == $ANNEESCOLAIRE}active{/if}" id="tabs-{$anneeScolaire}" style="max-height:35em; overflow: auto">
            <table class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th style="width:1em">&nbsp;</th>
                    <th style="width:3em">&nbsp;</th>
                    <th class="hidden-print"><button type="button" class="btn btn-xs btn-block {if $tri == 'classeAlpha'}btn-green{else}btn-primary{/if}" id="btnClasse" data-tri="classeAlpha">Classe</button></th>
                    <th><button type="button" class="btn btn-xs btn-block {if $tri == 'alpha'}btn-green{else}btn-primary{/if}" id="btnName" data-tri="nom">Nom</button></th>
                    <th><button type="button" class="btn btn-xs btn-block {if $tri == 'chrono'}btn-green{else}btn-primary{/if}" id="btnDate" data-tri="date">Date et heure</button></th>
                </tr>
            </thead>
            <tbody>
                {if isset($elevesSansRV.$anneeScolaire)}
                    {* traitement des élèves sans RV s'il y en a pour cette année scolaire *}
                    {foreach from=$elevesSansRV.$anneeScolaire key=matricule item=unEleve}
                        {foreach from=$unEleve key=wtf item=unRV}
                            <tr class="selected">
                                <td class="hidden-print">
                                    <form action="index.php" method="POST" role="form" class="form-inline microform">
                                        <input type="hidden" name="matricule" value="{$unRV.matricule}">
                                        <input type="hidden" name="action" value="ficheEleve">
                                        <button type="submit" class="btn btn-primary btn-xs"><i class="fa fa-eye"></i></button>
                                    </form>
                                </td>
                                <td>&nbsp;</td>
                                <td>{$unRV.groupe}</td>
                                <td class="pop" data-toggle="popover" data-content="<img src='../photos/{$unRV.photo}.jpg' alt='{$unRV.matricule}' style='width:100px'>" data-html="true" data-container="body" data-original-title="{$unRV.photo}">
                                    {$unRV.nom} {$unRV.prenom}
                                </td>
                                <td>RV à fixer</td>
                            </tr>
                        {/foreach}
                    {/foreach}
                {/if}

                {foreach from=$mesEleves key=matricule item=unEleve}
                    {assign var=n value=0}
                    {foreach from=$unEleve key=date item=uneVisite}

                    <tr class="{if ($uneVisite.absent == 1)}absent {/if}
                            {if $n > 0}more_{$matricule}{/if}" {if $n> 0} style="display: none"{/if}>
                        <td class="hidden-print">
                            {if $n == 0}
                            <form action="index.php" method="POST" role="form" class="form-inline microform">
                                <input type="hidden" name="matricule" value="{$uneVisite.matricule}">
                                <input type="hidden" name="action" value="ficheEleve">
                                <button type="submit" class="btn btn-primary btn-xs"><i class="fa fa-eye"></i></button>
                            </form>
                            {else} &nbsp; {/if}
                        </td>
                        <td class="hidden-print">
                            {if ($n == 0) && ($unEleve|@count > 1)}
                            <button type="button" class="btn btn-default btn-xs more" data-matricule="{$uneVisite.matricule}" data-open="0">
                                    <i class="fa fa-arrow-circle-down"></i>
                                    <span class="badge">{$unEleve|count}</span>
                                </button> {else} &nbsp; {/if}
                        </td>
                        <td class="hidden-print">{$uneVisite.groupe}</td>
                        <td class="pop" data-toggle="popover" data-content="<img src='../photos/{$uneVisite.photo}.jpg' alt='{$uneVisite.matricule}' style='width:100px'>" data-html="true" data-container="body" data-original-title="{$uneVisite.photo}">
                            {$uneVisite.nom} {$uneVisite.prenom}
                        </td>
                        <td>Le {$date} à {$uneVisite.heure}</td>
                    </tr>
                    {assign var=n value=$n+1}
                    {/foreach}
                {/foreach}

            </tbody>
        </table>
        </div>
    {/foreach}
    {else}
        <p class="avertissement">Vous ne suivez actuellement aucun élève</p>
    {/if}
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $("*[title]").tooltip();

    })

</script>
