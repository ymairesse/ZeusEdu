{assign var=nbVide value=$listeEchecNonCommentes|@count|default:0}

<h3>Commentaires des échecs</h3>

{if $nbVide > 0}
    <div class="alert alert-danger">
        <p><i class="fa fa-exclamation-triangle"></i> Il vous reste à commenter des échecs pour les cours suivants:</p>
    </div>

        <ul>
        {foreach from=$listeEchecNonCommentes key=coursGrp item=listeEleves}
            <li class="cours collapsible">{$coursGrp}: {$listeEleves|@count} commentaire(s) manquant(s)
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
        <p>Bonne nouvelle. À ce stade, vous avez commenté tous les échecs dans vos cours.</p>
    </div>
{/if}
