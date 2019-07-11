<div class="eleve" data-matricule="{$matricule}" data-date="{$date}" data-heure="{$heure}" data-periode="{$periode}" data-photo="{$photo}" data-nomeleve="{$nomEleve}" style="float:left;">
    <input type="hidden" name="matricule[]" value="{$matricule}">
    <input type="hidden" name="heure[]" value="{$heure}">
    <input type="hidden" name="periode[]" value="{$periode}">
    <input type="hidden" name="date[]" value="{$date}">
    <span class="editRetard">
    <button type="button" class="btn btn-success btn-xs btn-block"><i class="fa fa-pencil"></i></button>
    <img src="{$photo}" alt="{$matricule}" style="width:60px;" title="{$nomEleve}"><br>
    </span>

    <button type="button" data-matricule="{$matricule}" class="btn btn-danger btn-xs btn-block delRetard"><i class="fa fa-trash"></i></button>

</div>
