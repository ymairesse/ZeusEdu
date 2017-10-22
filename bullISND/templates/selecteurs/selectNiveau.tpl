<div class="row">

    <strong>Année d'étude</strong>
    {foreach from=$listeNiveaux item=leNiveau}
        <button type="button" class="btn {if $leNiveau == $niveau}btn-primary{else}btn-default{/if} niveau" data-niveau="{$leNiveau}">{$leNiveau}</button>
    {/foreach}

    <div id="ajaxLoader" class="hidden">
        <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
    </div>

</div>
