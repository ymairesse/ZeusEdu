<link href="css/filetree.css" type="text/css" rel="stylesheet">

{if $dir|@count > 0}

<div class="panel panel-default">

  <div class="panel-body" style="height:30em; overflow: auto;">

      <table class="table table-condensed">

          {foreach from=$dir item=file}
          <tr class="{$file.type}" data-filename="{$file.fileName}" data-type="{$file.type}">

              <td{if $file.type == 'file'} class="ext_{$file.ext}"{/if} style="width:32px">
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
                  <button
                      type="button"
                      class="btn btn-danger btn-xs pull-right delete"
                      data-filename="{$file.fileName}"
                      data-type="{$file.type}">
                      <i class="fa fa-times"></i>
                  </button>
              </td>

          </tr>
           {/foreach}

      </table>

  </div>
  <div class="panel-footer pull-right">{$dir|@count} fichers et dossiers</div>
</div>

{else}

    <p class="avertissement">Dossier vide</p>

{/if}
