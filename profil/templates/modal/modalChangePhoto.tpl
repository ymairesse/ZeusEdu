<div class="modal fade" id="modalChangePhoto" tabindex="-1" role="dialog" aria-labelledby="titleChangePhoto" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="titleChangePhoto">Changer la photo de profil</h4>
      </div>
      <div class="modal-body">
          <div class="row">
      		<div class="col-md-5 col-sm-6">
      			<h3>Sélectionnez une photo</h3>
                <div id="myDropZone" class="dropzone"></div>
      		</div>

      		<div class="col-md-3 col-sm-6">
      			<p>Photo actuelle</p>
                <div class="photoProfil">

                    {include file="photoProfil.tpl"}

                </div>

      		</div>

      		<div class="col-md-4 col-sm-12">
      			<div class="notice">
      				<p>Vous pouvez envoyer un fichier de taille maximale <strong>2 Méga octets</strong>. Seules les images de type <strong>.jpg, png et gif</strong> sont autorisées</p>
      			</div>
      		</div>  <!-- col-md ... -->

      	</div> <!-- row -->

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

$(document).ready(function(){

    // var nbFichiersMax = 1;
    // var maxFileSize = 4;
    //
    // Dropzone.options.myDropZone = {
    //     maxFilesize: maxFileSize,
    //     maxFiles: nbFichiersMax,
    //     acceptedFiles: "image/jpeg,image/png,image/gif",
    //     url: "inc/upload.inc.php",
    //     queuecomplete: function() {
    //         // raffraîchissement de la photo
    //         $.post('inc/refreshPhoto.inc.php',{},
    //         function(resultat){
    //             $(".photoProfil").html(resultat);
    //         })
    //
    //     },
    //     accept: function(file, done) {
    //         done();
    //     },
    //     init: function() {
    //         this.on("maxfilesexceeded", function(file) {
    //                 alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
    //             }),
    //             this.on('queuecomplete', function() {
    //                 var ds = this;
    //                 setTimeout(function() {
    //                     ds.removeAllFiles();
    //                 }, 3000);
    //             })
    //     }
    // };

})

</script>
