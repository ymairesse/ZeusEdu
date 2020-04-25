<div class="panel day-highlight dh-{$travail.class}">
    <span id="delClass"></span>
    <div class="panel-heading">
        <h3 class="panel-title cat_{$travail.idCategorie}">{$travail.categorie}</h3>
    </div>

    <div class="panel-body">
        <p>Professeur
            <strong>{$travail.nom}</strong>
        </p>
        {if $travail.libelle != ''}
        <p>{$travail.libelle} {$travail.nbheures}h {if isset($travail.nomCours)}> {$travail.nomCours} {/if} [{$travail.destinataire}]</p>
        {/if}
        <p>{$travail.title}:
            <strong>Le {$travail.startDate} à {$travail.heure} ({$travail.duree}) </strong>
        </p>
        <div id="unEnonce">{$travail.enonce}</div>
    </div>

</div>
