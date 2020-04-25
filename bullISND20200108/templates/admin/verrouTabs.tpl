<div class="container">

    <div class="row">
        <div class="col-xs-12">

            <ul class="nav nav-tabs nav-justified">
                {if isset($niveau)}
                <li class="active"><a data-toggle="tab" href="#vide">Classes:</a></li>
                {/if}
                {foreach from=$listeClasses item=uneClasse name=compteur}
                    <li><a data-toggle="tab" href="#{$uneClasse}" data-classe="{$uneClasse}" data-generated="false" class="onglet">{$uneClasse}</a></li>
                {/foreach}
            </ul>

            <div class="tab-content">
                <div id="vide" class="tab-pane fade in active">
                    {if isset($niveau)}
                    <p class="avertissement">Veuillez choisir une classe</p>
                    {/if}
                </div>
                {foreach from=$listeClasses item=uneClasse}

                    <div id="{$uneClasse}" class="tab-pane fade in">


                    </div>

                {/foreach}
            </div>

        </div>
    </div>

</div>

{include file="titu/modalLocks.tpl"}

<script type="text/javascript">

    $(document).ready(function(){

        $('.onglet').click(function(){
            if ($(this).data('generated') == false) {
                var classe = $(this).data('classe');
                var periode = $('#periode').val();
                $.post('inc/titu/refreshVerrous.inc.php', {
                    classe: classe,
                    periode: periode
                }, function(resultat){
                    $('#'+classe).html(resultat);
                })
                // noter qu'il ne faut pas régénérer à la prochaine visite
                $(this).data('generated', 'true');
                }
        })

        $('body').on('click', '#btnPutLocks', function(){
    		var formulaire = $('#formLocks').serialize();
    		$.post('inc/titu/setVerrous.inc.php', {
    			formulaire: formulaire
    		}, function(resultat){
    			var classe = $('.nav-tabs li.active a').data('classe');
    			var periode = $('#periode').val();
    			$.post('inc/titu/refreshVerrous.inc.php', {
    				classe: classe,
    				periode: periode
    			},
    			function(resultat){
    				$('#'+classe).html(resultat);
    			})
    			bootbox.alert(resultat + " verrous ont été modifiés");
    			$('#modalLocks').modal('hide');
    		})
    	})

        $('body').on('click', '.changeLocks', function(){
    		var type = $(this).data('type');
    		var item = $(this).data('item');
    		var periode = $('#periode').val();
    		var classe = $('.nav-tabs li.active a').data('classe');
    		$.post('inc/titu/formLocks.inc.php', {
    			type: type,
    			item: item,
    			periode: periode,
    			classe: classe
    		}, function(resultat){
    			$('#modalLocks .formulaire').html(resultat);
    			$('#modalLocks').modal('show');
    		})
    	})

    })

</script>
