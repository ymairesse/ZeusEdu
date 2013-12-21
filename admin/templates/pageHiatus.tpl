<h3>Le fichier CSV pose problème pour les champs indiqués ci-dessous.</h3>

<div class="widget w50">
<h4>Champs figurant de le fichiers CSV et pas dans la base de données</h4>
    {if isset($hiatus[0])}
    <ul>
    {foreach from=$hiatus[0] item=unSouci}
    <li>{$unSouci}</li>
    {/foreach}
    </ul>
    {else}
    <p>Fausse alerte, tout va bien.</p>
    {/if}
</div>
<div class="widget w50">
<h4>Champs figurant dans la base de données et pas de le fichier CSV</h4>
    {if isset($hiatus[1])}
    <ul>
    {foreach from=$hiatus[1] item=unSouci}
    <li>{$unSouci}</li>
    {/foreach}
    </ul>
    {else}
    <p>Fausse alerte, tout va bien.</p>
    {/if}
</div>

<script type="text/javascript">
    {literal}
    $(document).ready(function(){

        $("#attention").hide();        
        })
    
    
    {/literal}
</script>