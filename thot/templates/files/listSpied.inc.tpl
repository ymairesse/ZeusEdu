<div class="alert alert-danger">
    <i class="fa fa-eye fa-2x"></i> Supprimer le suivi de ce fichier
    {if $listeSpied[0].userName != ''}
    (<strong>les informations ci-dessous seront perdues</strong>)
    {/if}
    <button
        type="button"
        data-shareid="{$listeSpied[0].shareId}"
        class="btn btn-danger pull-right"
        id="btn-unspy">
        Confirmer la suppression
    </button>
</div>

{if $listeSpied[0].userName != ''}

    <div style="height:20em; overflow:auto">

        <table class="table table-condensed">
            <tr>
                <th>Nom d'utilisateur</th>
                {if $listeSpied.0.isDir == 1}
                    <th>Chemin</th>
                    <th>Nom du fichier</th>
                {/if}
                <th class="pull-right">Date du dernier accès</th>
            </tr>

            {foreach from=$listeSpied key=wtf item=dataSpy}
            <tr>
                <td>{$dataSpy.userName}</td>
                {if $listeSpied.0.isDir ==1}
                    <td>{$dataSpy.path}</td>
                    <td>{$dataSpy.fileName}</td>
                {/if}
                <td class="pull-right">{$dataSpy.date}</td>
            </tr>
            {/foreach}

        </table>

    </div>

{/if}
