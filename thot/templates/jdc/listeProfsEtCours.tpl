<div class="form-group">

    <label for="listeProfs">Sélection d'un enseignant</label>
    <select class="form-control" name="listeProfs" id="listeProfs">
        <option value="">Sélectionner un professeur</option>
        {foreach from=$listeProfs key=unAcronyme item=data}
        <option value="{$unAcronyme}"{if isset($acronyme) && ($acronyme == $unAcronyme)} selected{/if}>{$data.nom} {$data.prenom}</option>
        {/foreach}
    </select>

</div>

<div class="form-group" id="listeCours4Educs">

    {* sera rempli par la liste des cours du prof sélectionné *}

</div>
