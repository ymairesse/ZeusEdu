{foreach from=$listeJustifications key=mention item=justification}
<tr>
    <td>
        <button type="button" class="btn btn-success btn-xs btn-edit" data-just={$mention}><i class="fa fa-edit"></i></button>
    </td>
    <td class="btn-edit" data-just="{$mention}" style="color:{$justification.color}; background:{$justification.background}">{$mention}</td>
    <td>{$justification.shortJustif}</td>
    <td>{$justification.libelle}</td>
    <td>{$justification.ordre}</td>
    <td>{if !($justification.obligatoire)}
        <button type="button" class="btn btn-xs btn-danger btn-del" data-justif="{$justification.justif}" name="button">
            <i class="fa fa-times"></i></button>
        {else}
            <i class="fa fa-lock" title="obligatoire"></i>
        {/if}
    </td>
</tr>
{/foreach}
