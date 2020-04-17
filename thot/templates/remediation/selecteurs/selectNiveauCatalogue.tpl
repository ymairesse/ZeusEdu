<form class="form-inline microform">

    <select class="form-control" id="niveauCatalogue">
        <option value="">Choisir le niveau</option>
        {foreach from=$listeNiveaux item=niveau}
            <option value="{$niveau}">{$niveau}e année</option>
        {/foreach}
    </select>

<button type="button" class="btn btn-primary" id="btn-selectNiveau">OK</button>

<div class="pull-right">
    <label for="nom" class="hidden-sm hidden-xs">Remédiations pour l'élève</label>
    <input type="text" name="nom" id="nom" value="" class="form-control" placeholder="Nom de l'élève">
    <button type="button" class="btn btn-primary" id="btn-selectMatricule">OK</button>
</div>


</form>
