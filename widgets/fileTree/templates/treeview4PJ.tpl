<script type="text/javascript" src="../widgets/fileTree/dropzone.js"></script>
<link rel="stylesheet" href="../widgets/fileTree/css/dropzone.css">
<link rel="stylesheet" href="../widgets/fileTree/css/filetree.css">

<div id="modalAddPj" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddPjLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddPjLabel">Joindre des fichiers</h4>
      </div>
      <div class="modal-body">
          <div class="row" style="height: 20em; overflow: auto;" id="repertoire">

              <div class="col-md-9 col-xs-12" style="max-height:20em; overflow: auto;" id="tree">
                  {* emplacement pour l'arborescence des fichiers *}
              </div>

              <div class="col-md-3 col-xs-12" style="height:15em;">
                  <div class="micro" id="activeDir" data-path="/">/</div>
                  <div class="dropzone" id="myDropZone" style="height: 100%"></div>
              </div>

          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" aria-label="Close">Terminer</button>
      </div>
    </div>
  </div>
</div>

<div class="row" id="FTwidget">
    <div class="col-sm-9 col-xs-12">
        <ul id="PjFiles" class="PjFiles list-unstyled" style="min-height: 2em;">

            {if isset($pjFiles) && ($pjFiles|@count > 0)}
                {foreach from=$pjFiles key=shareId item=data}
                <li>
                    <button type="button"
                        class="btn btn-danger btn-xs FTdelPJ"
                        data-path="{$data.path}"
                        data-filename="{$data.fileName}">
                        <i class="fa fa-times" title="Supprimer"></i>
                    </button>
                    <a
                    href="../widgets/fileTree/inc/download.php?type=pfN&f={$data.path}{$data.fileName}"
                    data-path="{$data.path}"
                    data-filename="{$data.fileName}"
                    data-shareid="{$data.shareId}"
                    data-id="{$data.shareId}"
                    title="{$data.path}{$data.fileName}"
                    draggable="false">
                    {$data.path}{$data.fileName}
                    </a>
                    <input type="hidden" name="files[]" class="files" value="{$data.shareId}|//|{$data.path}|//|{$data.fileName}">
                </li>
                {/foreach}
            {/if}

        </ul>
    </div>
    <div class="col-sm-3 col-xs-12">
        <button type="button" class="btn btn-info btn-block" id="btn-addPJ"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i> PJ</button>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        var nbFichiersMax = 5;
        var maxFileSize = 25;
        var acceptedFiles = "image/jpeg,image/png,image/gif,image/svg+xml,application/pdf,.psd,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.odt,.ods,.odp,.odg,.csv,.txt,.pdf,.zip,.7z,.ggb,.mm,.xcf,.xmind,.rtf,.mp3";

        Dropzone.options.myDropZone = {
            maxFilesize: maxFileSize,
            maxFiles: nbFichiersMax,
            url: "../widgets/fileTree/inc/upload.inc.php",
            acceptedFiles: acceptedFiles,
            queuecomplete: function() {
                var activeDir = $('#activeDir').data('path');
                activeDir = (activeDir == undefined) ? '/' : activeDir;
                // raffraichissement de la liste des fichiers
        		var level;
        		if (activeDir == '/')
        			level = 0;
        			else level = $('.activeDir').next('ul').data('level');
                $.post('../widgets/fileTree/inc/refreshFileList.inc.php', {
                    activeDir: activeDir,
                    level: level
                }, function(resultat){
        			if (level > 0)
                    	$('.activeDir').next('ul').replaceWith(resultat);
        				else {
        					$('.file.level0').remove();
        					$('.filetree').eq(0).append(resultat);
        				}
                    // remise en ordre des fichiers sélectionnés
                    $('#PjFiles li a').each(function(){
                        var path = $(this).data('path');
                        if (path == activeDir) {
                            var fileName = $(this).data('filename');
                            $('input[data-path="' + path + '"]').filter('[data-filename="' + fileName + '"]').prop('checked', true);
                        }
                    })
                })
            },
            accept: function(file, done) {
                done();
            },
            success: function(file, response){
                var activeDir = $('#activeDir').data('path');
                var fileName = file.name;
            },
            init: function() {
                    this.on("maxfilesexceeded", function(file) {
                        alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
                    }),
                    this.on('sending', function(file, xhr, formData) {
                        formData.append('activeDir', $('#activeDir').data('path'));
                    }),
                    this.on('queuecomplete', function() {
                        var dz = this;
                        setTimeout(function() {
                            dz.removeAllFiles();
                        }, 3000);
                    })
            }
        };

        $('#myDropZone').dropzone();

        $('#btn-addPJ').click(function(){
            $('#modalAddPj').modal('show');
                var rep = ($('#tree').find('.filetree').html());
                // ne pas recharger le répertoire s'il a déjà été exposé
                if (rep == undefined) {
                    // les fichiers actuellement joints sont dans la class "files" (input hidden)
                    var files = $('.files').serialize();
                    $.post('../widgets/fileTree/inc/getTree.inc.php', {
                        files: files
                    }, function(resultat){
                        $('#tree').html(resultat);
                    })
                }
        })

        $('#modalAddPj').on('click', '.dirLink', function() {
            var activeDir = $(this).data('path');
            $('#activeDir').html(activeDir);
            $('#activeDir').data('path', activeDir);
			$(this).next('.filetree').toggle('slow');
			$(this).closest('li').toggleClass('expanded');
			$('.dirLink').removeClass('activeDir');
			$(this).addClass('activeDir');
		})

        $('#repertoire').on('click', '.file a', function(e){
            e.stopPropagation();
        })

        $('#repertoire').on('click', '.file', function(){
            var fileName = $(this).closest('li').data('filename');
			var path = $(this).closest('li').data('path');
            $(this).find('input').trigger('click');
        })

		$('#repertoire').on('click', '.selectFile', function(e){
			var fileName = $(this).closest('li').data('filename');
			var path = $(this).closest('li').data('path');

			if ($(this).prop('checked') == true) {
				$('#PjFiles').append('<li><button type="button" class="btn btn-danger FTdelPJ btn-xs"><i class="fa fa-times" title="Supprimer"></i></button> <a href="../widgets/fileTree/inc/download.php?type=pfN&f='+path + fileName+'" data-path="' + path + '" data-filename="' + fileName + '" data-shareid="-1" title="' + path + fileName +'" draggable="false"> ' + path + fileName + '</a> <input type="hidden" name="files[]" value="-1|//|' + path + '|//|' + fileName + '"></li>');
			}
			else {
                var shareId = $('#PjFiles').find('[data-path="' + path + '"][data-filename="' + fileName + '"]').data('shareid');
                var id =  $('#PjFiles').find('[data-path="' + path + '"][data-filename="' + fileName + '"]').data('id');
                $.post('inc/jdc/delPj.inc.php', {
                    id: id,
                    shareId: shareId
                }, function(){});
				$('#PjFiles').find('[data-path="' + path + '"][data-filename="' + fileName + '"]').parent().remove();
			}
            e.stopPropagation();
		})

        $('#FTwidget').on('click', '.FTdelPJ', function(){
            var path = $(this).data('path');
            var fileName = $(this).data('filename');
            $(this).closest('li').remove();
            // la PJ sera effectivement supprimée au moment de l'enregistrement
        })

    })

</script>
