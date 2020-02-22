<form id="formJustification">

    <div class="col-xs-6">

        {if $justification != null}
        <input type="hidden" name="justif" id="justif" value="{$justification.justif}"> {else}
        <div class="form-group">
            <label for="justif">Nouveau mode de justification</label>
            <input type="text" class="form-control" id="justif" name="justif" placeholder="mode de justification" value="" required maxlength="12">
            <p class="help-block">Mode de justification (12 caractères)</p>
        </div>
        {/if}

        <div class="form-group">
            <label for="abr">Forme abréviée</label>
            <input type="text" class="form-control" id="shortJustif" name="shortJustif" value="{$justification.shortJustif}" required maxlength="5">
            <p class="help-block">Majuscules non accentuées (5 caractères)</p>
        </div>

        <div class="form-group">
            <label for="libelle">Libellé long</label>
            <input type="text" class="form-control" name="libelle" id="libelle" value="{$justification.libelle}" placeholder="Libellé en français" required>
            <p class="help-block">Texte en français</p>
        </div>

        <div class="form-group">
            <label for="ordre">Ordre d'apparition</label>
            <input type="text" class="form-control" name="ordre" placeholder="ordre" value="{$justification.ordre|default:99}" required>
            <p class="help-block">Ordre d'apparition de ce mode</p>
        </div>

    </div>

    <div class="col-xs-6">
        <div class="form-group">
            <label for="color">Couleur des caractères</label>
            <input type="color" class="form-control" name="color" id="color" value="{$justification.color|default:'#000000'}" required>
        </div>

        <div class="form-group">
            <label for="background">Couleur d'arrière-plan</label>
            <input type="color" class="form-control" name="background" id="background" value="{$justification.background|default:'#ffffff'}" required>
        </div>

        <p>Échantillon:
            <span class="echantillon" style="color:{$justification.color}; background:{$justification.background}; padding: 0.2em 0.5em">{$justification.justif|default:'test'}
            </span>
        </p>

        <p><label class="checkbox-inline"><input type="checkbox" name="accesProf" value="1" {if $justification.accesProf==1 } checked{/if}> Accès profs</label></p>

        {* <p><label class="checkbox-inline"><input type="checkbox" name="speed" value="1"{if $justification.speed==1 } checked{/if}> Accès rapide</label></p> *}

    </div>

    <div class="btn-group pull-right">
        <button type="reset" class="btn btn-default">Annuler</button>
        <button type="submit" class="btn btn-primary" id="submitEdit">Enregistrer</button>
    </div>

</form>

<script type="text/javascript">
    $(document).ready(function() {

        $("#color").change(function() {
            var couleur = $(this).val();
            $(".echantillon").css('color', couleur);
        })

        $("#background").change(function() {
            var background = $(this).val();
            $(".echantillon").css('background', background);
        })

        $("#formJustification").validate({
            submitHandler: function(form) {
            var data = $("#formJustification").serialize();
            $.post('inc/saveEdit.inc.php', {
                    post: data
                },
                function(resultat) {
                    bootbox.alert(resultat + ' enregistrement réussi');
                    $("#modalEdit").modal('hide');
                    $.post('inc/bodyEdit.inc.php', {
                            post: data
                        },
                        function(resultat) {
                            $("#bodyEdit").html(resultat);
                        })
                })
            }
        });

    })
</script>
