<select id="selectProf" name="selectProf" class="form-control">
    <option value="">Sélectionner un enseignant</option>
    {foreach from=$listeProfsCours key=acronyme item=data}
        <option
            value="{$acronyme}"
            data-nomprof="{$data.nom} {$data.prenom}">
            {($data.sexe=='F')?'Mme':'M.'} {$data.nom} {$data.prenom} => {$data.libelle} {$data.nbheures}h
        </option>
    {/foreach}
    
    {foreach from=$listeStatutsSpeciaux key=acronyme item=data}
        <option class="statutSpecial"
            value="{$acronyme}"
            data-nomprof="{$data.nom} {$data.prenom}">
            {($data.sexe=='F')?'Mme':'M.'} {$data.nom} {$data.prenom} => {$data.titre}
        </option>
    {/foreach}
</select>
