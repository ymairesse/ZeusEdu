<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/menuBas.js"></script>
<script type="text/javascript" src="../js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="../js/jquery.form.js"></script>
<script type="text/javascript" src="../js/jquery.blockUI.js"></script>
<link rel="stylesheet" href="../screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="../print.css" type="text/css" media="print">
<link rel="stylesheet" href="../menu.css" type="text/css" media="screen">
<link rel="stylesheet" href="../js/jquery.autocomplete.css" type="text/css" media="screen">
<title>{$titre}</title>
<script type="text/javascript">

$(document).ready (function() {
		
 	$("input:visible:enabled:first").select();
	
	$("#btnRegrouper").click(function(){
		var lesClasses = [];
		$('#classes :selected').each(function(i, selected){
		   lesClasses[i] = $(selected).text();
		});
		classesGroupees = lesClasses.join(":");
		var groupe = $("#groupe").val();
		$.get("inc/grouper.inc.php", {
			'lesClasses': classesGroupees,
			 'groupe': groupe
			 },
			 function (resultat){
			 	$("#groupement").html(resultat);
			});
		return false;
	})

    $("#nomProf").autocomplete("inc/autoNomProf.inc.php", {
            formatItem: function(item) {
                var item = eval("("+item+")");
                return item.nom
                }
    })
    .result(function(event, item) {
        var item = eval("("+item+")");
        $("#nomProf").attr("value", item.nom);
        $("#formRecherche").find("#acronyme").attr("value", item.acronyme);
        $("#acro").html(item.acronyme);
        $("#btnAlias").attr("disabled", false);
        })

})

</script>
</head>
<body>
{include file="menuHaut.tpl"}
{include file="menu.tpl"}
<div id="texte">
{include file="$page.tpl"}
</div>
{include file="footer.tpl"}
</body>
</html>
