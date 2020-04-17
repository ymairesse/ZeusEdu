<div class="panel panel-success">
    <div class="panel-heading">
        Groupes
        <span class="pull-right pop"
            style="color: #55f;"
            data-title="Pour supprimer"
            data-content="Clic sur <i class='fa fa-times' style='color:red'></i> pour effacer"
            data-placement="bottom"
            data-html=true>
        <i class="fa fa-info-circle fa-lg"></i></span>
    </div>

    <div class="panel-body" style="max-height:15em; overflow: auto;">
        {if isset($cibles)}
        {foreach from=$cibles key=type item=listeCibles}
        <ul class="list-group">
            {foreach from=$listeCibles key=cible item=sousGroupe}
            <li class="list-group-item"
                data-type="{$type}"
                data-cible="{$sousGroupe}"
                data-idoffre="{$idOffre}"
                style="padding: 4px 0px 8px 2px">
                {if $type == 'classe'}
                    Classe: {$sousGroupe}
                    {elseif $type == 'niveau'}
                    {$sousGroupe}e année
                    {elseif $type == 'coursGrp'}
                    Le cours {$sousGroupe}
                    {elseif $type == 'matiere'}
                    La branche {$sousGroupe}
                    {elseif $type == 'ecole'}
                    Tous les élèves
                {/if}

                <button type="button" class="btn btn-danger btn-xs pull-right btn-delCible"
                        title="Supprimer cette offre">
                        <i class="fa fa-times"></i>
                </button>
            </li>
            {/foreach}
        </ul>
        {/foreach}
        {else}
        <p class="important">Aucune inscription possible sur Thot</p>
        {/if}
    </div>
    <div class="panel-footer">
        <button type="button" class="btn btn-success btn-sm btn-block" id="btn-addCible" data-idoffre="{$idOffre|default:''}"{if !(isset($idOffre))} disabled{/if}>Ouvrir à des groupes <i class="fa fa-users"></i></button>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $(".pop").popover({
            trigger:'hover'
            });
    })

</script>
