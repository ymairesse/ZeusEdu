<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="panel panel-default">

    <div class="panel-body" style="height:30em; overflow: auto;">

        {if $dir|@count > 0}

        <table class="table table-condensed">

            {foreach from=$dir item=file}
            <tr class="{$file.type}" data-filename="{$file.fileName}" data-dirorfile="{$file.type}">

                <td {if $file.type=='file' } class="ext_{$file.ext}" {/if} style="width:32px">
                    {if $file.type == 'dir'}<i class="fa fa-folder-open-o"></i>{/if}
                </td>
                <td>{if $file.type == 'file'}
                    <a title="{$file.fileName}" href="inc/download.php?type=pfN&amp;f={$arborescence}/{if $directory != ''}{$directory}/{/if}{$file.fileName}">
                        {$file.fileName|truncate:30:'...'}
                    </a>
                    {/if}

                    {if $file.type == 'dir'}
                    <a title="{$file.fileName}" href="javascript:void(0)" class="directory" data-dir="{$file.fileName}">{$file.fileName}</a>
                    {/if}
                </td>
                <td>{$file.dateTime}</td>
                <td>{if $file.type == 'file'}{$file.size}{else}-{/if}</td>
                <td>
                    <button type="button" class="btn btn-danger btn-xs pull-right delete"
                        data-filename="{$file.fileName}"
                        data-type="{$file.type}"
                        data-dirorfile="{$file.type}">
                        <i class="fa fa-times"></i>
                    </button>
                </td>

            </tr>
            {/foreach}

        </table>
        {else}
        <p class="avertissement">Dossier vide</p>
        {/if}

    </div>

    <div class="panel-footer pull-right">
        <p><button type="button" class="btn btn-danger btn-xs" title="Créer un dossier"><i class="fa fa-plus"></i> <i class="fa fa-folder-open-o"></i></button> Activer ce bouton pour créer un sous-dossier dans votre répertoire de fichiers. On peut créer,
            sans limite, des sous-dossiers dans un sous-dossier.</p>
        <p><button type="button" class="btn btn-info btn-xs" title="Ajouter un document"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></button> Activer ce bouton pour déposer des nouveaux documents dans votre répertoire de fichiers. Chaque
            nouveau document est déposé dans le sous-dossier actif.</p>
        <p><button type="button" class="btn btn-danger btn-xs"><i class="fa fa-times"></i></button> Pour supprimer le fichier ou le sous-dossier correspondant. Une confirmation est toujours demandée. L'effacement d'un répertoire provoque la
            suppression en cascade de tous les fichiers et sous-dossiers contenus.</p>

    </div>

</div>
