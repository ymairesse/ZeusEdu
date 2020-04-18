<h2>Connexion des élèves à la plate-forme entre le {$dateDebut} et le {$dateFin}</h2>

<div class="overflow35">

    <table class="table table-condensed table-striped">
        <thead>
            <tr>
				<th>&nbsp;</th>
                <th>Classe</th>
                <th>Élève</th>
                <th>Connexions</th>
            </tr>
        </thead>

        <tbody>
            
            {foreach from=$listeEleves key=matricule item=dataEleve name=boucle}
            <tr>
				<td class="discret">{$smarty.foreach.boucle.iteration}</td>
				<td>{$dataEleve.groupe}</td>
				<td>{$dataEleve.nom} {$dataEleve.prenom}</td>
				<td>{$dataEleve.stats|default:0}</td>
            </tr>
            {/foreach}
        </tbody>

    </table>

</div>
