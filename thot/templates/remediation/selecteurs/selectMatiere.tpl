<div class="form-group">
    <label for="matiere">Matière</label>
    <select class="form-control" name="matiere" id="matiere">
        <option value="">Matière</option>
        {foreach from=$listeMatieres key=matiere item=data}
        <option value="{$matiere}">{$data.libelle} [{$matiere} ] {$data.statut} {$data.nbHeures}h</option>
        {/foreach}
    </select>
</div>
