<h2>Connexion des parents à la plate-forme</h2>

<div class="overflow35">

    <table class="table table-condensed table-striped">
        <thead>
            <tr>
                <th>Classe</th>
                <th>Élève</th>
                <th>Parent</th>
                <th>Connexions</th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$stats key=user item=data}
            <tr>
                <td>{$data.groupe}</td>
                <td>{$data.nom} {$data.prenom}</td>
                <td>{$data.formule} {$data.nomParent} {$data.prenomParent}</td>
                <td>{$data.nb}</td>
            </tr>
            {/foreach}
        </tbody>

    </table>

</div>
