
<div class="container">

    <form id="formAcronymes">
        <div class="input-group">
            <label for="ancien">Ancien acronyme</label>
            <input type="text" class="form-control" id="ancien" name="ancien" value="">
        </div>

        <div class="input-group">
            <label for="nouveau">Nouvel acronyme</label>
            <input type="text" class="form-control" name="nouveau" value="" id="nouveau">
        </div>

        <div class="input-group">
            <label for="table">Nom de la table</label>
            <input type="text" class="form-control" name="table" id="table" value="">
        </div>

        <div class="input-group">
            <label for="field">Nom du champ</label>
            <input type="text" class="form-control" name="field" value="acronyme">

        </div>

        <div class="button-group">
            <button type="reset" class="btn btn-default" name="annuler">Annuler</button>
            <button type="button" class="btn btn-primary" id="save" name="button">Exécuter</button>
        </div>

    </form>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#save').click(function(){
            var formulaire = $('#formAcronymes').serialize();
            $.post('inc/majAcronymes.inc.php', {
                formulaire: formulaire
            }, function(nb){
                bootbox.alert(nb + "acronymes modifiés");
            })
        })
    })

</script>
