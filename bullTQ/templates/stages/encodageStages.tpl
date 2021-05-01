{debug}
<div class="container">

    <div class="row">

        <h2>Encodage des cotes de stages</h2>

        <form id="formStages">

        {foreach $listeStagiaires4groupe key=classe item=dataGroupe}

        {assign var=annee value=substr($classe, 0, 1)}

            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>
                            <h3>{$classe}</h3>
                        </th>

                        {foreach from=$listeEpreuves item=dataEpreuve}
                            <th style="text-align:center">{$dataEpreuve.legende}</th>
                        {/foreach}
                    </tr>
                </thead>

                <tbody>

                    {foreach from=$dataGroupe key=matricule item=dataEleve}
                        <tr data-matricule="{$matricule}">
                            <td>{$dataEleve.nom} {$dataEleve.prenom}</td>
                            {* liste des cotes *}
                            {foreach from=$listeEpreuves key=i item=dataEpreuve}
                                {assign var=titre value=$dataEpreuve.sigle}
                                <td>
                                    <input type="text"
                                        name="stage_{$matricule}_{$titre}"
                                        value="{$listeCotesQualifPargroupe.$matricule.$titre|default:''}"
                                        class="form-control majuscules"
                                        {if $listeEpreuves.$i.annee !== $annee}
                                        disabled
                                        {/if}>
                                </td>
                            {/foreach}

                        </tr>
                    {/foreach}
                </tbody>
            </table>

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

        $("input").keyup(function(e) {
			var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
			if ((key > 31) || (key == 8)) {
				// modification();
				if ($(this).hasClass('majuscules')) {
					$(this).val($(this).val().toUpperCase());
				}
			}
		})

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
