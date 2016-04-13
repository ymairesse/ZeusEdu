<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="modal fade" id="modalEdit" tabindex="-1" role="dialog" aria-labelledby="titleModaleEdit" aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModaleEdit">Édition d'une notification</h4>
            </div>

            <div class="modal-body">

                <form action="index.php" method="POST" class="form-vertical" role="form">

                    <div class="form-group">
                        <label for="objet">Objet</label>
                        <input type="text" maxlength="80" name="objet" id="objet" placeholder="Objet de votre note" class="form-control" value="">
                    </div>

                    <textarea id="texte" name="texte" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true"></textarea>

                    <div class="row">

                        <div class="col-xs-4">
                            <div class="form-group">
                                <label for="dateDebut">Date de début</label>
                                <input type="text" name="dateDebut" id="dateDebut" placeholder="Début" class="datepicker form-control" value="">
                            </div>

                        </div>

                        <div class="col-xs-4">
                            <div class="form-group">
                                <label for="dateFin">Date de fin</label>
                                <input type="text" name="dateFin" id="dateFin" placeholder="Fin" class="datepicker form-control" value="">
                            </div>
                        </div>


                        <div class="col-xs-4">
                            {assign var=texteNiveau value=['faible', 'moyen','urgent']}
                            <div class="form-group">
                                <label for="urgence">Urgence</label>
                                <br>
                                <select name="urgence" id="urgence" class="form-control">
                                    {foreach from=range(0,2) item=urgence}
                                    <option value="{$urgence}" class="urgence{$urgence}">{$texteNiveau.$urgence}</option>
                                    {/foreach}
                                </select>
                            </div>

                        </div>

                    </div> <!-- row -->

                    <input type="hidden" name="id" id="id" value="">
                    <input type="hidden" name="action" value="editNotification">
                    <input type="hidden" name="mode" value="{$mode}">
                    <input type="hidden" name="etape" value="saveEdit">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="button" class="btn btn-primary" id="saveEdited">Enregistrer</button>
                    </div>

                    <div class="clearfix"></div>
                </form>

            </div>

        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#urgence").change(function(){
            var urgence = $(this).val();
            $(this).removeClass().addClass('form-control urgence'+urgence);
        })

        $("#dateDebut").datepicker({
                format: "dd/mm/yyyy",
                clearBtn: true,
                language: "fr",
                calendarWeeks: true,
                autoclose: true,
                todayHighlight: true
            })
            .off('focus')
            .click(function() {
                $(this).datepicker('show');
            });

        $("#dateFin").datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $("#notification").validate({
            rules: {
                'objet': 'required'
            }
        });

    })
</script>
