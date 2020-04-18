{foreach from=$listeTypes key=type item=data name=types}
    <button type="button" title="{$data}" class="btn btn-xs memo{if isset($typesJDC.$type)} btn-primary{else} btn-danger{/if}">
        {$smarty.foreach.types.iteration}
    </button>
{/foreach}
