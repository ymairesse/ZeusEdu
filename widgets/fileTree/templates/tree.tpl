{function name=repertoire level=0}

<ul class="filetree level{$level}" data-level="{$level}" {if ($level > 0)}style="display:none"{/if}>

    {foreach $data as $file}
        {if $file.type == 'folder'}
            <li class="folder expanded">
                <a href="javascript:void(0)"
                    class="dirLink"
                    data-path="{$file.path|escape:'htmlall'}"
                    data-nbfiles='{$file.items|@count}'>
                    {$file.fileName}
                </a>

                {repertoire data=$file.items level=$level+1}

            </li>
        {else}
            <li data-extension='{$file.ext}'
                data-path="{$file.path|escape:'htmlall'}"
                data-filename="{$file.fileName|escape:'htmlall'}"
                data-size='{$file.size}'
                data-date='{$file.date}'
                class='file ext_{$file.ext} level{$level}'>
                <a href="../widgets/fileTree/inc/download.php?type=pfN&f={$file.path}/{$file.fileName}">
                    {$file.fileName|escape:'htmlall'}
                </a>
                <input
                    type="checkbox"
                    name="cbFile[]"
                    value="{$file.path}{$file.fileName}"
                    data-path="{$file.path|escape:'htmlall'}"
                    data-filename="{$file.fileName|escape:'htmlall'}"
                    class="pull-right selectFile"
                    {if isset($file.selected) && ($file.selected == true)} checked{/if}>
            </li>
        {/if}
    {/foreach}
</ul>

{/function}

{repertoire data=$tree}
