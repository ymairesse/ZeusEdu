<div id="selectDates" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="selectDatesLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="selectDatesLabel">Dates d'absence pour {$nomProf}</h4>
            </div>
            <div class="modal-body">

                <form id="formDates">

                    <div class="col-xs-6">
                        <div class="input-group">
                            <label for="start">Début</label>
                            <input type="text" class="datepicker form-control" name="start" id="start" value="{$laDate|default:''}" required>
                            <div class="help-block">
                                Veuillez confirmer cette date
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-6">
                        <div class="input-group">
                            <label for="end">Fin</label>
                            <input type="text" class="datepicker form-control" name="end" id="end" value="{$laDate|default:''}" disabled required>
                            <div class="help-block">
                                Veuillez confirmer la date de fin
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12">
                        Statut de l'absence
                        <label class="radio-inline"><input type="radio" name="statutAbs" value="ABS" checked class="statutAbs">Absence</label>
                        <label class="radio-inline"><input type="radio" name="statutAbs" value="indisponible" class="statutAbs">Indisponibilité</label>
                    </div>
                    <div class="clearfix"></div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btn-confirmDates">Appliquer ces dates</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    function convDate(dateFr) {
        var Y = dateFr.substring(6,10);
        var M = dateFr.substring(3,5) - 1;
        var D = dateFr.substring(0,2);
        var laDate = new Date(Y, M, D);
        return laDate;
    }

    $(document).ready(function() {

        $('#formDates').validate();

        $('#start').datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: '06',
        });

        $('#end').datepicker({
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true,
            daysOfWeekDisabled: '06',
        });

    })
</script>
