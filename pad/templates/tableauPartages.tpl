<table class="table table-hover table-condensed">
<tr>
    <th style="width:30%">Nom</th>
    <th>Partages</th>
    <th style="width:2em;">
        <button type="button"
            class="btn btn-success btn-xs pull-right"
            id="btn-shareAll"
            title="Partage de tous ces blocs-notes">
        <i class="fa fa-plus"></i> Tous
        </button>
    </th>
</tr>
{foreach from=$listeEleves key=matricule item=eleve}
<tr data-matricule="{$matricule}">
    <td title="{$matricule}" data-container="body">
        {$eleve.classe} {$eleve.nom} {$eleve.prenom}
        <input type="hidden" name="matricule[]" value="{$matricule}" class="matricule">
    </td>
    <td>
        {if isset($listePartages[$matricule])}
            {assign var=lesPartages value=$listePartages[$matricule]}
            {foreach from=$lesPartages key=guest item=data}
                <button type="button" class ="btn btn-xs {$data.mode} btn-partage"
                    data-matricule="{$matricule}"
                    data-guest="{$guest}"
                    data-id="{$data.id}"
                    data-mode="{$data.mode}"
                    title="{$listeProfs.$guest.prenom|default:''} {$listeProfs.$guest.nom|default:''}">
                    {$guest}
                </button>

            {/foreach}
        {else}
        &nbsp;
        {/if}
     </td>
     <td>
         <button type="button"
            class="btn btn-warning btn-xs pull-right btn-addShare"
            data-id="{$data.id|default:Null}"
            data-matricule="{$matricule}"
            title="Partage de ce bloc-note">
            <i class="fa fa-plus"></i>
        </button>
     </td>
</tr>
{/foreach}

</table>
