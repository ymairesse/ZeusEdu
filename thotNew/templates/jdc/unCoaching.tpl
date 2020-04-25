{if $travail == Null}
    Cette rencontre a été supprimée.
{else}
<div class="panel day-highlight">

    <div class="panel-heading">
        <h3 class="panel-title">Soutien scolaire</h3>
    </div>

    <div class="panel-body">
        <p><strong>Le {$travail.date} à {$travail.heure} ({$travail.duree|truncate:5:''} min) </strong></p>

        <p>Travail avec <strong>{$travail.nomProf}</strong> </p>

    </div>

</div>

{/if}
