
<div class="col-sm-6 col-md-3">

    <form id="formSelect">

    	<h3>Critères de sélection</h3>
    	<div style="border: 1px solid grey; padding: 1em 0.5em">

    		<div class="form-group col-xs-6">
    			<label for="debut">Depuis</label>
    			<input type="text" value="{$debut}" name="debut" id="debut" maxlength="10" class="datepicker form-control">
    		</div>

    		<div class="form-group col-xs-6">
    			<label for="fin">Jusqu'à</label>
    			<input type="text" value="{$fin}" name="fin" id="fin" maxlength="10" class="datepicker form-control">
    		</div>

            <div class="panel">

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

    		<button type="button" class="btn btn-primary btn-block" id="btn-getPresences">Sélectionner <i class="fa fa-arrow-right"></i> </button>

    		<span id="ajaxLoader" class="hidden">
    			<img src="../images/ajax-loader.gif" alt="loading" class="img-responsive">
    		</span>


    	</div>

    </form>

</div>

<div class="col-sm-6 col-md-9" id="zoneDetails">

</div>




<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-getPresences').click(function(){
            var formulaire = $('#formSelect').serialize();
            $.post('inc/getStatsAssiduite.inc.php', {
                formulaire: formulaire
            }, function (resultat){
                $('#zoneDetails').html(resultat);
            })
        })

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

    })

</script>
