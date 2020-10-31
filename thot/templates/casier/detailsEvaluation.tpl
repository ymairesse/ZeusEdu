<form class="form-vertical" id="evalTravail">

    <div class="row">

        <div class="col-sm-2">
            <img src="{$BASEDIR}photos/{$photo}.jpg" alt="{$matricule}" class="img-responsive">
        </div>

        <div class="col-sm-10">
            <button type="button"
                    class="btn btn-info btn-sm pull-right"
                    id="consignes"
                    title="Consignes"
                    data-idtravail="{$infoTravail.idTravail|default:'-'}">
                <i class="fa fa-graduation-cap"></i>
            </button>

            {if $fileInfos != NULL}
                {foreach from=$fileInfos key=wtf item=dataFile}
                    <div class="fichier">
                        <a href="inc/download.php?type=pTrEl&amp;idTravail={$idTravail}&amp;matricule={$matricule}&amp;fileName={$dataFile.fileName}">
                            <span class="fileImage" style="display:block;"></span>
                            <strong>{$dataFile.fileName}<br></strong>
                        </a>
                        <span class="nomFichiers">
                            {$dataFile.size}<br>
                            {$dataFile.dateRemise}
                        </span>
                    </div>
                {/foreach}
                {else}
                En attente de remise
            {/if}
            <div class="clearfix"></div>

           <div class="form-group">
             <label for="remarque">Remarque de l'élève</label>
             <p id="remarque">{$evaluationsTravail.remarque|default:'-'}</p>
           </div>

        </div>

    </div>

        <table class="table table-condensed">
            <thead>
                <tr>
                    <th style="width:70%">Compétences</th>
                    <th style="width:10%">Form/Cert</th>
                    <th style="width:10%">
                        Cote
                        <span
                            class="pull-right smallNotice pop"
                            data-content="Mentions admises: <strong>{$COTEABS}</strong> <br>Toutes ces mentions sont neutres <br><strong>{$COTENULLE}</strong><br>La cote est nulle"
                            data-html="true"
                            data-container="body"
                            data-placement="left">
                        </span>
                    </th>
                    <th style="width:10%">Max</th>
                </tr>
            </thead>
            <tbody>
                {if count($competencesTravail) > 0}
                    {foreach from=$competencesTravail key=idCompetence item=data name=boucle}
                    <tr>
                        <td>{$data.libelle}</td>
                        <td>{if $data.formCert == 'form'}Formatif{else}Certificatif{/if}</td>
                        <td>
                            <input
                                type="text"
                                name="cote_{$idCompetence}"
                                class="form-control input-sm cote"
                                value="{$evaluationsTravail.cotes.$idCompetence.cote|default:''}"
                                tabindex="{$smarty.foreach.boucle.iteration}">
                        </td>
                        <td>
                            <strong>/ {$data.max}</strong>
                            <input type="hidden" name="max_{$idCompetence}" class="maxCompetence" value="{$data.max|default:''}">
                        </td>
                    </tr>
                    {assign var=n value=$smarty.foreach.boucle.iteration}
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="4">
                            <i class="fa fa-warning text-danger"></i> Vous n'avez pas encore indiqué les compétences exercées pour ce travail
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    {assign var=n value=$n+1}
    <button type="button" tabindex="{$n}" class="btn btn-primary btn-block" id="saveEval">Enregistrer</button>
    {assign var=n value=$n+1}
    <div class="form-group">
        <label for="evaluation">Évaluation du professeur</label>
        <textarea name="evaluation" class="form-control" id="texte" tabindex="{$n}">{$evaluationsTravail.commentaire|default:''}</textarea>
    </div>

    <input type="hidden" name="idTravail" value="{$infoTravail.idTravail}">
    <input type="hidden" name="matricule" id="matriculeEval" value="{$matricule}">

</form>

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
    	console.log(src);
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

    $(document).ready(function(){

        $('#texte').summernote({
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
        });

        $("input").tabEnter();

        $('input.cote').first().focus();

        $(".pop").popover({
            trigger:'hover'
            });

        // remplacer la virgule par un point dans la cote
        $(".cote").blur(function(e) {
            laCote = $(this).val().replace(',', '.');
            $(this).val(laCote);
        })

    })

</script>
