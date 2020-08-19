<div id="fichiersListe">

    <table class="table table-condensed">
        <tr>
            <th>&nbsp;</th>
            <th>Nom du fichier</th>
            <th>Date d'enregistrement</th>
            <th>Taille</th>
        </tr>

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
        </tr>
        {/foreach}

    </table>

</div>
