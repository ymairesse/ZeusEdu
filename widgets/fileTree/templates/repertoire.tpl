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
            <input
                type="checkbox"
                name="cbFile[]"
                value="{$file.path}/{$file.name}"
                class="pull-right selectFile"
                data-path="{$file.path}"
                data-filename="{$file.name}">
            <a href="../widgets/fileTree/inc/download.php?type=pfN&f={$file.path}/{$file.name}">
                {$file.name}
            </a>
        </li>
    {/foreach}
{if $level > 0}
</ul>
{/if}
