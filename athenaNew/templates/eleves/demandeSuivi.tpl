<div class="container">

    <div class="row">

        <form id="formulaire">

        <div class="col-md-4 col-xs-12">

            <h3>Demande de suivi pour</h3>

                <h4><img src="../photos/{$photo}.jpg" alt="{$matricule}" style="width:80px;" class="pull-right">{$eleve.nom} {$eleve.prenom} [{$eleve.classe}]</h4>
                <div class="clearfix"></div>

                <div class="row">

                    <div class="col-xs-5">

                        <div class="form-group">
                            <label for="envoyePar">Envoyé par</label>
                            <input type="text" name="envoyePar" id="envoyePar" value="{$acronyme}" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="col-xs-7">
                        <div class="form-group">
                            <label for="nomProf">Nom</label>
                            <select class="form-control" name="nomProf" id="nomProf">
                                {foreach from=$listeProfs key=unAcronyme item=data}
                                <option value="{$unAcronyme}"{if $acronyme == $unAcronyme} selected{/if}>{$data.nom} {$data.prenom}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="dateJour">Date du jour</label>
                    <input type="text" name="date" id="dateJour" class="datepicker form-control" value="{$date|date_format:'%d/%m/%Y'}" required>
                </div>

                <div class="form-group">
                    <label>Niveau d'urgence</label>
                    <div class="row">
                        <div class="col-xs-6">
                            <label class="radio-inline"><input type="radio" name="urgence" value="0" checked>Dès que possible</label>
                        </div>
                        <div class="col-xs-6">
                            <label class="radio-inline"><input type="radio" name="urgence" value="1">Urgent</label>
                        </div>
                    </div>
                </div>

        </div>

        <div class="col-md-8 col-xs-12">

            <div class="form-group">
                <label for="motif">Motif de la demande de suivi</label>
                <textarea name="motif" id="motif" placeholder="Votre texte ici" class="form-control" rows="8"></textarea>
            </div>

        </div>

        <div class="col-xs-12">
            <div class="btn-group pull-right">
                <button type="reset" class="btn btn-default" name="reset">Annuler</button>
                <button type="button" class="btn btn-primary" id="btnSave">Envoyer</button>
            </div>
        </div>
        <input type="hidden" name="id" id="id" value="{$id|default:''}">
        <input type="hidden" name="matricule" value="{$eleve.matricule}">
        <input type="hidden" name="anneeScolaire" value="{$ANNEESCOLAIRE}">
        <div class="clearfix"></div>
        </form>

    </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#formulaire').validate();

        $('#nomProf').change(function(){
            var acronyme = $(this).val();
            $('#envoyePar').val(acronyme);
        })

        $('#btnSave').click(function(){
            var formulaire = $('#formulaire').serialize();
            $.post('inc/eleves/setEleveASuivre.inc.php', {
                formulaire: formulaire
            }, function(resultat){
                if (resultat > 0) {
                    $('#id').val(resultat);
                    bootbox.alert('Votre demande de suivi a été enregistrée. Vous pouvez encore la modifier.');
                    }
                }
            )
        })

        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

    })

</script>
