<button type="button" class="btn btn-primary btn-block" id="dissocier"><< Supprimer un élève</button>
<select class="form-control" id="stagesEleves" size="{$nomPrenoms|@count}">
    {foreach from=$nomPrenoms key=matricule item=dataEleve}
    <option value="{$matricule}">{$dataEleve.nom} {$dataEleve.prenom}</option>
    {/foreach}
</select>
