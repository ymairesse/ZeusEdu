<h2>Partage: {$titre}</h2>

{if $listeShares == Null}
    <p class="avertissement">Aucun partage pour "{$titre}"</p>
    {else}

<table class="table table-condensed">
    <thead>
        <tr>
            <th style="width:2em">&nbsp;</th>
            <th>Chemin</th>
            <th>Nom du fichier</th>
            <th style="width:1em">&nbsp;</th>
            <th>Commentaire</th>
            <th>Partagé avec</th>
            <th style="width:2em">&nbsp;</th>
        </tr>
    </thead>

    <tbody>
    {foreach from=$listeShares key=shareId item=file}
    <tr data-shareid="{$shareId}">
        <td>
            <button
                type="button"
                title="Placer/retirer un espion"
                class="btn btn-xs {if isset ($spiedSharesList4type.$shareId)}btn-info btn-showSpy{else}btn-default btn-spy{/if}" data-shareid="{$shareId}">
                <i class="fa fa-eye"></i>
            </button>
        </td>

        <td>
            {if $file.dirOrFile == 'dir'}
                <button
                    type="button"
                    class="btn btn-primary btn-xs btnFolder"
                    data-shareid="{$shareId}"
                    data-commentaire="{$file.path}{if $file.path != '/'}/{/if}{$file.fileName}">
                    <i class="fa fa-folder-open text-danger"></i>
                    {$file.path}
                </button>
            {else}
                {$file.path}
            {/if}
        </td>

        <td>
            {if $file.dirOrFile == 'file'}
                <i class="fa fa-file text-info"></i>
                <a href="inc/download.php?type=pfN&amp;f={$file.path}/{$file.fileName}">{$file.fileName}</a>
                {else}
                <span class="help-block">Tout le dossier</span>
            {/if}
        </td>

        <td>
            <button type="button" title="Modifier ce partage" class="btn btn-success btn-xs shareEdit" data-shareid="{$shareId}">
                <i class="fa fa-edit"></i>
            </button>
        </td>


        <td class="commentaire">{$file.commentaire}</td>

        <td>
            {$file.partageAvec}
        </td>

        <td>
            <button
                type="button"
                class="btn btn-danger btn-xs unShare"
                data-fileid="{$file.fileId}"
                data-shareId="{$file.shareId}"
                data-filename="{$file.fileName}"
                title="Arrêter le partage">
                <i class="fa fa-share-alt"></i>
            </button>
        </td>

    </tr>
    {/foreach}
    </tbody>

</table>

{/if}
