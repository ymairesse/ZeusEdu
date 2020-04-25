<div class="row">

    <div class="col-sm-4">
        <ul class="listeMembres list-unstyled">
        {foreach from=$listeNiveaux key=wtf item=unNiveau}
            <li>
                <label class="radio-inline">
                <input type="radio" class="niveauMatiere" name="niveauMatiere" value="{$unNiveau}">
                Cours en {$unNiveau}e</label>
            </li>
        {/foreach}
        </ul>
    </div>

    <div class="col-sm-8" id="listeMatieres">

    </div>

</div>
