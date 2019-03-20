<tr>
    <td>
        &nbsp;
    </td>
    <td>
        <select class="" name="">

        </select>
    </td>
    <td>
        <label class="radio-inline">
            <input title="Formatif" type="radio" name="formCert_{$idCompetence}" value="form"{if $data.formCert == 'form'} checked{/if}>Form.
        </label>
        <label class="radio-inline">
            <input title="Certificatif" type="radio" name="formCert_{$idCompetence}" value="cert"{if $data.formCert == 'cert'} checked{/if}>Cert.
        </label>
    </td>
    <td>
        <input type="text" placeholder="max" name="max_{$idCompetence}" value="{$data.max|default:''}" class="form-control" maxlength="3">
    </td>

</tr>
