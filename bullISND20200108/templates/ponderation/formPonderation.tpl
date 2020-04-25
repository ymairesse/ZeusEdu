{foreach from=$listePonderations key=periode item=ponderation}

    <tr>
        <td>{$periode}</td>
        <td>{$NOMSPERIODES[$periode-1]}</td>
        <td>
            <input type="text"
                class="poids form-control"
                value="{$ponderation.form}"
                {if ($bulletin > $periode)} readonly {/if}
                name="formatif_{$periode}" maxlength="3">
        </td>
        <td>
            <input type="text"
                class="poids form-control"
                value="{$ponderation.cert}"
                {if ($bulletin > $periode)} readonly {/if}
                name="certif_{$periode}"
                maxlength="3">
        </td>
    </tr>

{/foreach}

<script type="text/javascript">

$(document).ready(function(){
    var readonly = "Cette période est passée et n'est plus modifiable";
    $("#modPonderation").find('input:text[readonly]').attr('title',readonly);
})

</script>
