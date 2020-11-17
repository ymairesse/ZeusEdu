<tr data-idComp="{$idComp}">
    <td>
        <button type="button" class="btn btn-danger btn-xs btn-delCompetence">
            <i class="fa fa-times"></i>
        </button>
    </td>
    <td>
        <input type="text" name="libelle_{$idComp}" data-idcomp="{$idComp}" value="{$data.libelle|default:$libelle}" class="lblComp form-control" id="lbl_{$idComp}" size="40" required>
    </td>
    <td>
        <input type="text" name="ordre_{$idComp}" value="{$data.ordre|default:0}" size="3" class="form-control">
    </td>

</tr>
