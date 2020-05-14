<table class="table table-striped table-condensed table-hover">
    <thead>
        <tr>
        <th>Nom</th>
        <th>Statut</th>
        <th>&nbsp;</th>
        </tr>
    </thead>
{foreach from=$usersList key=cetAcronyme item=user}
    <tr data-acronyme="{$cetAcronyme}" data-nom="{$user.nomPrenom} [{$cetAcronyme}]">
        <td>{$user.nomPrenom} [{$cetAcronyme}]</td>
        <td>
            {if $cetAcronyme != $acronyme}
            {* il n'est pas possible de changer son propre statut: précaution!! *}

            <select name="statut" class="statut form-control" title="Modifier le statut de l'utilisateur">
                {foreach from=$listeStatuts key=status item=statut}
                <option value="{$status}"{if $status == $user.status} selected="selected"{/if}>{$statut}</option>
                {/foreach}
            </select>

            {else}
            <span class="alert-warning">Vous ne pouvez pas modifier votre propre statut</span>
            {/if}
        </td>
        <td>
            {if $cetAcronyme != $acronyme}
            {* il n'est pas possible de changer son propre statut: précaution!! *}
            <button type="button" class="btn btn-default btn-sm pull-right btn-delUser" title="Supprimer cet utilisateur">
                <i class="fa fa-times" style="color:red"></i>
            </button>
            {else}
                &nbsp;
            {/if}
        </td>
    </tr>
{/foreach}
</table>
