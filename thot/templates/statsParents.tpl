<div class="container-fluid">

<div class="row">

    {foreach from=$statsParents key=annee item=dataAnnee}

            <table class="table table-condensed table-bordered">
                <thead>
                    <th>Classe</th>
                    <th>Nombre de parents inscrits</th>
                </thead>
            {foreach from=$dataAnnee key=classe item=data}
            <tr>
                <td>{$classe}</td>
                <td>{$data.nb}</td>
            </tr>
            {/foreach}
            </table>

    {/foreach}

</div>

</div>
