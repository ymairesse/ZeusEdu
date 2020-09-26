<div id="modalSavePDF" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSavePDFLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
                <h4 class="modal-title" id="modalSavePDFLabel">Choix des périodes à sauvegarder</h4>
            </div>
            <div class="modal-body">
                <form id="formSavePDF">
                    <p>Veuillez sélectionner les périodes pour lesquelles vous souhaitez une sauvegarde PDF</p>
                    <label><input type="checkbox" id="allPeriodes"> Toutes</label>
                    {foreach from=$listePeriodes key=periode item=wtf name=boucle}
                    <div class="checkbox">
                        <label>
                        <input type="checkbox" value="{$periode+1}" class="periode" name="periodes[]" {if $smarty.foreach.boucle.iteration == $bulletin}checked{/if}>
                        Période {$smarty.foreach.boucle.iteration}: {$nomsPeriodes.$periode}
                        </label>
                    </div>
                    {/foreach}
                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-group">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="goSavePDF">Générer les PDF</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function() {

        $('#allPeriodes').click(function(){
            var checked = ($(this).is(':checked'))
            $('.periode').each(function(){
                $(this).prop('checked', checked);
            })
        })

    })
</script>
