<div class="col-sm-4">
    <div class="form-group">
        <label for="niveau">Niveau</label>
        <select class="form-control" name="niveau" id="niveau">
            <option value="">Choisir le niveau</option>
            {foreach from=$listeNiveaux item=niveau}
                <option value="{$niveau}">{$niveau}e année</option>
            {/foreach}
        </select>
    </div>
</div>

<div class="col-sm-8" id="selectMatiere">
    <div class="form-group">
        <label for="matiere">Matière</label>
        <select class="form-control" name="matiere" id="matiere">
            <option value="">Matière</option>
        </select>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#niveau').change(function(){
            var niveau = $(this).val();
            if (niveau != '') {
                $.post('inc/remediation/selectMatiere.inc.php', {
                    niveau: niveau
                }, function(resultat){
                    $('#selectMatiere').html(resultat);
                })
            }
        })
    })

</script>
