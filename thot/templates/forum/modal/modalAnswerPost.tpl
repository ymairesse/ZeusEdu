<div id="modalAnswerPost" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAnswerPostLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="modalAnswerPostLabel">
                    {if isset($postAncien.from)}
                    En réponse à {$postAncien.from}
                    {else}
                    Nouvelle contribution au sujet
                    {/if}
                </h4>
            </div>
            <div class="modal-body">
                {if isset($postAncien.from)}
                <label for="texteAncien">{$postAncien.from} écrivait</label>
                <div style="height:5em; overflow:auto; border: 1px solid #aaa; background-color: #eee; padding: 0.5em; margin-bottom :1em;">
                    {$postAncien.post}
                </div>

                {/if}
                <form id="formModalAnswer">
                    <label for="myPost">
                        {if isset($postAncien.from)}
                        Je lui réponds
                        {else}
                        Ma contribution
                        {/if}
                    </label>
                    <textarea name="myPost" id="myPost" rows="5" class="form-control"></textarea>

                    <div class="col-xs-4">
                        <div class="checkbox pull-left">
                            <label><input type="checkbox" name="subscribe" value="1"{if $isAbonne} checked{/if}>Je m'abonne à ce sujet</label>
                        </div>
                    </div>
                    <div class="col-xs-8">
                        <p class="discret"><i class="fa fa-info-circle"></i> Abonnez-vous pour recevoir un avertissement sur votre adresse mail à chaque contribution à ce sujet.</p>
                    </div>

                    <input type="hidden" name="postId" id="postId" value="{$postAncien.postId}">
                    <input type="hidden" name="idSujet" id="idSujet" value="{$postAncien.idSujet}">
                    <input type="hidden" name="idCategorie" id="idCategorie" value="{$postAncien.idCategorie}">
                    <div class="clearfix"></div>
                </form>
            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" id="resetNewPost">Annuler</button>
                    <button type="button" class="btn btn-primary" id="saveNewPost">Enregistrer</button>
                </div>
            </div>
        </div>
    </div>
</div>

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

    $(document).ready(function() {

        $('#resetNewPost').click(function() {
            $('#myPost').val('');
        })

        $('#myPost').summernote({
			lang: 'fr-FR', // default: 'en-US'
			height: null, // set editor height
			minHeight: 150, // set minimum height of editor
			focus: true, // set focus to editable area after initializing summernote
            styleTags: [
               'p',
                   { title: 'Blockquote', tag: 'blockquote', className: 'blockquote', value: 'blockquote' },
                   'pre', 'h1', 'h2'
               ],
			toolbar: [
              ['style', ['style']],
              ['font', ['bold', 'underline', 'clear']],
              ['font', ['strikethrough', 'superscript', 'subscript']],
              ['fontname', ['fontname']],
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
                    console.log(target[0].src);
                    deleteFile(target[0].src);
                }
			}
		});

        $('#formModalAnswer').validate({
            rules: {
                myPost: {
                    required: true,
                    minlength: 20
                }
            }
        })
    })
</script>
