<table class="table table-condensed">
    {if isset($listeMesGroupes.proprio)}
        <tr>
            <td colspan="3">Propriétaire de</td>
        </tr>

        {foreach from=$listeMesGroupes['proprio'] key=name item=data}
            <tr data-groupe="{$name}" class="groupe {$data.type}">
                <td style="width:1em" title="{$data.proprio}" data-container="body">
                    {if $data.proprio == $acronyme}
                    <i class="fa fa-user-circle"></i>
                    {else}
                    <i class="fa fa-user"></i>
                    {/if}
                </td>
                <td>
                    <button type="button" class="btn btn-default btn-xs btn-block {$data.type} btn-groupe">{$data.intitule}</button>
                </td>
                <td style="width:2em;">
                    {if $data.type == 'ferme'}
                        <i class="fa fa-lock" title="Groupe fermé"></i>
                        {elseif $data.type == 'ouvert'}
                        <i class="fa fa-unlock" title="Groupe ouvert"></i>
                        {elseif $data.type == 'invitation'}
                        <i class="fa fa-id-card" title="Groupe sur invitation"></i>
                    {/if}
                </td>
            </tr>
        {/foreach}
    {/if}
    {if isset($listeMesGroupes.membre)}
        <tr>
            <td colspan="3">Membre de</td>
        </tr>
        {foreach from=$listeMesGroupes['membre'] key=name item=data}
            <tr data-groupe="{$name}" class="groupe {$data.type}">
                <td style="width:1em" title="{$data.proprio}" data-container="body">
                    {if $data.proprio == $acronyme}
                    <i class="fa fa-user-circle"></i>
                    {else}
                    <i class="fa fa-user"></i>
                    {/if}
                </td>
                <td>
                    <button type="button" class="btn btn-default btn-xs btn-block {$data.type} btn-groupe">{$data.intitule}</button>
                </td>
                <td style="width:2em;">
                    {if $data.type == 'ferme'}
                        <i class="fa fa-lock" title="Groupe fermé"></i>
                        {elseif $data.type == 'ouvert'}
                        <i class="fa fa-unlock" title="Groupe ouvert"></i>
                        {elseif $data.type == 'invitation'}
                        <i class="fa fa-id-card" title="Groupe sur invitation"></i>
                    {/if}
                </td>
            </tr>
        {/foreach}
    {/if}
</table>
