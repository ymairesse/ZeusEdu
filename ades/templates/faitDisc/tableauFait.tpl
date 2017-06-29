<table class="table table-condensed">
    <thead>
        <tr>
            <th>&nbsp;</th>
            <th>Titre</th>
            <th>Couleurs</th>
            <th style="width:3em; text-align:center;" colspan="2">Ordre</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>

        {foreach $listeTypesFaits key=typeFait item=fait name=foo}
        {assign var=type value=$fait.type}
        <tr data-type="{$type}">
            <td>
                <button type="button" class="btn btn-danger btn-xs btn-delFait" data-type="{$type}" {if !in_array($type, $listeInutiles)} disabled {else} title="Supprimer ce fait" {/if}>
                <i class="fa fa-minus"></i>
            </button>
            </td>

            <td>
                <div class="titreFait" style="height: 2em;color:{$fait.couleurTexte}; background-color:{$fait.couleurFond}">{$fait.titreFait}</div>
            </td>
            <td><strong><pre style="width: 15em; color:{$fait.couleurTexte}; background-color:{$fait.couleurFond}">{$fait.couleurTexte} / {$fait.couleurFond}</pre></strong></td>
            <td style="width:1em">
                {if $smarty.foreach.foo.first} &nbsp; {else}
                <button type="button" class="btn btn-warning btn-xs btn-up" data-type="{$type}"><i class="fa fa-arrow-up"></i></button> {/if}
            </td>
            <td style="width:1em">
                {if $smarty.foreach.foo.last} &nbsp; {else}
                <button type="button" class="btn btn-warning btn-xs btn-down" data-type="{$type}"><i class="fa fa-arrow-down"></i></button> {/if}
            </td>
            <td>
                <button type="button"
                    class="btn btn-success btn-xs pull-right btn-edit"
                    data-type="{$type}">
                    <i class="fa fa-edit"></i>
                </button>
            </td>
        </tr>
        {/foreach}

    </tbody>
</table>
