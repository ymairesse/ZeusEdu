<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

	<ul class="nav nav-tabs" id="tabs">
		<li><a data-toggle="tab" href="#tabs-0">Données personnelles</a></li>
		<li><a data-toggle="tab" href="#tabs-1">Parents et responsables</a></li>
		<li><a data-toggle="tab" href="#tabs-2">Informations médicales {if $medicEleve.info != ''}<i class="fa fa-heartbeat faa-pulse animated" style="font-size:1.2em; color: red"></i>{/if}</a></li>
		<li><a data-toggle="tab" href="#tabs-3">Visites à l'infirmerie <span class="badge" style="color:red; background: white">{$consultEleve|@count}</span></a></li>
	</ul>

    <div class="tab-content">
		
        <div id="tabs-0" class="tab-pane fade in active">

			{include file="donneesPerso.tpl"}
		
		</div>

		<div id="tabs-1" class="tab-pane fade in">
			
			{include file="donneesParents.tpl"}
		
		</div>
		
		<div id="tabs-2" class="tab-pane fade in">
			
			{include file="infoMedic.tpl"}
			
		</div>
		
		<div id="tabs-3" class="tab-pane fade in">
			
			{include file="visitesInfirmerie.tpl"}
		
		</div>


</div>



<script type="text/javascript">
	
var onglet = "{$onglet|default:0}";
		

$(document).ready(function(){
		
	<!-- activer l'onglet dont le numéro a été passé -->
	$('#tabs li a').eq(onglet).tab('show');
	// $(".tab-content div").eq(onglet).show()
	
	$("#tabs li").click(function(){
		var n = $(this).index()
		$(".onglet").val(n);
		})
	
	<!-- si l'on clique sur un onglet, son numéro est retenu dans un des inputs cachés dont la class est 'onglet' -->
	$("#tabs ul li a").click(function(){
		var no = $(this).attr("href").substr(6,1);
		$(".onglet").val(no-1);
		});
		
	$(".delete").click(function(){
		if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
			return false;
		})
	
})

</script>
