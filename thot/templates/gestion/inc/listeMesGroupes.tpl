{foreach from=$listeMyGroups key=nomGroupe item=data}

<div class="input-group" data-nomgroupe="{$nomGroupe}">

    <span class="input-group-addon danger btnDelete" style="cursor:pointer" title="Suppression du groupe">
        <i class="fa fa-close"></i>
    </span>

    <button type="button"
            class="btn btn-primary btn-block btnEditGroupe"
            title="{$data.description}"
            data-nomgroupe="{$data.nomGroupe}"
            style="overflow: hidden; text-overflow: ellipsis">
        {$data.intitule}
    </button>

    <span class="input-group-addon success btnEditMembres"
        style="cursor:pointer"
        title="Gestion des membres"
        data-nomgroupe={$data.nomGroupe}>
        <i class="fa fa-users"></i>
    </span>

</div>

{/foreach}
