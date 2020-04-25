{if $level > 0}
<ul class="filetree level{$level}" data-level="{$level}">
{/if}
    {foreach from=$filesList.files item=file}
        <li data-filename="{$file.name}"
            data-extension='{$file.ext}'
            data-path="{$file.path}"
            data-size='{$file.size}'
            data-date='{$file.date}'
            class='file ext_{$file.ext} level{$level}'>
            <input type="checkbox" name="file[]" value="{$file.path}/{$file.name}" class="pull-right selectFile">
            <a class="fileName" href="javascript:void(0)">
                {$file.name}
            </a>
        </li>
    {/foreach}
{if $level > 0}
</ul>
{/if}
