<div class="container">

    <div class="row">

        <h2>Encodage des cotes de stages</h2>

        <form id="formStages">

        {foreach $listeStagiaires4groupe key=classe item=dataGroupe}

        {assign var=annee value=substr($classe, 0, 1)}

        <div class="col-md-6 col-sm-12">

            <table class="table table-condensed">
                <thead>
                    <tr>
                        <td>
                            <h3>{$classe}</h3>
                        </td>
                        {foreach from=$listeEpreuves key=wtf item=dataEpreuve}
                        <td>{$dataEpreuve.legende}</td>
                        {/foreach}
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$dataGroupe key=matricule item=dataEleve}
                        <tr data-matricule="{$matricule}">
                            <td>{$dataEleve.nom} {$dataEleve.prenom}</td>
                            {* liste des cotes *}
                            {foreach from=$listeCotesQualifPargroupe.$matricule key=titre item=uneCote name=epreuve}
                                <td>
                                    {assign var=i value=$smarty.foreach.epreuve.index}
                                    <input type="text"
                                        name="stage_{$matricule}_{$titre}"
                                        value="{$uneCote}"
                                        class="form-control"
                                        {if $listeEpreuves.$i.annee !== $annee}
                                        disabled
                                        {/if}>
                                </td>
                            {/foreach}
                        </tr>
                    {/foreach}
                </tbody>
            </table>

        </div>

        {/foreach}

        <div class="clearfix"></div>

        <div class="btn-group pull-right">
            <button type="reset" class="btn btn-default">Annuler</button>
            <button type="button" class="btn btn-primary" id="saveStages">Enregistrer</button>
        </div>

    </form>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#saveStages').click(function(){
            var formulaire = $('#formStages').serialize();
            $.post('inc/stages/saveStages.inc.php', {
                formulaire: formulaire
            }, function(nb){
                bootbox.alert({
                    title: 'Enregistrement',
                    message: nb + ' mention(s) enregistrée(s)'
                })
            })
        })
    })

</script>
