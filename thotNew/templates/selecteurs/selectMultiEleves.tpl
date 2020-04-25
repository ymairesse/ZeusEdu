<ul class="list-unstyled">
{foreach from=$listeEleves key=matricule item=dataEleve}
    <li>
        <div class="checkbox">
            <label><input type="checkbox" value="{$matricule}" name="matricules[]" class="selecteurAddMembres">
                {$dataEleve.groupe} {$dataEleve.nom} {$dataEleve.prenom}
            </label>
        </div>
    </li>
{/foreach}
</ul>
