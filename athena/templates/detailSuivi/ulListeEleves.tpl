<ul class="list-unstyled">
{foreach from=$listeEleves key=unMatricule item=eleve}
    <li>
    <div class="checkbox" style="height:1.2em;">
        <label>
            <input type="checkbox" class="cbEleve" value="{$unMatricule}"
                {if $unMatricule == $matricule} disabled{/if}
                {if isset($listeElevesPlus) && in_array($unMatricule, $listeElevesPlus)} checked{/if}>
            <span>{$eleve.classe} {$eleve.nom} {$eleve.prenom}</span>
        </label>
    </div>
    </li>
{/foreach}
</ul>
