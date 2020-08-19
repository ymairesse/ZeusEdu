<input type="hidden" name="arborescence" id="arborescence" value="{$arborescence|default:'/'}">

{if $listeDirs == Null}
    <button type="button" class="btn btn-primary btn-sm btn-crumb" data-dir="/" data-dirorfile="dir">
        {$acronyme}
    </button>
{else}
    {foreach from=$listeDirs key=dir item=path}
        <button type="button" class="btn btn-primary btn-sm btn-crumb{if $dir == $directory} active{/if}" data-dir="/{$path}">
            {if $dir == ''}{$acronyme}{else}{$dir}{/if}
        </button>
    {/foreach}
{/if}
