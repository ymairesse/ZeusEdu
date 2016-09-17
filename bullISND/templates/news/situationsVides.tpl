{assign var=nbVide value=$listeSituationsVides|@count|default:0}

<h3>Bulletins à compléter</h3>

{if $nbVide > 0}
    <div class="alert alert-danger">
        <p><i class="fa fa-exclamation-triangle"></i> Il vous reste des bulletins à compléter pour les cours suivants:</p>
    </div>

        <ul>
        {foreach from=$listeSituationsVides key=coursGrp item=listeEleves}
            <li class="cours collapsible">{$coursGrp}: {$listeEleves|@count} eleve(s)
                <ul style="display:none">
                {foreach from=$listeEleves key=matricule item=data}
                    <li>{$data.nom}</li>
                {/foreach}
                </ul>
            </li>
        {/foreach}
        </ul>
    {else}
    <div class="alert alert-info">
        <p>Bonne nouvelle. À ce stade, vous avez mis des cotes dans tous les bulletins.</p>
    </div>
{/if}
