<div class="panel day-highlight dh-{$travail.class}">

    <span id="delClass"></span>
    <div class="panel-heading">
        <h3 class="panel-title cat_{$travail.idCategorie}">{$travail.categorie} <span class="pull-right">
            {if $travail.type == 'coursGrp'}
                <i class="fa fa-graduation-cap" title="Un cours"></i>
                {elseif $travail.type == 'classe'}
                <i class="fa fa-users" title="Une classe"></i>
                {elseif $travail.type == 'niveau'}
                <i class="fa fa-bars" title="Un niveau d'étude"></i>
                {elseif $travail.type == 'ecole'}
                <i class="fa fa-university" title="Toute l'école"></i>
                {elseif $travail.type == 'eleve'}
                <i class="fa fa-user" title="Un-e élève"></i>
            {/if}
        </span></h3>
    </div>

    <div class="panel-body">

        <p><strong>Le {$travail.startDate} à {$travail.heure} ({$travail.duree} min) </strong></p>
        {if isset($travail.libelle) && ($travail.libelle != '')}
            <p><strong>{$travail.libelle} {$travail.nbheures}h {if isset($travail.nomCours)}</strong> > {$travail.nomCours} {/if} [{$travail.destinataire}]</p>
            {elseif $travail.type == 'ecole'}
                <p><strong>À tous les élèves de l'école</strong></p>
            {elseif $travail.type == 'niveau'}
                <p><strong>À tous les élèves de {$travail.destinataire}e</strong></p>
            {elseif $travail.type == 'classe'}
                <p><strong>À tous les élèves de {$travail.destinataire}</strong></p>
            {elseif $travail.type == 'eleve'}
                <p><strong>À l'intention de cet élève</strong></p>
        {/if}
        <p>Professeur <strong>{$travail.profs}</strong></p>

        <h4>{$travail.title}</h4>
        <div id="unEnonce">{$travail.enonce}</div>

        <ul class="PjFiles list-unstyled">
            {foreach from=$listePJ key=shareId item=dataPJ}
            <li>
                {if $dataPJ.path != '/'}
                {$dataPJ.path|cat:'/'|cat:$dataPJ.fileName|truncate:20:'...'}
                {else}
                {$dataPJ.path|cat:$dataPJ.fileName|truncate:20:'...'}
                {/if}
            </li>
            {/foreach}
        </ul>
    </div>

    <div class="panel-footer">
        <p class="discret">Dernière modification {$travail.lastModif}</p>
        {if ($acronyme == $travail.proprietaire) && ($editable == true)}
            <div class="btn-group" {if isset($locked) && ($locked == "true")}title="Déverrouiller pour permettre les modifications"{/if}>
                <button
                    type="button"
                    class="btn btn-danger btn-edit"
                    data-id="{$travail.id}"
                    {if isset($locked) && ($locked == "true")} disabled{/if}
                    id="delete">
                    <i class="fa fa-eraser fa-lg"></i>
                        Supprimer
                </button>
                <button
                    type="button"
                    class="btn btn-info"
                    data-id="{$travail.id}"
                    id="btn-clone">
                    <i class="fa fa-copy"></i>
                        Cloner
                </button>
                <button
                    type="button"
                    class="btn btn-primary btn-edit"
                    data-id="{$travail.id}"
                    data-destinataire="{$travail.destinataire}"
                    data-type="{$travail.type}"
                    {if (isset($locked)) && ($locked == "true")} disabled{/if}
                    id="modifier">
                    <i class="fa fa-edit fa-lg"></i>
                        Modifier
                </button>
            </div>
            <div class="clearfix"></div>

        {/if}
        {if isset($locked) && ($locked == "true")}
            <p class="discret">Veuillez déverrouiller les périodes passées pour accéder à cet événement (bouton <i class="fa fa-lock"></i> du calendrier)</p>
        {/if}
    </div>

</div>
