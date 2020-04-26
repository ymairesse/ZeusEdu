<h4>Vos sujets</h4>

{foreach from=$sujetsAmoi key=idCategorie item=lesSujets}

    <div class="btn-group-vertical btn-block">

    {foreach from=$lesSujets key=idSujet item=unSujet}

            <button type="button"
                class="btn btn-info btn-block btn-sujet {$unSujet.userStatus}"
                data-idsujet="{$idSujet}"
                data-sujet="{$unSujet.sujet}"
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

<h4>Vos abonnements</h4>

{foreach from=$sujetsAbonnes key=idCategorie item=lesSujets}

    <div class="btn-group-vertical btn-block">

    {foreach from=$lesSujets key=idSujet item=unSujet}
        <button type="button"
            class="btn btn-info btn-block btn-sujet {$unSujet.userStatus}"
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
