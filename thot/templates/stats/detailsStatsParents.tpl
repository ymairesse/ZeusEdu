<h2>Connexion des parents à la plateforme entre le {$dateDebut} et le {$dateFin}</h2>

<div class="overflow35">

    <table class="table table-condensed table-striped">
        <thead>
            <tr>
                <th>&nbsp;</th>
                <th>Classe</th>
                <th>Élève</th>
                <th>Parent</th>
                <th>Connexions</th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$stats key=user item=data name=boucle}
            <tr>
                <td class="discret">{$smarty.foreach.boucle.iteration}</td>
                <td>{$data.groupe}</td>
                <td>{$data.nomEleve} {$data.prenomEleve}</td>
                <td>{$data.formule} {$data.nomParent} {$data.prenomParent}</td>
                <td>{$data.nb}</td>
            </tr>
            {/foreach}
        </tbody>

    </table>

</div>
