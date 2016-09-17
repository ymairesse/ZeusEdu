{if $listFiles != array()}

<ul class="list-unstyled">
    {foreach from=$listFiles item=file}
    <li>
        {if $file.type == 'folder'}
            <strong class='text-danger'><i class='fa fa-folder-open-o fa-lg'></i> {$file.name} (contient {$file.items|@count} fichier(s))</strong>
        {else}
            <strong class='text-warning'><i class='fa fa-file-o'></i> {$file.name}</strong>
        {/if}
    </li>
    {/foreach}
</ul>

{/if}
