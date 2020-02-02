{foreach from=$boutons key=index item=data}
    <button type="button" class="btn btn-primary{if $data != '...'} indice{/if}" data-indice="{$data}" data-table="{$table}">{$data}</button>
{/foreach}
