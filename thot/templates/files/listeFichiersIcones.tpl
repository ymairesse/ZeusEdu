<div id="fichiersIcones">

{foreach from=$dir item=oneFile}

{if $oneFile.type == 'dir'}

    <div class="conteneur"
        title="{$oneFile.fileName}"
        data-dirorfile="dir"
        data-filename="{$oneFile.fileName}">

        <div class="folderImage"></div>

        <div class="fileName" data-dirorfile='dir'>
            <i class="fa fa-play" style="font-size:6pt"></i> {$oneFile.fileName|truncate:20:'...'}
        </div>
    </div>

{else}

    <div class="conteneur"
        title="{$oneFile.fileName}"
        data-dirorfile="file"
        data-filename="{$oneFile.fileName}">

        <div class="fileImage ext_{$oneFile.ext}" style="display:block;"></div>

        <a href="inc/download.php?type=pfN&amp;f={$arborescence}/{if $directory != ""}{$directory}/{/if}{$oneFile.fileName}">

            <div class="fileName" data-dirorfile='file'>
                {$oneFile.fileName|truncate:20:'...'}<br>
                {$oneFile.size}
            </div>
        </a>
    </div>
{/if}

{/foreach}

</div>
