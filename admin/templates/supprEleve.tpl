<script type="text/javascript">
{literal}
$(document).ready(function(){

    // au changement de sélection du groupe classe dans la liste déroulante
    $("#selectGroupe").change(function(){
        var groupe = $(this).val();
        $("#detailsEleve").html("");
        $("#photo").html("");
        $.get("inc/listeEleves.inc.php",
                {'groupe': groupe},
                function (resultat){
                  $("#selecteur").html(resultat)
                });
    });
	// au changement de sélection d'élève dans la liste déroulante
    $("#selectEleve").livequery("change",function(){
        var codeInfo=$(this).val();
		if (codeInfo != "")
			{
        	$.get("inc/ficheEleveCours.inc.php",
            	    {codeInfo: codeInfo},
                	function (resultat){
                  	$("#detailsEleve").html(resultat);
                  	var source = "<img src='../photos/"+codeInfo+".jpg' height='200'>";
                  	$("#photo").html(source);
                	});
			}
			else {
				$("#detailsEleve").html("")
				$("#photo").html("");
			}
    })
	// montrer / cacher la photo si la zone est cliquée
      $("#photo").livequery("click", function(){
        var taille = $(this).find("img").attr("height");
        if (taille == 30)
            taille = 150
            else taille = 30;
        $(this).find("img").fadeIn("slow").attr("height",taille);
          });
 })
{/literal}
</script>
<fieldset id="selectTop" style="clear:both; height:40px;">
    <legend>Choix de la classe et de l'élève</legend>
    <div id="photo" style="right:0"></div>
	<select name="classe" id="selectGroupe">
    	<option value="">Classe</option>
		{foreach from=$lesGroupes item=unGroupe}
			<option value="{$unGroupe}">{$unGroupe}</option>
		{/foreach}
	</select>
	{* on affiche un sélecteur des élèves du groupe/classe sélectionné *}
	<span id="selecteur" style="z-index:1"></span>
</fieldset>
<div id="detailsEleve"></div>
</body>
</html>
