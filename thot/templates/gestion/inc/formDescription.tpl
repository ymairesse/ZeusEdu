<h3>Description du groupe</h3>

<form id="formEditGroupe">

    <div class="col-md-4 col-sm-12">
        <div class="form-group">
            <label for="nom">Nom du groupe</label>
            <input type="text" name="nomGroupe" id="nomGroupe" value="{$dataGroupe.nomGroupe|default:''}" class="form-control"{if isset($dataGroupe.nomGroupe) && ($dataGroupe.nomGroupe != '')} readonly{/if} maxlength="8">
            <span class="help-block">Nom technique du groupe en 8 caractères alphabétiques</span>
        </div>
    </div>

    <div class="col-md-4 col-sm-12">
        <div class="form-group">
            <label for="intitule">Intitulé du groupe</label>
            <input type="text" name="intitule" id="intitule" value="{$dataGroupe.intitule|default:''}" class="form-control" maxlength="20">
            <span class="help-block">Nom public en 20 caractères</span>
        </div>
    </div>

    <div class="col-md-4 col-sm-12">
        <div class="form-group">
            <label for="type">Type</label>
            <select class="form-control" name="type" id="type">
                <option value="">Type de groupe</option>
                <option value="ouvert"{if isset($dataGroupe.type) && ($dataGroupe.type == 'ouvert')} selected{/if}>Ouvert à tous</option>
                <option value="invitation"{if isset($dataGroupe.type) && ($dataGroupe.type == 'invitation')} selected{/if}>Ouvert sur invitation</option>
                <option value="ferme"{if isset($dataGroupe.type) && ($dataGroupe.type == 'ferme')} selected{/if}>Groupe inactif</option>
            </select>
        </div>
    </div>

    <div class="col-xs-12">
        <div class="form-group">
            <label for="description">Description</label>
            <textarea name="description" id="description" class="form-control" rows="4">{$dataGroupe.description|default:''}</textarea>
            <span class="help-block">Description à l'usage des membres du groupe</span>
        </div>
    </div>

    <div class="btn-group pull-right">
        <button type="button" name="button" class="btn btn-default" id="btn-reset" data-nomgroupe="{$dataGroupe.nomGroupe|default:''}">Annuler</button>
        <button type="button" name="envoyer" class="btn btn-primary" id="btn-save">Enregistrer</button>
    </div>

    <input type="hidden" name="edition" id="edition" value="{$dataGroupe.nomGroupe|default:''}">

    <div class="clearfix"></div>

</form>

<script type="text/javascript">

    $(document).ready(function(){

        CKEDITOR.replace('description');

        jQuery.validator.addMethod("lettersonly", function(value, element) {
            return this.optional(element) || /^[a-z]+$/i.test(value);
            }, "Uniquement des lettres svp");

        $('#editGroupe').validate({
            // pour ne pas ignorer le "textarea" qui sera caché
            ignore: [],
            rules: {
                nomGroupe: {
                    required: true,
                    lettersonly: true
                },
                intitule: {
                    required: true
                },
                type: {
                    required: true
                },
                description: {
                    required: function(textarea) {
                                  CKEDITOR.instances['description'].updateElement();
                                  var editorcontent = textarea.value.replace(/<[^>]*>/gi, '');
                                  return editorcontent.length === 0;
                                }
                            }
                }
        });


    })

</script>
