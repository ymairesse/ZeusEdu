<div class="container-fluid">

    <div class="row">

        <div class="col-xs-12">

        <table class="table table-condensed table-responsive">
            <tr>
                <th>Identité</th>
                <th>User</th>
                <th>Enfant</th>
                <th style="width:2em">Cf</th>
                <th style="width:2em">Nt</th>
            </tr>

            {foreach from=$listeParents key=userName item=data}
            <tr>
                <td>{$data.formule} {$data.nomParent} {$data.prenomParent} ({$data.lien})</td>
                <td>{$data.userName}</td>
                <td><a href="javascript:void()" data-classe="{$data.groupe}" class="classe">{$data.groupe} {$data.nom} {$data.prenom}</a></td>
                <td>{$data.confirme}</td>
                <td>{$data.notifications|default:''}</td>
            </tr>
            {/foreach}
        </table>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){
        $('.classe').click(function(){
            var classe = $(this).data('classe');
            $('#selectClasse').val(classe);
            $('#formSelecteurClasse').submit();
        })
    })

</script>
