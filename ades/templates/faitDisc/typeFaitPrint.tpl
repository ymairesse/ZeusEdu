{foreach from=$listeTypesFaits key=typeFait item=data}
    <input type="hidden" name="type_{$typeFait}" id="type_{$typeFait}" value="{$data.print}" class="printType">
{/foreach}
