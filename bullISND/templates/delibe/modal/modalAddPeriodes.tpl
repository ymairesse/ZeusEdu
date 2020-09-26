<div id="modalAddPeriode" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddPeriodeLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalAddPeriodeLabel">Périodes supplémentaires</h4>
            </div>
            <div class="modal-body">
                <form id="formAddPeriodes" <p>Sélectionnez les périodes non délibératoires à ajouter</p>
                    {foreach from=$listePeriodes key=wtf item=noPeriode}
                    <label class="checkbox-inline">
                        <input type="checkbox"
                        class="cb"
                        name="listePeriodes[]"
                        value="{$noPeriode}"
                        {if in_array($noPeriode, $periodesDelibes)} checked disabled{/if}
                        {if ($periodesSynthese !=Null) && in_array($noPeriode, $periodesSynthese)} checked{/if}>
                         Pér. {$noPeriode}
                     </label>
                     {/foreach}
                 </form>
             </div>
             <div class="modal-footer">
                 <button type="button" class="btn btn-default pull-left" id="clearFiltre">Supprimer la sélection</button>
                <button type="button" class="btn btn-primary" id="btn-addPeriodes">Confirmer</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#clearFiltre').click(function(){
            $('.cb').prop('checked', false);
        })
    })

</script>
