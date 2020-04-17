<p>Vos sujets</p>

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
            {$unSujet.sujet}<br>{$unSujet.nomProf} le {$unSujet.ladate} à {$unSujet.heure}
        </button>
    {/foreach}

    </div>

{/foreach}

<p>Vos abonnements</p>

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
            {$unSujet.sujet}<br>{$unSujet.nomProf} le {$unSujet.ladate} à {$unSujet.heure}
        </button>
    {/foreach}

    </div>

{/foreach}
