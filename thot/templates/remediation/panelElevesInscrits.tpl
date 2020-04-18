<div class="panel panel-success">
    <div class="panel-heading">
        Élèves inscrits <span class="badge">{$listeEleves|@count|default:""}</span>
            <span class="pull-right pop"
                style="color: #55f;"
                data-title="Pour supprimer"
                data-content="Clic sur <i class='fa fa-times' style='color:red'></i> pour effacer<br>Ctrl+clic pour supprimer sans confirmer"
                data-placement="bottom"
                data-html=true>
            <i class="fa fa-info-circle fa-lg"></i></span>
    </div>

    <div class="panel-body" id="panelEleves" style="max-height:15em; overflow: auto;">

        {if isset($listeEleves) && ($listeEleves|@count > 0)}
            <ul class="list-group">
                {foreach from=$listeEleves key=matricule item=data}
                    <li class="list-group-item {$data.presence}" style="padding: 4px 0px 8px 2px">
                        {if $data.obligatoire == 0}<i class="fa fa-user" title="Inscription libre"></i>
                            {else}<i class="fa fa-mortar-board" title="Inscription par le prof"></i>
                        {/if}
                        {$data.groupe|cat:' '|cat:' '|cat:$data.nom|cat:' '|cat:$data.prenom|truncate:25:'...'}
                        <button
                            type="button"
                            class="btn btn-danger btn-xs pull-right btn-delEleve"
                            data-idOffre="{$idOffre}"
                            data-matricule="{$matricule}">
                            <i class="fa fa-times"></i>
                        </button>
                    </li>
                {/foreach}
            </ul>
            {else}
            Aucune inscription
        {/if}

    </div>

    <div class="panel-footer">
        <button type="button" class="btn btn-success btn-sm btn-block" id="btn-addEleve" data-idoffre="{$idOffre|default:''}"{if !(isset($idOffre))} disabled{/if}>Inscrire des élèves <i class="fa fa-user"></i></button>
        <button type="button" class="btn btn-primary btn-sm btn-block" id="btn-presences" data-idoffre="{$idOffre|default:''}"{if !(isset($idOffre)) || $listeEleves|@count == 0} disabled{/if}>Prise de présences <img src="images/presencesIco.png"></button>
    </div>

</div>


<script type="text/javascript">

    $(document).ready(function(){
        $(".pop").popover({
            trigger:'hover'
            });
    })

</script>
