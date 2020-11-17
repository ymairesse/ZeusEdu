{assign var=competences value=$listeCompetences.$cours}

{foreach from=$competences key=idComp item=data}
    <tr data-idComp="{$idComp}">
        <td>
            <button type="button" class="btn btn-danger btn-xs btn-delCompetence"
            {if in_array($idComp, $listeUsedCompetences)} disabled{/if} >
                <i class="fa fa-times"></i>
            </button>
        </td>
        <td>
            <input type="text" name="libelle_{$idComp}" value="{$data.libelle}" class="lblComp form-control" id="lbl_{$idComp}" data-idcomp="{$idComp}" size="40" required>
        </td>
        <td>
            <input type="text" name="ordre_{$idComp}" value="{$data.ordre}" size="3" class="form-control">
        </td>

    </tr>

{/foreach}
