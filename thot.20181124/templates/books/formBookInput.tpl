<div class="container-fluid">

    <div class="row">

        <h3><span id="newCreate">{if $mode == 'new'}Création {else}Mise à jour {/if}</span>d'une fiche</h3>
        <form id="bookForm">

            <div class="col-md-4 col-sm-12">

                <label for="isbn">ISBN</label>
                <div class="form-group">
                    <div class="input-group input-group-lg">
                        <span class="input-group-btn">
                            <button class="btn btn-success" type="button" id="btn-isbnInfo"><i class="fa fa-question"></i></button>
                        </span>
                        <input type="text" class="form-control typeahead" name="isbn" id="isbn" value="{$book.isbn|default:''}" placeholder="ISBN (10 ou 13 chiffres)" autocomplete="off" data-minlength="4" tabindex="11">
                        <span class="input-group-btn">
                            <button class="btn btn-danger" type="button" id="btn-isbn" tabindex="12"><i class="fa fa-eye"></i></button>
                        </span>
                    </div>
                </div>
                <small class="help-block">Cliquer sur l'<i class="fa fa-eye"></i> pour compléter la fiche</small>

                <fieldset class="form-group">
                    <label for="titre">Titre de l'ouvrage</label>
                    <input type="text" class="form-control typeahead" name="titre" id="titre" value="{$book.titre|default:''}" placeholder="Titre de l'ouvrage" autocomplete="off" data-minlength="4" tabindex="1" required>
                </fieldset>

                <fieldset class="form-group">
                    <label for="sousTitre">Sous-titre</label>
                    <input type="text" class="form-control typeahead" name="sousTitre" id="sousTitre" value="{$book.sousTitre|default:''}" placeholder="Sous-titre" autocomplete="off" data-minlength="4" tabindex="2">
                </fieldset>

                <label for="auteur">Auteur(s)</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" class="form-control typeahead" name="auteur" id="nom" value="{$book.auteur|default:''}" placeholder="Nom, prénom de l'auteur" autocomplete="off" data-minlength="2" tabindex="3">
                        <span class="input-group-btn">
                        <button class="btn btn-success" type="button" id="btn-addAuteur" tabindex="4"><i class="fa fa-plus"></i></button>
                        </span>
                    </div>
                </div>
                <small class="help-block">Nom, prénom séparés par une virgule. Cliquer sur + pour ajouter un auteur</small>

                <div id="lesAuteurs">
                    {if isset($book.auteurs)}
                    {foreach from=$book.auteurs key=idAuteur item=auteur}
                        {include file='books/newAuteur.tpl'}
                    {/foreach}
                    {/if}

                </div>

            </div>

            <div class="col-md-4 col-sm-12">

                <fieldset class="form-group">
                    <label for="editeur">Éditeur</label>
                    <input type="text" class="form-control typeahead" name="editeur" id="editeur" value="{$book.editeur|default:''}" placeholder="Éditeur" autocomplete="off" data-minlength="2" tabindex="5" required>
                </fieldset>

                <fieldset class="form-group">
                    <label for="annee">Année d'édition</label>
                    <input type="text" class="form-control" name="annee" id="annee" value="{$book.annee|default:''}" placeholder="Année" autocomplete="off" tabindex="6" required>
                </fieldset>

                <fieldset class="form-group">
                    <label for="lieu">Lieu d'édition</label>
                    <input type="text" class="form-control typeahead" name="lieu" id="lieu" value="{$book.lieu|default:''}" placeholder="Lieu d'édition" autocomplete="off" data-minlength="2" tabindex="7">
                </fieldset>

                <fieldset class="form-group">
                    <label for="collection">Collection</label>
                    <input type="text" class="form-control typeahead" name="collection" id="collection" value="{$book.collection|default:''}" placeholder="Collection" autocomplete="off" data-minlength="2" tabindex="8">
                </fieldset>

            </div>

            <div class="col-md-4 col-sm-12">

                <fieldset class="form-group">
                    <label for="etat">État du volume</label>
                    <select class="form-control" name="etat" id="etat">
                        <option value="indetermine">Indéterminé</option>
                        <option value="neuf"{if (isset($book.etat)) && ($book.etat=='neuf')} selected{/if}>Neuf</option>
                        <option value="TB"{if (isset($book.etat)) && ($book.etat=='TB')} selected{/if}>Très bon</option>
                        <option value="B"{if (isset($book.etat)) && ($book.etat=='B')} selected{/if}>Bon</option>
                        <option value="correct"{if (isset($book.etat)) && ($book.etat=='correct')} selected{/if}>Correct</option>
                    </select>
                </fieldset>

                <fieldset class="form-group">
                    <label for="exemplaire">N° Exemplaire</label>
                    <input type="text" class="form-control typeahead" name="exemplaire" id="exemplaire" value="{$book.exemplaire|default:''}" placeholder="N° exemplaire" autocomplete="off" data-minlength="2" tabindex="9">
                </fieldset>

                <fieldset class="form-group">
                    <label for="cdu">CDU</label>
                    <input type="text" class="form-control typeahead" name="cdu" id="cdu" value="{$book.cdu|default:''}" placeholder="CDU" autocomplete="off" data-minlength="2" tabindex="10">
                </fieldset>

            </div>

            <div class="col-xs-12" style="border: 1px solid black; padding: 1em; margin: 1em;">

                {if isset($book.idBook) && ($book.idBook != '')}
                <div class="btn-group">
                    <button type="button" class="btn btn-blue" id="btn-newBook">Ajouter un ouvrage</button>
                    <button type="button" class="btn btn-danger" data-idbook="{$book.idBook}" id="btn-delBook">Supprimer cet ouvrage</button>
                </div>
                {/if}

                <div class="btn-group pull-right">
                    <button type="reset" class="btn btn-default" tabindex="12">Annuler</button>
                    <button type="button" class="btn btn-primary" id="saveBook" tabindex="13">Enregistrer</button>
                </div>

                <input type="hidden" name="idBook" id="idBook" value="{$book.idBook|default:''}">
                <input type="hidden" name="field" id="field" value="">
                <input type="hidden" name="minLength" id="minLength" value="">
                <input type="hidden" name="mode" id="mode" value="{$mode}">
            </div>
            <div class="clearfix"></div>
        </form>

    </div>

