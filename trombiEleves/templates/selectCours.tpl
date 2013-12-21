<script type="text/javascript">
{literal}

function cacheEtVide (){
	$("#trombinoscope").html("");
	$("#detailsEleve").html("");
	$(".filename").html("");
	$("#selectCours").hide();
	$("#selectGroupe").hide();
	$("#selecteurEleve").hide();
	$(".btn").hide();
	$("#selectTop").show();
	}

$(document).ready(function(){
    // sera appelé au démarrage et à l'arrêt d'une fonction Ajax
    $().ajaxStart($.blockUI).ajaxStop($.unblockUI);
  	
    // au changement de sélection du cours dans la liste déroulante
    $("#selectCours").change(function(){
		var cours = $(this).val();
		$("#detailsEleve").html("");
		$("#trombinoscope").html("");
		if (!(cours == ""))
			$.get("inc/listeElevesCours.inc.php",
				{'cours': cours},
				function (resultat) {
					$(".btn").show();
					$("#selecteurEleve").fadeIn("slow").html(resultat);
					$("#btnTrombi").click();
				})
			else {
			$(".btn").hide();
			$("#selecteurEleve").hide();
			}
		})
    
	// au changement de sélection d'élève dans la liste déroulante
    $("#selectEleve").live("change",function(){
        var codeInfo;
        codeInfo=$(this).val();
		if (codeInfo != "")
			{
			$("#trombinoscope").html("");
        	$.get("inc/detailsEleve.inc.php",
            	    {codeInfo: codeInfo},
                	function (resultat){
						$("#detailsEleve").html(resultat);
                	});
			}
			else {
				$("#detailsEleve").html("")
				$("#photo").html("");
			}
    })
	// au clic sur le "btn" trombinoscope
	$("#btnTrombi").click(function(){
		$("#detailsEleve").html("");
		// -------------------------------------------
		if (typeTrombinoscope == 'parClasse') {
			var groupe = $("#selectGroupe").val();
			var cours = '';
			};
		// -------------------------------------------
		if (typeTrombinoscope == 'parCours'){
			var cours = $("#selectCours").val();
			var groupe = '';
			}
		$.get("inc/trombinoscope.inc.php",
			{groupe:groupe,
			 cours: cours},
			function (data) {
				$("#trombinoscope").html(data);
				});
		  return false;
		});
		
	// produit un fichier CSV des élèves de la classe sélectionnée  
	$("#csv").click(function(){
		if (typeTrombinoscope == 'parClasse') {
			var groupe = $("#selectGroupe").val();
			var cours = '';
			}
		if (typeTrombinoscope == 'parCours') {
			var cours = $("#selectCours").val();
			var groupe = '';
			}
		$.get("inc/csvTrombi.inc.php",
			{groupe: groupe,
			 cours: cours},
			function (data){
				$("#csv .filename").html(data);
			})
		})
	 
	 $("#pdf").click(function(){
		if (typeTrombinoscope == 'parClasse') { 
			var groupe = $("#selectGroupe").val();
			var cours = '';
			}
		if (typeTrombinoscope == 'parCours') { 
			var cours = $("#selectCours").val();
			var groupe = '';
			}
		$.get("inc/pdfTrombi.inc.php",
			{groupe: groupe,
			 cours: cours},
			 function (data) {
				$("#pdf .filename").html(data);
				})
		})
			
	 $(".eleve").live("click", function(){
		var codeInfo = $(this).attr("id");
		$.get("inc/detailsEleve.inc.php",
			{codeInfo: codeInfo},
				function (resultat){
					$("#trombinoscope").html("");
                  	$("#detailsEleve").html(resultat);
                });
		 });
		 
	$(".filename").click(function(){
		$(this).html("");
		})

   })
{/literal}
</script>

<fieldset id="selectTop" style="clear:both; height:40px; display: none">
	{* Sélection des élèves sur leur groupe de cours *}
	<select name="cours" id="selectCours" style="display:none">
		<option value="">Cours</option>
		{foreach from=$lesCours item=unCours}
			<option value="{$unCours.cours}">{$unCours.cours_nom} : {$unCours.cours}</option>
		{/foreach}
	</select>

	{* on affiche un sélecteur des élèves de la classe ou du cours choisi *}
	<span id="selecteurEleve" style="display:none"></span>
	<span class="btn" id="btnTrombi" style="display:none">Trombinoscope</span> 
	<span class="btn" id="csv" style="display:none">Export > Tableur <em class="filename"></em></span>
	<span class="btn" id="pdf" style="display:none">Export > PDF <em class="filename"></em></span>

</fieldset>