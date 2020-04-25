<form id="formPresences" style="max-height:35em; overflow: auto;">

    <h4>{$listeEleves|@count} élèves inscrits</h4>
    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Classe</th>
                <th>Nom</th>
                <th title="Présent">P</th>
                <th title="Absent">A</th>
                <th title="Indéterminé">I</th>
            </tr>
        </thead>
        {foreach from=$listeEleves key=matricule item=data}
            <tr data-matricule="{$data.matricule}" class="{$data.presence}">
                <td>{$data.groupe}</td>
                <td>{$data.nom} {$data.prenom}</td>
                <td><input type="radio" name="presence_{$matricule}" value="P"{if $data.presence == 'present'} checked{/if}></td>
                <td><input type="radio" name="presence_{$matricule}" value="A"{if $data.presence == 'absent'} checked{/if}></td>
                <td><input type="radio" name="presence_{$matricule}" value="I"{if $data.presence == 'indetermine'} checked{/if}></td>
            </tr>
        {/foreach}

    </table>

<input type="hidden" name="idOffre" value="{$idOffre}">

</form>
