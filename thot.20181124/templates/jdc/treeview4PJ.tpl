{function name=repertoire level=0}
<ul class="filetree level{$level}" data-level="{$level}" {if ($level > 0)}style="display:none"{/if}>

    {foreach $data as $file}
        {if $file.type == 'folder'}
            <li class="folder expanded">
                <a href="javascript:void(0)"
                    class="dirLink"
                    data-dir="{if $level > 0}/{/if}{$file.path}/{$file.name}/"
                    data-nbfiles='{$file.items|@count}'>
                    {$file.name}
                </a>

                {repertoire data=$file.items level=$level+1}

            </li>
        {else}
            <li data-filename="{$file.name}"
                data-extension='{$file.ext}'
                data-path="{if $file.path[0] != '/'}/{/if}{$file.path}{if $file.path != '/'}/{/if}"
                data-size='{$file.size}'
                data-date='{$file.date}'
                class='file ext_{$file.ext} level{$level}'>
                <input type="checkbox" name="file[]" value="{$file.path}/{$file.name}" class="pull-right selectFile">
                <a class="fileName" href="javascript:void(0)">
                    {$file.name}
                </a>

            </li>
        {/if}
    {/foreach}
</ul>
{/function}

{repertoire data=$tree}
