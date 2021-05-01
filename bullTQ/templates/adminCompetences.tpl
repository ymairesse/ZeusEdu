<div class="container-fluid">

    <h2>Administration des compétences {$cours|default:''}</h2>

    {if (isset($cours))}

        <form name="adminCompetences" id="adminCompetences" method="POST" action="index.php">

            <div class="row">

                <div class="col-md-6 col-xs-12">

                    <h3>Compétences actuelles <div class="btn-group pull-right">
                        <button type="reset" class="btn btn-default" name="Annuler" id="annuler">Annuler</button>
                        <button type="submit" class="btn btn-primary" name="submit">Enregistrer</button>
                    </div> </h3>

            		{if $listeCompetences|@count > 0}
                    {assign var=competences value=$listeCompetences.$cours}

                    <table class="table table-condensed">
                        <tr>
                            <th>&nbsp;</th>
                            <th>Libellé de la compétence</th>
                            <th>Ordre</th>
                        </tr>
                        {foreach from=$competences key=idComp item=data}
                            <tr>
                                <td>
                                    <div class="checkbox">
                                        <label><input type="checkBox" name="suppr_{$idComp}" class="supprComp" id="chck_{$idComp}"></label>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="libelle_{$idComp}" value="{$data.libelle}" size="50" class="lblComp form-control" id="lbl_{$idComp}">
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <input type="text" name="ordre_{$idComp}" value="{$data.ordre}" size="3" class="form-control">
                                    </div>

                                </td>
                            </tr>
                        {/foreach}
                        <tr>
                            <td colspan="3">
                                <label for="toutCocher"><input type="checkBox" name="toutCocher" id="toutCocher"> Tout cocher</label>
                                <button type="button" class="btn btn-info" id="effacer">Effacer les compétences cochées</button>

                                <button type="button" class="btn btn-success pull-right" id="ajouter">Ajouter une compétence</button>
                            </td>
                        </tr>
                    </table>

            		{/if}

                </div>

                <div class="col-md-6 col-xs-12" style="min-height:25em;">

                    <h3>Nouvelle(s) compétence(s)</h3>
                    <div id="newComp"></div>

                    <hr>


                </div>

                <div style="float:right">

                <input type="hidden" name="cours" value="{$cours}">
                <input type="hidden" name="niveau" value="{$niveau}">
                <input type="hidden" name="action" value="admin">
                <input type="hidden" name="mode" value="competences">
                <input type="hidden" name="etape" value="enregistrer">
                </div>

            </div>

    {/if}

    </form>

</div>

<script type="text/javascript">

    $(document).ready(function(){
        var nbNewComp = 1;

        $("#toutCocher").click(function(){
            $(".supprComp").click();
            })

        $("#effacer").click(function(){
            $(".supprComp").each(function(no){
                var ceci = $(this);
                if ($(this).prop('checked')) {
                    $(this).css({ 'opacity' : 0.5});
                    $(this).closest('td').next().find('input').val('').css({ 'opacity' : 0.5 });
                    }
                })
            })
        $("#annuler").click(function(){
            if (confirm("Êtes-vous sûr(e) de vouloir annuler?")) {
                $(".lblComp").each(function(no){
                    $(this).css({ 'opacity':1 });
                    $(".blockNewComp").remove();
                    nbNewComp = 1;
                    })
                }
            })

        $("#ajouter").click(function(){
                $('<div class="blockNewComp form-group">'+nbNewComp+'. <input type="text" class="newComp form-control" name="newComp[]" value="" size="50"></div>').fadeIn('slow').appendTo('#newComp');
                $(".newComp").last().focus();
                nbNewComp++;

            })

        $("#adminCompetences").submit(function(){
			$.blockUI();
            $("#wait").show();
            })
        })

</script>
