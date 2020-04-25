{if count($offre) == 0}
    Aucune remédiation
{else}
    {foreach from=$offre key=kidOffre item=uneOffre}

        <button type="button"
            class="btn
                {if isset($idOffre) && ($idOffre == $kidOffre)}btn-green{else}btn-primary{/if}
                {if $uneOffre.cache == 1} cache{/if}
                btn-block btn-showOffre pop"
            data-idOffre="{$kidOffre}"
            data-content="Détails de l'offre du {$uneOffre.date} à {$uneOffre.heure}"
            data-placement='bottom'
            data-container='body'
            data-html=false
            style="overflow: hidden; text-overflow: ellipsis">
            <div class="calendrier">
                <span class="jour">
                    {substr($uneOffre.date,0,2)}<br>
                </span>
                <span class="den">
                    {substr($uneOffre.date,3,2)}
                </span>
            </div>
             <span class="titreOffre">{$uneOffre.title}</span>

        </button>

    {/foreach}
{/if}

<script type="text/javascript">

    $(document).ready(function(){
        $(".pop").popover({
            trigger:'hover'
            });
    })

</script>
