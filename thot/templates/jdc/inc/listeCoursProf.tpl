<label for="listeCours">Sélection d'un cours</label>
<select class="form-control" name="listeCoursProf4Educs" id="listeCoursProf4Educs">
    <option value="">Sélectionner un cours</option>
    {foreach from=$listeCours key=abreviation item=data}
    <option value="{$abreviation}">{$data.statut} {$data.libelle} {$data.nbheures} [{$abreviation}]</option>
    {/foreach}
</select>
