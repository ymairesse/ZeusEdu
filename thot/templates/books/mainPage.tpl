    <div class="row">
        <div id="icones">
            {if isset($icones) && $userStatus == 'admin'}
                {include file="$icones.tpl"}
            {/if}
        </div>

        <div id="searchBar">
            {if isset($searchBar)}
                {include file="$searchBar.tpl"}
            {/if}
        </div>

        <div id="formulaire">
            {if isset($formulaire)}
                {include file="$formulaire.tpl"}
            {/if}
        </div>
    </div>

    <div id="ajaxLoader" class="hidden">
        <img src="images/ajax-loader.gif" alt="loading" class="center-block">
    </div>

<script type="text/javascript">

    $(document).ready(function(){
        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });
    })

</script>
