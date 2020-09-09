{foreach from=$listeAbonne key=id item=data}
<tr data-idliste="{$id}">
    <td>
        {$data.nomListe}
    </td>
    <td>{$data.nomProf|default:$data.proprio}</td>
    <td><button type="button" class="btn btn-danger btn-xs btn-desabo">Se désabonner</button></td>
    <td><button type="button" class="btn btn-info btn-xs btn-approp">S'approprier</button></td>
</tr>
{/foreach}
