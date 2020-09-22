    <div class="col-md-3 col-sm-6">

        <form id="formStats">

            <div class="form-group col-xs-6">
                <label for="debut">Depuis</label>
                <input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker form-control">
            </div>

            <div class="form-group col-xs-6">
                <label for="fin">Jusqu'à</label>
                <input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker form-control">
            </div>

        <div class="panel panel-default">

            <div class="panel-heading">
                <h4>Liste des enseignants</h4>
            </div>

            <div class="panel-body" style="height:20em; overflow: auto;">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="cbProfs" style="float: left; margin-right:0.5em">
                        TOUS
                    </label>
                </div>

                <ul class="list-unstyled">
            	{foreach from=$listeProfs key=unAcronyme item=prof}
            		<li>
                        <div class="checkbox">
                            <label>
                                <input class="selecteurProf" type="checkbox" name="profs[]" value="{$unAcronyme}">
                                <span style="padding-left:0.5em">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
                            </label>
                        </div>
            		</li>
            	{/foreach}
            	</ul>
            </div>
        </div>

        <div class="panel panel-default">

            <div class="panel-heading">
                <h4>Liste des catégories</h4>
            </div>

            <div class="panel-body" style="height:15em; overflow: auto;">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="cbCategories">
                        TOUTES
                    </label>
                </div>
                <ul class="list-unstyled">
                    {foreach from=$listeCategories key=idCategorie item=categorie}
                    <li>
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" class="selecteurCategorie" name="idCategories[]" value="{$idCategorie}">
                            <span style="padding-left:0.5em">{$categorie}</span>
                        </label>
                        </div>
                    </li>
                    {/foreach}
                </ul>

            </div>

        </div>

        <button type="button" id="btn-getStats" class="btn btn-primary btn-block">Envoyer</button>

        </form>

    </div>

    <div class="col-md-9 col-sm-6" id="zoneStats">

        {include file='jdc/pageStatsJdc.tpl'}

    </div>


<script type="text/javascript">

    $(document).ready(function(){

        $(".datepicker").datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $('#cbProfs').change(function(){
            $('.selecteurProf').trigger('click');
        })

        $('#cbCategories').change(function(){
            $('.selecteurCategorie').trigger('click');
        })

        $('#btn-getStats').click(function(){
            var formulaire = $('#formStats').serialize();
            $.post('inc/jdc/getStatsJdc.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                $('#zoneStats').html(resultat);
            })
        })

    })

</script>
