{foreach from=$listePeriodes item=periode}

    <tr>
        <td>{$periode}</td>
        <td>{$NOMSPERIODES[$periode-1]|default:'NA'}</td>
        <td>
            <input type="text"
                class="poids form-control"
                value="{$listePonderations.$periode.form}"
                {if ($bulletin > $periode)}
                readonly
                title="Cette période est passée et n'est plus modifiable"
                {/if}
                name="formatif_{$periode}" maxlength="3">
        </td>
        <td>
            <input type="text"
                class="poids form-control"
                value="{$listePonderations.$periode.cert}"
                {if ($bulletin > $periode)}
                readonly
                title="Cette période est passée et n'est plus modifiable"
                {/if}
                name="certif_{$periode}"
                maxlength="3">
        </td>
    </tr>

{/foreach}
