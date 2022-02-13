{if !(isset($niveau))}
    <p class="avertissement">Veuillez choisir un niveau d'étude</p>
{else}

    <ul class="nav nav-tabs">
        {foreach from=$listePeriodes item=unePeriode}
        <li{if $unePeriode == $periode} class="active"{/if} data-periode="{$unePeriode}">
            <a data-toggle="tab"
                class="tab-pane{if $unePeriode == $periode} fade in active{/if}"
                href="#periode_{$unePeriode}"
                data-periode="{$unePeriode}">
                Période {$unePeriode}
            </a>
        </li>
        {/foreach}
    </ul>

    <div class="tab-content">
        {foreach from=$listePeriodes item=unePeriode}
            <div id="periode_{$unePeriode}" class="tab-pane fade{if $unePeriode == $periode} in active{/if}">

                <table class="table table-condensed">
                    <tr>
                        <th style="width:2em;">&nbsp;</th>
                        <th>Classe</th>
                        <th>Fichier</th>
                        <th>Taille</th>
                        <th>Date</th>
                    </tr>
                    {foreach from=$listeClasses item=classe}
                    <tr>
                        <th>
                            <button title="Régénérer pour la classe"
                                class="btn btn-info btn-block btn-refreshClasse btn-sm"
                                type="button"
                                data-classe="{$classe}"
                                data-periode={$unePeriode}>
                                    <i class="fa fa-refresh"></i>
                            </button>
                        </th>
                        <th>{$classe}</th>
                        <td data-classe="{$classe}" data-periode="{$unePeriode}" class="fileName">
                            <a href="archives/{$ANNEESCOLAIRE}/{$unePeriode}/{$directory.$unePeriode.$classe.fileName}">{$directory.$unePeriode.$classe.fileName}</a></td>
                        <td data-classe="{$classe}" data-periode="{$unePeriode}" class="fileSize">{$directory.$unePeriode.$classe.size}</td>
                        <td  data-classe="{$classe}" data-periode="{$unePeriode}" class="fileTime">{$directory.$unePeriode.$classe.dateTime}</td>
                    </tr>
                    {/foreach}

                </table>

            </div>
        {/foreach}

    </div>

{/if}
