<div class="panel-group" id="accordion">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">Vos sujets</a>
            </h4>
        </div>
        <div id="collapse1" class="panel-collapse collapse">
            <div class="panel-body">
                {foreach from=$sujetsAmoi key=idCategorie item=lesSujets}

                <div class="btn-group-vertical btn-block">

                    {foreach from=$lesSujets key=idSujet item=unSujet}

                        <button type="button" class="btn btn-info btn-block btn-sujet {$unSujet.userStatus} owner
                           {if $unSujet.forumActif == 1}forumActif{else}forumInactif{/if}" data-idsujet="{$idSujet}" data-sujet="{$unSujet.sujet}"
                            data-idcategorie="{$idCategorie}">
                            {if $unSujet.userStatus == 'profs'}
                            <i class="fa fa-mortar-board fa-2x pull-left"></i>
                            {else}
                            <i class="fa fa-user fa-2x pull-left"></i>
                            {/if}
                            <strong>[{$unSujet.libelle}]</strong> - {$unSujet.sujet}<br>{$unSujet.nomProf} le {$unSujet.ladate} à {$unSujet.heure}
                            {if $unSujet.fbLike == 1} <i class="fa fa-thumbs-o-up" title="Like autorisé"></i>{/if}
                        </button>

                    {/foreach}

                </div>
                {/foreach}
            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">Vos invitations</a>
            </h4>
        </div>
        <div id="collapse2" class="panel-collapse collapse">
            <div class="panel-body">
                {foreach from=$sujetsAbonnes key=idCategorie item=lesSujets}

                <div class="btn-group-vertical btn-block">

                    {foreach from=$lesSujets key=idSujet item=unSujet}
                        <button type="button" class="btn btn-info btn-block btn-sujet {$unSujet.userStatus}
                           {if $unSujet.forumActif == 1}forumActif{else}forumInactif{/if}"
                           data-idsujet="{$idSujet}"
                           data-sujet="{$unSujet.sujet}"
                            data-idcategorie="{$idCategorie}">
                            {if $unSujet.userStatus == 'profs'}
                            <i class="fa fa-mortar-board fa-2x pull-left"></i>
                            {else}
                            <i class="fa fa-user fa-2x pull-left"></i>
                            {/if}
                            <strong>[{$unSujet.libelle}]</strong> - {$unSujet.sujet}<br>{$unSujet.nomProf} le {$unSujet.ladate} à {$unSujet.heure}
                        </button>
                    {/foreach}

                </div>

                {/foreach}
            </div>
        </div>
    </div>

</div>
