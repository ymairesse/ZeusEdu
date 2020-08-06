<h4>Travaux en cours <span class="badge badge-info pull-right">{$listeTravauxCours|@count|default:0}</span></h4>

<div id="listeTravaux" style="max-height:35em; overflow: auto">

    {if $listeTravauxCours == Null}

        <p>Rien actuellement</p>

    {else}

        <ul class="list-unstyled">
            {foreach from=$listeTravauxCours key=id item=unTravail}
            <div class="input-group" data-idtravail="{$id}">

                <span class="input-group-addon danger btnDelete" style="cursor:pointer">
                    <i class="fa fa-close"></i>
                </span>

                <button
                    type="button"
                    class="btn btn-default btn-block btnShowTravail{if $id == $idTravail} active{/if}"
                    title="{$unTravail.titre}"
                    style="overflow: hidden; text-overflow: ellipsis"
                    data-idtravail="{$id}">
                    {if $unTravail.statut == 'termine'}<i class="fa fa-star text-danger"></i>
                        {elseif $unTravail.statut == 'readwrite'}<i class="fa fa-star text-success"></i>
                        {elseif $unTravail.statut == 'readonly'}<i class="fa fa-star-half-empty text-warning"></i>
                        {elseif $unTravail.statut == 'hidden'}<i class="fa fa-star-o"></i>
                    {/if}

                    {$unTravail.dateDebut|truncate:5:''} - {$unTravail.titre}
                </button>

                <span class="input-group-addon success btnEdit" style="cursor:pointer">
                    <i class="fa fa-edit"></i>
                </span>

            </div>
            {/foreach}
        </ul>

    {/if}

</div>

<button type="button" class="btn btn-primary btn-block" id="btn-archive">Travaux archivés</button>
