{* selectProfsCible *}

<select id="selectProf" name="selectProf" class="form-control">

    {foreach from=$listeProfs key=acronyme item=data}
        <option value="{$acronyme}"
            data-nomprof="{$data.nom} {$data.prenom}">
            {($data.sexe=='F')?'Mme':'M.'} {$data.nom} {$data.prenom} => {$data.titre}
        </option>
    {/foreach}

    {foreach from=$listeStatutsSpeciaux key=acronyme item=data}
        <option value="{$acronyme}"
            data-nomprof="{$data.nom} {$data.prenom}">
            {($data.sexe=='F')?'Mme':'M.'} {$data.nom} {$data.prenom} => {$data.titre}
        </option>
    {/foreach}

</select>
