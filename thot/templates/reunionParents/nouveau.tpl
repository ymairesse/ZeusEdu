<div class="container-fluid">

    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" data-onglet="0" href="#page0">Page 1</a></li>
        <li><a data-toggle="tab" data-onglet="1" href="#page1">Page 2</a></li>
        <li><a data-toggle="tab" data-onglet="2" href="#page2">Page 3</a></li>
    </ul>

    <div class="tab-content">

        <div id="page0" class="tab-pane fade in active">
            {include file="reunionParents/nouveau/page1.tpl"}
        </div>

        <div id="page1" class="tab-pane fade">
            {include file="reunionParents/nouveau/page2.tpl"}
        </div>

        <div id="page2" class="tab-pane fade">
            {include file="reunionParents/nouveau/page3.tpl"}
        </div>

    </div>

</div>
<!-- container -->

<div id="modal"></div>

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

    var onglet = "{$onglet|default:''}";

    $(".nav-tabs li a[href='#page"+onglet+"']").tab('show');

    $.validator.addMethod('time', function(value, element, parem) {
        var t = value.split(':');
        return /^\d*\d:\d\d$/.test(value) &&
         t[0] >= 0 && t[0] < 25 &&
         t[1] >= 0 && t[1] < 60
    }, 'Une heure valide svp: HH:mm');

    // forçage de la présentation sous forme 00:00
    function formatHeure(h){
        t = h.split(':');
        t[0] = t[0]>9 ? t[0]:(t[0]==0?'00':'0'+t[0]);
        t[1] = t[1]>9 ? t[1]:(t[1]==0?'00':'0'+t[1]);
        return t[0]+':'+t[1];
    }

    $(document).ready(function() {

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

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

        $(".nav-tabs li a").click(function(){
            var onglet = $(this).data('onglet');
            $("input.onglet").val(onglet);
        })

        $("#creation").click(function() {
            if ($('#formPage1').valid() ){
                var formulaire = $('#formPage1').serialize();
                var dateFormulaire = $('#datepicker').val();
                var typeRP = $('.leType').val();
                var heureDebut = $('#debut').val();
                var heureFin = $('#fin').val();
                $('#leType').val(typeRP);
                $('#dateReunion').val(dateFormulaire);
                $('.minPer1').val(heureDebut);
                $('.maxPer2').val(heureFin);
                $.post('inc/reunionParents/listeHeures.inc.php', {
                    formulaire: formulaire
                }, function(resultat){
                    $("#tableHoraire").html(resultat);
                    // création de la liste des profs
                    $.post('inc/reunionParents/listeProfs.inc.php', {
                        formulaire: formulaire
                        },
                        function(resultat){
                            $("#listeProfs").html(resultat);
                        })
                    $("#saveRP").show();
                })
            };
        })

        // enregistrement de la page 1 du formulaire
        $('body').on('click', '#saveRP', function(){
            var formulaire = $('#formPage1').serialize();
            $.post('inc/reunionParents/savePage1.inc.php', {
                formulaire: formulaire
            }, function(resultatJSON){
                var resultat = JSON.parse(resultatJSON);
                var nb = resultat['nb'];
                var idRP = resultat['idRP'];
                bootbox.alert({
                    title: 'Prépartion de la réunion de parents',
                    message: '<strong>' + nb + ' périodes</strong> de RV enregistrées',
                    callback: function(){
                        // création du troisième onglet
                        $.post('inc/reunionParents/createListeLocaux.inc.php', {
                            idRP: idRP
                        }, function(resultat){
                            $('#page2').html(resultat);

                            $('.nav-tabs a[href="#page1"]').tab('show');
                            $('#formPage1 .btn').attr('disabled', true);
                            $('#formPage1 input:checkbox').attr('readonly', true);
                            $('#formDetails2 .btn').attr('disabled', false);
                            $('#formDetails2 fieldset').attr('disabled', false);
                            $('#btn-page2').data('idrp', idRP).attr('disabled', false);
                            $('#page1 .alert-info').toggleClass('hidden');
                            $('#formPage1 input').attr('disabled', true);
                            $('#btn-page3').data('idrp', idRP).attr('disabled', false);
                        })
                    }
                })
            })
        })

        $('#formDetails2').on('click', '#btn-page2', function(){
            var minPer1 = $('#minPer1').val(); minPer1 = (minPer1.length == 4) ? "0" + minPer1: minPer1;
            var maxPer1 = $('#maxPer1').val(); maxPer1 = (maxPer1.length == 4) ? "0" + maxPer1: maxPer1;
            var minPer2 = $('#minPer2').val(); minPer2 = (minPer2.length == 4) ? "0" + minPer2: minPer2;
            var maxPer2 = $('#maxPer2').val(); maxPer2 = (maxPer2.length == 4) ? "0" + maxPer2: maxPer2;
            var minPer3 = $('#minPer3').val(); minPer3 = (minPer3.length == 4) ? "0" + minPer3: minPer3;
            var maxPer3 = $('#maxPer3').val(); maxPer3 = (maxPer3.length == 4) ? "0" + maxPer3: maxPer3;

            if ((minPer1 < maxPer1) && (maxPer1 == minPer2) && (minPer2 < maxPer2) && (maxPer2 == minPer3) && (minPer3 < maxPer3)) {
                var formulaire = $('#formDetails2').serialize();
                var idRP = $(this).data('idrp');
                $.post('inc/reunionParents/savePage2.inc.php', {
                    formulaire: formulaire,
                    idRP: idRP,
                }, function(resultatJSON){
                    var resultat = JSON.parse(resultatJSON);
                    var nb = resultat['nb'];
                    var heures = resultat['heures'];
                    bootbox.alert({
                        title: 'Enregistrement',
                        message: nb + ' paramètre(s) et ' + heures + ' heure(s) enregistré(s)'
                    });
                    $('fieldset').removeClass('erreur');
                })
            }
            else bootbox.alert({
                title: 'Heures dans la liste d\'attente',
                message: 'Les heures semblent mal ajustées'
            })

        })

        $('body').on('click', '#btn-page3', function(){
            var formulaire = $('#formDetails3').serialize();
            var idRP = $(this).data('idrp');
            $.post('inc/reunionParents/savePage3.inc.php', {
                formulaire: formulaire,
                idRP: idRP
            }, function(resultat){
                bootbox.alert({
                    title: 'Enregistrement',
                    message: resultat
                })
            })
        })

        $("#datepicker").datepicker({
            format: 'dd/mm/yyyy',
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $(".heure").timepicker({
            minuteStep: 5,
            showMeridian: false
        });

        $("#setCanevas").validate({
            rules: {
                intervalle: {
                    required: true,
                    number: true,
                    range: [5, 60]
                },
                debut,
                fin: {
                    required: true,
                    time: true
                }
            }
        })

        // -------------------------------------------------
        $("#page0").on('click', '#attribHeures', function() {
            var checked = $(this).is(':checked');
            $(".cbHeure").prop("checked", checked);
        })
        $("#page0").on('click', '#attribProfs', function() {
            var checked = $(this).is(':checked');
            $(".cbProf").prop("checked", checked);
        })
        $("#page0").on('click', '#attribDir', function() {
            var checked = $(this).is(':checked');
            $(".dir").prop("checked", checked);
        })
        // -------------------------------------------------

    $('body').on('click', '.dir', function() {
        var acronyme = $(this).val();
        $("#prof_" + acronyme).prop('checked', true);
    })

    $("#maxPer1").change(function(){
        $("#minPer2").val($(this).val());
    })

    $("#minPer3").change(function(){
        $("#maxPer2").val($(this).val());
    })

    $('body').on('click', '#btn-delRP', function(){
        var idRP = $(this).data('idrp');
        $.post('inc/reunionParents/modalDelRP.inc.php', {
            idRP: idRP
        }, function(resultat){
            console.log(resultat);
            $('#modal').html(resultat);
            $('#modalDel').modal('show');
        })
    })

    $('#modal').on('click', '#btn-modalDel', function(){
        var idRP = $(this).data('idrp');
        $.post('inc/reunionParents/confirmDelRP.inc.php', {
            idRP: idRP
        }, function(resultat){
            $('#selecteur').html(resultat);
            $('#modalDel').modal('hide');
            $('#formSelecteur').trigger('submit');
        })
    })

    })
</script>
