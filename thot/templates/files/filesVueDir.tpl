

    {foreach from=$dir item=file}

    {if $file.type == 'file'}
    <div>
        <div class="file" data-class="{$file.type} ext_{$file.ext}" data-filename="{$file.fileName}" data-type="{$file.type}">
            <span>{$file.fileName}<br>{$file.size}</span>
        </div>
    </div>
    {else}
        <div class="">
            <a title="{$file.fileName}" href="javascript:void(0)" class="directory" data-dir="{$file.fileName}">{$file.fileName}</a>
        </div>
    {/if}


     {/foreach}
