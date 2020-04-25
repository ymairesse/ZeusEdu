{function name=repertoire level=0}
<ul class="filetree level{$level}" {if ($level > 0)}style="display:none"{/if}>

    {foreach $data as $file}
        {if $file.type == 'folder'}
            <li class="folder expanded{if $file.shared == 1} shared{/if}">
                <span class="delDir pull-right text-danger">&nbsp;<i class="fa fa-times"></i></span>
                <a href="javascript:void(0)"
                    class="dirLink"
                    data-dir="{if $level > 0}/{/if}{$file.path|escape:'htmlall'}/{$file.name|escape:'htmlall'}/"
                    data-nbfiles='{$file.items|@count}'>
                    {$file.name}
                </a>

                {repertoire data=$file.items level=$level+1}

            </li>
        {else}
            <li data-filename="{$file.name|escape:'htmlall'}"
                data-extension='{$file.ext}'
                data-path="/{$file.path|escape:'htmlall'}"
                data-size='{$file.size}'
                data-date='{$file.date}'
                class='file ext_{$file.ext} level{$level}{if $file.shared == 1} shared{/if}'>
                <span class="delFile pull-right">&nbsp;<i class="fa fa-times text-danger"></i></span>
                <a href="inc/download.php?type=pfN&amp;f={if $level > 0}/{/if}{$file.path|escape:'htmlall'}/{$file.name|escape:'htmlall'}">
                    {$file.name|escape:'htmlall'} {$file.date} {$file.size}
                </a>

            </li>
        {/if}
    {/foreach}
</ul>
{/function}

<ul class="filetree level0">
    <li class="folder expanded">
        <a class="dirLink{if $file.shared == 1} shared{/if}" href="javascript:void(0)" data-dir="/" data-nbfiles={$tree|@count|default:0}>/</a>
    </li>
</ul>

{repertoire data=$tree}