</div>

{include file="books/modal/modalISBN.tpl"}

<script type="text/javascript">
    $(document).ready(function() {

        $("#bookForm").validate({
            rules: {
                auteur: {
                    required: function(element) {
                        return $(".listeAuteurs").length == 0;
                    }
                },
                auteurs: {
                    required: function(element) {
                        return $("#auteur").is(':empty');
                    }
                }
            }
        });

        $("#btn-newBook").click(function(){
            $("#bookForm").find("input[type=text], textarea").val("");
            $("#etat").val('indetermine');
            $("#idBook, #field").val('');
            $("#lesAuteurs").html('');
            $("#btn-newBook, #btn-delBook").hide();
            $("#isbn").focus();
            $("#mode").val('new');
            $("#newCreate").text('Création ');
            $('.lesAuteurs').each(function(i, input) {
                $(input).val('');
            })

        })

        $("#btn-delBook").click(function() {
            bootbox.confirm(
                "Veuillez confirmer l'effacement du livre",
                function(resultat) {
                    if (resultat == true) {
                        var idBook = $("#btn-delBook").data('idbook');
                        $.post('inc/books/delBook.inc.php', {
                            idBook: idBook
                        },
                        function(n){
                            bootbox.alert({
                                message: n+' ouvrage supprimé',
                                callback: function(){
                                    $("#isbn").focus();
                                }
                            });
                            $("#bookForm").find("input[type=text], textarea").val("");
                            $('.lesAuteurs').each(function(i, input) {
                                $(input).val('');
                            })
                            $("#lesAuteurs").html('');
                            $("#btn-newBook, #btn-delBook").hide();

                        })
                    }
                });
        })

        $("#saveBook").click(function() {
            if ($("#bookForm").valid()) {
                var formulaire = $("#bookForm").serialize();
                $.post('inc/books/saveBook.inc.php', {
                        formulaire: formulaire
                    },
                    function(resultat) {
                        $("#formulaire").html(resultat);
                        bootbox.alert('Ce livre a été enregistré')
                    })
            }
        })

        $("#btn-accepterISBN").click(function() {
            var titre = $("#modalTitre").val();
            $("#titre").val(titre);
            var sousTitre = $("#modalSousTitre").val();
            $("#sousTitre").val(sousTitre);
            var lesAuteurs = $(".modalLesAuteurs");
            $.each(lesAuteurs, function(i, input) {
                var texte = "<div class='input-group'>" +
                    "<span class='input-group-btn'> " +
                    "<button type='button' class='btn btn-danger btn-sm btn-delAuteur' data-idbook='' data-idauteur=''>" +
                    "<i class='fa fa-minus'></i></button>" +
                    "</span>" +
                    "<input type='text' class='form-control listeAuteurs' readonly name='auteurs[]' value='" + input.value + "'>" +
                    "</div>";

                $("#lesAuteurs").append(texte);
            });
            var editeur = $("#modalEditeur").val();
            $("#editeur").val(editeur);
            var annee = $("#modalAnnee").val();
            $("#annee").val(annee);

            $("#modalISBN").modal('hide');
        })

        $("#btn-isbn").click(function() {
            var isbn = $("#isbn").val();
            if (isbn != '') {
                $.post('inc/books/getDataFromISBN.inc.php', {
                    isbn: isbn
                }, function(resultat) {
                    $("#modalISBN .modal-body").html(resultat);
                    $("#modalISBN").modal('show');
                })
            } else {
                bootbox.alert({
                    title: 'Attention',
                    message: 'Veuillez fournir un ISBN'
                });
            }
        })

        $("#btn-isbnInfo").click(function() {
            var isbn = $("#isbn").val();
            if (isbn != '') {
                var url = "https://www.abebooks.fr/servlet/SearchResults?ds=20&kn=" + isbn + '&sts=t';
                var win = window.open(url, '_blank');
                win.focus();
            }
        })

        $("#lesAuteurs").on('click', ".btn-delAuteur", function() {
            var idBook = $(this).data('idbook');
            if (idBook != '') {
                var idAuteur = $(this).data('idauteur');
                $.post('inc/books/delidBookidAuteur.inc.php', {
                        idBook: idBook,
                        idAuteur: idAuteur
                    },
                    function() {

                    })
            }
            $(this).closest('.input-group').remove();
        })

        $("#btn-addAuteur").click(function() {
            var auteur = $("#nom").val();
            var count = (auteur.match(/,/g) || []).length;
            if (auteur != '') {
                if (count == 1) {
                    $.post('inc/books/addAuteur.inc.php', {
                            auteur: auteur
                        },
                        function(resultat) {
                            $("#lesAuteurs").append(resultat);
                        })
                } else bootbox.alert({
                    message: 'Une seule virgule entre le nom et le prénom'
                })
            }
        })

        $(".typeahead").focus(function() {
            var field = $(this).attr('id');
            $("#field").val(field);
            var minLength = $("#" + field).data('minlength');
            $("#minLength").val(minLength);

        })

        $(".typeahead").typeahead({
            minLength: $("#minLength").val(),
            delay: 500,
            source: function(query, process) {
                $.post('inc/books/searchItem.inc.php', {
                        'query': query,
                        'champ': $("#field").val(),
                        'minLength': $("#minLength").val()
                    },
                    function(data) {
                        if (data.length > 0)
                            process(JSON.parse(data));
                    }
                );
            }
        })

    })
</script>
