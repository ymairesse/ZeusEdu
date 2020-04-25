{foreach from=$listeMyGroups key=nomGroupe item=data}

<div class="input-group" data-nomgroupe="{$nomGroupe}">

    {if $data.statut == 'proprio'}
    <span class="input-group-addon danger btnDeleteGroupe" style="cursor:pointer" title="Suppression du groupe">
        <i class="fa fa-close"></i>
    </span>
        {else}
        <span class="input-group-addon">
            <i class="fa fa-lock"></i>
        </span>
    {/if}

    {if ($data.statut == 'proprio') || ($data.statut == 'admin')}
        <button type="button"
                class="btn btn-primary btn-block btnEditGroupe"
                title="{$data.nomGroupe}"
                data-nomgroupe="{$data.nomGroupe}"
                style="overflow: hidden; text-overflow: ellipsis">
            <i class="fa fa-star"></i> {$data.intitule}
        </button>
    {else}
        <button type="button"
                class="btn btn-primary btn-block btnNotEditGroupe"
                title="{$data.nomGroupe}"
                style="overflow:hidden; text-overflow: ellipsis">
            {$data.intitule}
         </button>
    {/if}

    {if ($data.statut == 'proprio') || ($data.statut == 'administrateur')}
        <span class="input-group-addon success btnEditMembres"
            style="cursor:pointer; width:3em;"
            title="Gestion des membres"
            data-nomgroupe={$data.nomGroupe}>
            <i class="fa fa-users"></i>
        </span>
    {else}
        <span class="input-group-addon info btnViewMembres"
            data-nomgroupe={$data.nomGroupe}
            style="width:3em">
            <i class="fa fa-users"></i>
        </span>
    {/if}

</div>

{/foreach}
