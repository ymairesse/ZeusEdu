{* selectProfsCible *}
<select id="selectProf" name="selectProf" class="form-control">
    <option value="">Professeur</option>

    {foreach from=$listeProfs key=acronyme item=data}
        <option value="{$acronyme}"
            data-nomprof="{$data.nom|default:$acronyme} {$data.prenom|default:''}">
            {($data.sexe|default:''=='F')?'Mme':'M.'} {$data.nom|default:''} {$data.prenom|default:''} => {$data.titre|default:''}
        </option>
    {/foreach}

    {foreach from=$listeStatutsSpeciaux key=acronyme item=data}
    <option value="{$acronyme}"
        data-nomprof="{$data.nom|default:$acronyme} {$data.prenom|default:''}">
        {($data.sexe|default:''=='F')?'Mme':'M.'} {$data.nom|default:''} {$data.prenom|default:''} => {$data.titre|default:''}
    </option>
    {/foreach}

</select>
