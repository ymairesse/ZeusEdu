<h4>Travaux en cours</h4>

<ul class="list-unstyled">
    {foreach from=$listeTravaux key=id item=unTravail}
        <div class = "input-group" data-idtravail="{$id}" >
            <span class = "input-group-addon danger btnDelete" style="cursor:pointer">
                <i class="fa fa-close"></i>
            </span>
            <button type="button" class="btn btn-default btn-block btnShowTravail" title="{$unTravail.titre}"
                    style="width: 20em; overflow: hidden;  text-overflow: ellipsis">
            {$unTravail.dateDebut|truncate:5:''} - {$unTravail.titre}
            </button>
            <span class = "input-group-addon success btnEdit" style="cursor:pointer">
                <i class="fa fa-edit"></i>
            </span>
        </div>
    {/foreach}
</ul>
