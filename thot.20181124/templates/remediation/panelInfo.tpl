<div class="panel panel-info">
    <div class="panel-heading">
        [{$offre.acronyme}] {$offre.title|truncate:30}
    </div>
    <div class="panel-body">
        <div class="calendrier" style="font-size:130%">
            <span class="jour">
                {substr($offre.startDate,0,2)}<br>
            </span>
            <span class="den">
                {substr($offre.startDate,3,2)}
            </span>
        </div>
        {$offre.heure} - {$offre.duree}min<br>
        {$offre.contenu|truncate:50:'...'}
    </div>
</div>
