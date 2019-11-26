<div class="container">

    {if isset($listeFlashInfos)}
        <div class="row">

            <div class="col-md-6 col-sm-12">
                <img  src="../images/logoPageVide.png" class="img-responsive img-center">
            </div>
            <div class="col-md-6 col-sm-12">
                {assign var=module value="presences"}
                {include file="$INSTALL_DIR/widgets/flashInfo/templates/index.tpl"}
            </div>

        </div>
        {else}
        	<img  src="../images/logoPageVide.png" class="img-responsive img-center">
    {/if}

</div>
