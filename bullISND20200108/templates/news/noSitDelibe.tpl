{assign var=nbVide value=$listeDelibeVide|@count|default:0}

<h3>Cotes de délibération</h3>

{if $nbVide > 0}
    <div class="alert alert-danger">
        <p><i class="fa fa-exclamation-triangle"></i> Il vous reste à sélectionner des cotes de délibération pour les cours suivants:</p>
    </div>

        <ul>
        {foreach from=$listeDelibeVide key=coursGrp item=listeEleves}
            <li class="cours collapsible">{$coursGrp}: {$listeEleves|@count} cote(s) de délibération manquante(s)
                <ul style="display:none">
                {foreach from=$listeEleves key=matricule item=data}
                    <li>{$data.nom} {$data.prenom}</li>
                {/foreach}
                </ul>
            </li>
        {/foreach}
        </ul>
    {else}
    <div class="alert alert-info">
        <p><img src="images/peggynounou.gif" alt="yes">Bonne nouvelle. À ce stade, vous avez fourni toutes les cotes de délibération.</p>
    </div>
{/if}
