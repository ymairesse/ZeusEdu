<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title" id="titrePanneau">Sélection</h4>
    </div>

    <div class="panel-body">
        {if $notification.type == 'classes'}
        <div class="geant">{$classe}</div> {/if}
        {if $notification.type == 'niveau'}
        <div class="geant">{$notification.destinataire}<sup>e</sup></div> {/if}
        {if $notification.type == 'ecole'}
        <div class="geant">Tous</div>
        {/if}

		<label class="error" for="membres[]" generated="true"></label>

        <div id="listeEleves" style="height:30em; overflow:auto;">
            <p class="checkbox">
                <label><input type="checkbox" class="cb" name="TOUS" id="cbTous" value="tous" checked><strong>TOUS</strong></label>
            </p>

            <ul class="list-unstyled">
                {foreach from=$listeEleves key=matricule item=eleve}

                    <li class="checkbox">
                        <label><input type="checkbox" class="cb" name="membres[]" value="{$matricule}" checked>{$eleve.nom} {$eleve.prenom}</label>
                    </li>

                {/foreach}
            </ul>

        </div>

    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $('#cbTous').change(function(){
            var texte = $('#cbTous').next('strong').text();
            $('#cbTous').next('strong').text(texte == 'TOUS' ? 'AUCUN' : 'TOUS');
            if ($('#cbTous').is(':checked')) {
                $('.cb').prop('checked', true);
            }
                else {
                    $('.cb').prop('checked', false);
                }
            })
    })
</script>
