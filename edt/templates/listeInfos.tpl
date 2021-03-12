<td style="width:33%" class="td-edit" data-type="info">
    <ul class="list-unstyled">
        {foreach from=$listeInfos1 key=idEDTinfo item=data}
            <li title="{$data.proprio}" data-id="{$data.idEDTinfo}">
                <span>{$data.info}</span>
            </li>
        {/foreach}
    </ul>

</td>

<td style="width:33%" class="td-edit" data-type="info">
    <ul class="list-unstyled">
        {foreach from=$listeInfos2 key=idEDTinfo item=data}
            <li title="{$data.proprio}" data-id="{$data.idEDTinfo}">
                <span>{$data.info}</span>
            </li>
        {/foreach}
    </ul>

</td>

<td style="max-height:5em; overflow: auto; width:33%" class="td-edit" data-type="retard">
    <ul class="list-unstyled">
        {foreach from=$listeRetards key=idEDTinfo item=data}
        <li  title="{$data.proprio}" data-id="{$data.idEDTinfo}">
            <span>[{$data.acronyme}] {$data.info}</span>
        </li>
        {/foreach}
    </ul>
</td>
