{foreach from=$boutons key=index item=data}
    <button type="button" class="btn {if $index==$indice}btn-success{else}btn-primary{/if}{if $data != '...'} indice{/if}" data-indice="{$data}" data-table="{$table}">{$data}</button>
{/foreach}
