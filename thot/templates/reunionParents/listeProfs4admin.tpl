<ul class="list-unstyled">
    {foreach from=$listeProfs key=abr item=data}
    <li title="{$data.nom} {$data.prenom}">
        <button
            type="button"
            class="btn btn-sm btn-block btn-prof btn-default"
            data-abreviation="{$data.acronyme}"
            data-nomprof="{$data.prenom} {$data.nom}"
            data-statut="{$data.statut}">
            {$data.nom} {$data.prenom}
        </button>
    </li>
    {/foreach}
</ul>
