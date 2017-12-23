<button class="btn btn-success btn-sm btn-block"
    type="button"
    id="cleaner">
    Nettoyer les infobulles <i class="fa fa-trash fa-2x"></i>
</button>

<ul class="list-unstyled">
{foreach from=$listeEleves key=matricule item=eleve}

    <li>
        <button
            class="btn btn-default btn-sm btn-block btn-eleve pop"
            type="button"
            {if isset($listeRV.$matricule)}
                {assign var=popup value="<ul class='list-unstyled'>"}
                {foreach from=$listeRV.$matricule key=heure item=data}
                    {assign var=popup value=$popup|cat:'<li>'|cat:$heure|cat:' '}
                    {assign var=popup value=$popup|cat:$data.nom|cat:' '|cat:$data.prenom|cat:' ['|cat:$data.acronyme|cat:']'|cat:'</li>'}
                {/foreach}
                {assign var=popup value=$popup|cat:'</ul>'}
                {else}
                    {assign var=popup value="<p>Aucun rendez-vous</p>"}
            {/if}
            data-toggle="popover"
            data-content="{$popup}"
            data-html="true"
            data-placement="bottom"
            data-container="body"
            data-title="RV pour {$eleve.prenom} {$eleve.nom} <a href='#' class='close' data-dismiss='alert'>&times;</a>"
            data-matricule="{$matricule}">

            <span class="badge pull-left">{$listeRV.$matricule|count|default:'0'}</span>
            {$eleve.nom} {$eleve.prenom}
        </button>

    </li>

{/foreach}
</ul>


<script type="text/javascript">

$(document).ready(function(){

    $(".pop").popover();

    // pour pouvoir fermer un popover généré après la création de la page
    $(".document").on('click','.close', function(){
        $(this).parents(".popover").popover('hide');
    })

    $("#cleaner").click(function(){
        $(".popover").hide();
    })

})

</script>
