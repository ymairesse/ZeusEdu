<ul class="list-unstyled">
    {foreach from=$listeRetards key=idRetard item=data}
    <li class="input-group">
        <span class="input-group-addon delRetard text-danger" data-idretard="{$data.idRetard}"><i class="fa fa-times"></i></span>
            <input type="text" class="form-control input-sm" readonly value="{$data.heure|truncate:5:''} : {$data.groupe} {$data.nom} {$data.prenom}">
        <span class="input-group-addon editRetard" data-idretard="{$data.idRetard}"><i class="fa fa-edit"></i></span>
    </li>
    {/foreach}
</ul>
