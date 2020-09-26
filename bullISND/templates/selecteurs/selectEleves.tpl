<select class="form-control" name="matricule" id="matricule">
    <option value="">Sélection d'un élève</option>
    {foreach from=$listeEleves key=matricule item=unEleve}
        <option value="{$matricule}">{$unEleve.nom} {$unEleve.prenom} {$unEleve.classe}</option>
    {/foreach}
</select>
