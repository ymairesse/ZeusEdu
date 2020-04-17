<div style="height:45em; overflow:auto;">

<ul class="list-unstyled">

    {foreach from=$listeGhost key=wtf item=data}
    <li class="cat_{$data.idCategorie}" style="border-bottom: 1px solid grey;" title="{$data.destinataire}"><strong class="h4">{$data.jourSemaine}</strong>
        <br>{$data.statut} {$data.libelle} {$data.nbheures}h
        <br>{$data.startTime|truncate:5:''} - {$data.endTime|truncate:5:''}
    </li>
    {/foreach}
</ul>

</div>
