<input type="hidden" name="arborescence" id="arborescence" value="{$arborescence|default:''}">

{if $listeDirs == Null}
    <button type="button" class="btn btn-primary btn-sm btn-crumb" data-dir="" data-dirorfile="dir">
        {$acronyme}
    </button>
{else}
    {foreach from=$listeDirs key=dir item=path}
        <button type="button" class="btn btn-primary btn-sm btn-crumb{if $dir == $directory} active{/if}" data-dir="/{$path}">
            {if $dir == ''}{$acronyme}{else}{$dir}{/if}
        </button>
    {/foreach}
{/if}

<div class="btn-group pull-right">
    <button type="button" class="btn btn-danger btn-xs" id="btn-mkdir" title="Créer un dossier"><i class="fa fa-plus"></i> <i class="fa fa-folder-open-o"></i></button>
    <button type="button" class="btn btn-info btn-xs" id="btn-upload" title="Ajouter un document"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></button>
</div>
