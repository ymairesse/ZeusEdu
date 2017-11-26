<div class="container">

    {if $userStatus == 'admin'}
    	<button type="button" class="btn btn-primary pull-right" id="btn-newNews">Nouvelle annonce</button>
    {/if}

    {if isset($listeFlashInfos)}
        <div class="row">

            <div class="col-md-6 col-sm-12">
                <img  src="../images/logoPageVide.png" class="img-responsive img-center">
            </div>
            <div class="col-md-6 col-sm-12">
                {include file="flashInfo/listeAnnonces.tpl"}
            </div>

        </div>
        {else}
        	<img  src="../images/logoPageVide.png" class="img-responsive img-center">
    {/if}

</div>
