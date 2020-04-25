<h3>Description du groupe {if $edition == 1}<strong>{$dataGroupe.intitule}</strong>{/if}</h3>

<form id="formEditGroupe">

    <div class="col-md-4 col-sm-12">
        <div class="form-group">
            <label for="intitule">Intitulé du groupe {if $edition == 1}(non modifiable){/if}</label>
            <input type="text"
                name="intitule"
                id="intitule"
                value="{$dataGroupe.intitule|default:''}"
                class="form-control"
                maxlength="20"
                {if $edition == 1}readonly{/if}>
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

    <div class="col-md-4 col-sm-12">
        <div class="form-group">
            <label for="maxMembres">Nombre de membres max</label>
            <input type="text" name="maxMembres" id="maxMembres" class="form-control" maxlength="3" value="{$dataGroupe.maxMembres|default:0}">
            <span class="help-bloc">Nombre maximum de membres</span>
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

    <input type="hidden" name="edition" id="edition" value="{$edition|default:0}">
    <input type="hidden" name="nomGroupe" id="nomGroupe" value="{$dataGroupe.nomGroupe|default:''}">

    <div class="clearfix"></div>

</form>

<script type="text/javascript">

    $(document).ready(function(){

        CKEDITOR.replace('description');

        jQuery.validator.addMethod("lettersonly", function(value, element) {
            return this.optional(element) || /^[a-z]+$/i.test(value);
            }, "Uniquement des lettres svp");

        $('#intitule').blur(function(){
            var nomPublic = $(this).val();
            // on ne conserve que les lettres (majuscules) et les chiffres
            var nomTechnique = nomPublic.replace(/[^0-9a-z]/gi, '').toUpperCase();
            $('#nomGroupe').val(nomTechnique);
        })

        $('#formEditGroupe').validate({
            // pour ne pas ignorer le "textarea" qui sera caché
            ignore: [],
            rules: {
                intitule: {
                    required: true
                },
                type: {
                    required: true
                },
                maxMembres: {
                    required: true,
                    number: true,
                    min: 1,
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
