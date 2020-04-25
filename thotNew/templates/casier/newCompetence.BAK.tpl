<tr>
    <td>
        <button type="button"
            class="btn btn-danger btn-sm btn-del"
            data-idcompetence="{$id|default:''}"
            title="Supprimer cette compétence"
            name="button">
            <i class="fa fa-times"></i>
        </button>
    </td>

    <td>
    <input type="hidden" name="oldCompetence_{$n}" value="{$id|default:''}">
    {if !(isset($id))}
    <select name="competence_{$n}" class="form-control select-competences">
        <option value="">Sélectionner une compétence</option>
        {if isset($listeCompetences)}
            {foreach from=$listeCompetences key=idCompetence item=uneCompetence}
            <option
                value="{$idCompetence}"
                {if (isset($id)) && ($idCompetence == $id)} selected='selected'{/if}>
                {$uneCompetence}
            </option>
            {/foreach}
        {/if}
    </select>
    {else}
    <input type="hidden" name="competence_{$n}" value="{$id}">
    <input type="text" class="form-control" title="Non modifiable" disabled value="{$listeCompetences[$id]}">
    {/if}
    </td>

    <td>
        {if !(isset($listeCompetencesTravail)) || $listeCompetencesTravail == null}
            {assign var=formCert value='form'}
            {else}
            {assign var=formCert value=$listeCompetencesTravail.$id.formCert}
        {/if}
        <input type="radio" class="formCert" name="formCert_{$n}" value="form" {if $formCert == 'form'}checked{/if}>
    </td>
    <td>
        <input type="radio" class="formCert" name="formCert_{$n}" value="cert" {if $formCert == 'cert'}checked{/if}>
    </td>

    <td>
        <input type="text"
            class="form-control"
            id="max_{$n}"
            name="max_{$n}"
            placeholder="Points"
            value="{$listeCompetencesTravail.$id.max|default:''}">
    </td>

    <td>
        <button type="button" class="btn btn-success btn-sm btn-plus" title="Ajouter une compétence"><i class="fa fa-plus"></i></button>
    </td>

</tr>
