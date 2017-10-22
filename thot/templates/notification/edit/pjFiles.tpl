{if isset($pjFiles)}
    {foreach from=$pjFiles item=file}
        {$file|print_r}
    {/foreach}

{/if}
