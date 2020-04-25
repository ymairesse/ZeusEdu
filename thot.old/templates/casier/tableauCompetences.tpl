{* Affichage des différentes compétences s'il s'agit d'une édition, sinon tbody vide *}
{foreach $dataTravail.competences key=idCompetence item=data name=n}

<tr data-idcompetence="{$idCompetence}">
    <td>
        <button type="button" class="btn btn-xs btn-danger btn-delComp" data-idcompetence="{$idCompetence}" data-idtravail="{$dataTravail.idTravail}"><i class="fa fa-minus"></i></button>
    </td>
    <td>
        <input type="hidden" name="competence_{$smarty.foreach.n.index}" value="{$idCompetence}">
        <input type="hidden" name="idCarnet_{$smarty.foreach.n.index}" value="{$data.idCarnet}">
        <input type="text" readonly name="txtCompetence_{$smarty.foreach.n.index}" value="{$listeCompetences.$idCompetence}" class="form-control input-sm">
    </td>
    <td>
        <label class="radio-inline">
            <input title="Formatif" type="radio" name="formCert_{$smarty.foreach.n.index}" value="form"{if $data.formCert == 'form'} checked{/if}>Form.
        </label>
        <label class="radio-inline">
            <input title="Certificatif" type="radio" name="formCert_{$smarty.foreach.n.index}" value="cert"{if $data.formCert == 'cert'} checked{/if}>Cert.
        </label>
    </td>
    <td>
        <input type="text" placeholder="max" name="max_{$smarty.foreach.n.index}" value="{$data.max|default:''}" class="form-control" maxlength="3">
    </td>

</tr>

{/foreach}
