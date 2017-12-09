<div class="panel day-highlight dh-{$travail.class}">

    <span id="delClass"></span>
    <div class="panel-heading">
        <h3 class="panel-title cat_{$travail.idCategorie}">{$travail.categorie} <span class="pull-right">
            {if $travail.type == 'cours'}
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
        <p><strong>Le {$travail.startDate|date_Format:'%A %d/%m/%Y'} à {$travail.heure} ({$travail.duree}) </strong></p>
        {if $travail.libelle != ''}
            <p>{$travail.libelle} {$travail.nbheures}h {if isset($travail.nomCours)}> {$travail.nomCours} {/if} [{$travail.destinataire}]</p>
        {/if}
        <p>Professeur <strong>{$travail.nom}</strong></p>
        <p>{$travail.title}</p>
        <div id="unEnonce">{$travail.enonce}</div>
    </div>

    {if $acronyme == $travail.proprietaire && ($editable|default:0 == 1)}
    <div class="panel-footer">
        <button type="button" class="btn btn-danger pull-left" data-id="{$travail.id}" id="delete"><i class="fa fa-eraser fa-lg"></i> Supprimer</button>
        <button type="button"
            class="btn btn-primary pull-right"
            data-id="{$travail.id}"
            data-destinataire="{$travail.destinataire}"
            id="modifier">
            <i class="fa fa-edit fa-lg"></i> Modifier
        </button>
        <div class="clearfix"></div>
    </div>
    {/if}

</div>
