<div class="eleve" data-matricule="{$matricule}" data-photo="{$photo}" data-nomeleve="{$nomEleve}" style="float:left;">
    <input type="hidden" class="matricule" name="matricule[]" value="{$matricule}">
    <input type="hidden" class="heure" name="heure[]" value="{$heure}">
    <input type="hidden" class="periode" name="periode[]" value="{$periode}">
    <input type="hidden" class="date" name="date[]" value="{$date}">
    <input type="hidden" class="nomEleve" name="nomEleve[]" value="{$nomEleve}">

    <img src="{$photo}" alt="{$matricule}" style="width:60px;" title="{$nomEleve}" class="editRetard"><br>

    <button type="button" data-matricule="{$matricule}" class="btn btn-danger btn-xs btn-block delRetard"><i class="fa fa-trash"></i></button>

</div>
