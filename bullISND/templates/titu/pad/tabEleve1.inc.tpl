<div class="row">

<div class="col-md-6 col-sm-12">

    <div class="panel panel-primary">
        <div class="panel-heading">
            Identification
        </div>
        <div class="panel-body">
            <p>Nom: <strong>{$eleve.nom}</strong> Prénom: <strong>{$eleve.prenom}</strong>
                <img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="img-responsive ombre" style="float:left; width:75px; margin-right:2em;"></p>
            <p>Classe: <strong>{$eleve.classe}</strong> Titulaire(s): <strong>{$titulaires|implode:', '}</strong></p>
            <p>Sexe: <strong>{$eleve.sexe}</strong> Âge: <strong>{$eleve.age.Y} ans {$eleve.age.m} mois et {$eleve.age.d} jours</strong></p>
        </div>
    </div>

    <div class="panel panel-info">
        <div class="panel-heading">
            Mentions
        </div>
        <div class="panel-body">
            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th>Année scolaire</th>
                        <th>
                            <button type="button"
                                class="btn btn-success btn-xs"
                                title="Voir toutes les années"
                                id="btn-showAll"><i class="fa fa-arrow-down"></i>
                            </button> Année</th>
                        {foreach from=range(1, $maxPeriodes) key=wtf item=periode}
                        <th>Période</th>
                        <th>Mention</th>
                        {/foreach}
                    </tr>
                </thead>
                <tbody>
                    {if isset($mentions.$matricule)}
                        {foreach from=$mentions.$matricule key=anScol item=data name=boucle}
                        <tr {if $smarty.foreach.boucle.last != $smarty.foreach.boucle.iteration}style="display:none" class="resultatsScolaires"{/if}>
                            <td>{$anScol}</td>
                            {foreach from=$data key=annee item=lesMentions}
                                <td>{$annee}e</td>
                            {/foreach}
                            {foreach from=$lesMentions key=periode item=laMention}
                                <td>{$periode}</td>
                                <td><strong>{$laMention}</strong></td>
                            {/foreach}
                        </tr>
                        {/foreach}
                    {/if}
                </tbody>
            </table>

        </div>
    </div>
</div>


<div class="col-md-6 col-sm-12">

    {assign var=idProprio value=$padsEleve.proprio|key}

    {* s'il n'y a pas de pad "guest", il ne faut pas montrer des onglets *}
    {if $padsEleve.guest|count > 0}
    <ul class="nav nav-tabs">
        <li class="active"><a href="#tab{$idProprio}" data-toggle="tab">{$padsEleve.proprio.$idProprio.proprio}</a></li>
        {foreach from=$padsEleve.guest key=id item=unPad}
        <li><a href="#tab{$id}" data-toggle="tab">{$unPad.proprio}
            {if $unPad.mode == 'rw'}<img src="images/padIco.png" alt=";o)">{/if}
            </a></li>
        {/foreach}
    </ul>
    {/if}

    <div class="tab-content">
        <form id="formPadEleve">
            <div class="tab-pane active" id="tab{$idProprio}">
                <textarea
                    name="texte_{$idProprio}"
                    id="texte_{$idProprio}"
                    rows="20"
                    class="summernote form-control"
                    placeholder="Frappez votre texte ici"
                    >{$padsEleve.proprio.$idProprio.texte}</textarea>
            </div>

            {foreach from=$padsEleve.guest key=id item=unPad}
            <div class="tab-pane" id="tab{$id}">
                <textarea
                    name="texte_{$id}"
                    id="texte_{$id}"
                    data-anscol="{$anScol}"
                    rows="20"
                    class="summernote form-control"
                    placeholder="Frappez votre texte ici"
                    autofocus="true"
                    {if $unPad.mode !='rw' } disabled="disabled" {/if}
                    >{$unPad.texte}</textarea>
            </div>
            {/foreach}
        </form>
        <button type="button" id="btn-savePad" class="btn btn-primary btn-block">Enregistrer</button>

    </div>

</div>

</div>
<div class="clearfix"></div>

{* ---------------------------------------------------------------------- *}


<script type="text/javascript">


function sendFile(file, el) {
	var form_data = new FormData();
	form_data.append('file', file);
	$.ajax({
		data: form_data,
		type: "POST",
		url: 'editor-upload.php',
		cache: false,
		contentType: false,
		processData: false,
		success: function(url) {
			$(el).summernote('editor.insertImage', url);
		}
	});
}

function deleteFile(src) {

	$.ajax({
		data: { src : src },
		type: "POST",
		url: 'inc/deleteImage.inc.php',
		cache: false,
		success: function(resultat) {
			console.log(resultat);
			}
	} );
	}

	var modifie = false;

	$(document).ready(function(){

        $('.summernote').summernote({
            lang: 'fr-FR', // default: 'en-US'
            height: null, // set editor height
            minHeight: 150, // set minimum height of editor
            focus: true, // set focus to editable area after initializing summernote
            toolbar: [
              ['style', ['style']],
              ['font', ['bold', 'underline', 'clear']],
              ['font', ['strikethrough', 'superscript', 'subscript']],
              ['color', ['color']],
              ['para', ['ul', 'ol', 'paragraph']],
              ['table', ['table']],
              ['insert', ['link', 'picture', 'video']],
              ['view', ['fullscreen', 'codeview', 'help']],
            ],
            maximumImageFileSize: 2097152,
            dialogsInBody: true,
            callbacks: {
                onImageUpload: function(files, editor, welEditable) {
                    for (var i = files.length - 1; i >= 0; i--) {
                        sendFile(files[i], this);
                    }
                },
                onMediaDelete : function(target) {
                    deleteFile(target[0].src);
                }
            }
        })

        $('input:text, textarea').attr('maxlength', 128);

        $('#btn-showAll').click(function(){
            $('.resultatsScolaires').toggle();
        })

        $('#btn-savePad').click(function(){
			var formulaire = $('#formPadEleve').serialize();
			$.post('inc/titu/savePadEleve.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				bootbox.alert({
					title: 'Enregistrement',
					message: resultat + ' bloc-notes enregistré(s)'
				});
			})
		})

        function modification() {
			if (!(modifie)) {
				modifie = true;
                $(window).bind('beforeunload', function() {
					var reponse = confirm();
                    $('#wait').hide();
					return reponse
				})
			}
		}

		$("textarea, input:text").keyup(function(e) {
			var readonly = $(this).attr("readonly");
			if (!(readonly)) {
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
				if ((key > 31) || (key == 8)) {
					modification();
				}
			}
		})

		// le copier/coller provoque aussi  une "modification"
		$("input, textarea").bind('paste', function() {
			modification()
		});

	})

</script>
