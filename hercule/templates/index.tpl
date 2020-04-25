<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{$titre}</title>

        {include file='../../javascript.js'}
        {include file='../../styles.sty'}

    </head>
    <body>

        {include file="menu.tpl"}
        <div class="container-fluid">

            {if isset($selecteur)}
                {include file="$selecteur.tpl"}
            {/if}

        </div>

        <img src="../images/bigwait.gif" id="wait" style="display:none" alt="wait">

        <div id="corpsPage">
            {if isset($corpsPage)}
            	{include file="$corpsPage.tpl"}
            {else}
            	{include file="../../templates/corpsPageVide.tpl"}
            {/if}
        </div>

        {include file="../../templates/footer.tpl"}

    </body>
</html>
