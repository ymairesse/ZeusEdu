<div class="container">
	
	<h3 style="clear:both" title="{$infoPerso.matricule}">
		{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}
	</h3>
	
	<button type="button" class="btn btn-success pull-right" id="couleur"><i class="fa fa-lightbulb-o" style="color:yellow; font-size: 1.2em;"></i> <span>Désactiver la couleur</span></button>

	<ul class="nav nav-tabs">
		<li class="active"><a data-toggle="tab" href="#tabs-1">Cotes de situation</a></li>
		<li><a data-toggle="tab" href="#tabs-2">Cotes période {$bulletin}</a></li>
		<li><a data-toggle="tab" href="#tabs-3">Remarques toutes périodes</a></li>
		{if $attitudes}
			<li><a data-toggle="tab" href="#tabs-4">Attitudes</a></li>
		{/if}		
	</ul>
	
	
	<div class="tab-content">
		
		<div id="tabs-1" class="tab-pane fade in active">
			{include file="tabCotes.tpl"}
		</div>
		<div id="tabs-2" class="tab-pane fade">
			{include file="tabPeriode.tpl"}
		</div>
		<div id="tabs-3" class="tab-pane fade">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<tr>
					<th style="width:3em">Bulletin</th>
					<th style="text-align:center">Remarques</th>
					</tr>
					{foreach from=$listePeriodes item=periode}
						<tr>
							<th>{$periode}</th>
							<td>{$listeRemarquesTitu.$matricule.$periode|default:'&nbsp;'}</td>
						</tr>
					{/foreach}
				</table>
			</div>
		</div>
		{if $attitudes}
			<div id="tabs-4" class="tab-pane fade">
				{include file="tabAttitudes.tpl"}
			</div>
		{/if}
		
	</div>  <!-- tab-content -->

	<div class="row">

		<div class="col-md-10 col-sm-8">
			
			<form name="avisTitu" id="avisTitu" action="index.php" method="POST" class="form-vertical" role="form">
	
				<h4>Avis du titulaire et du Conseil de Classe pour la période {$bulletin}</h4>
				
				{if isset($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin) && ($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin != '')}
				<h5>Mention accordée: <strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:'&nbsp;'}</strong></h5>
				{/if}				
				<button type="submit" class="btn btn-primary pull-right" id="enregistrer">Enregistrer</button>

				<input type="hidden" name="action" value="titu">
				<input type="hidden" name="mode" value="remarques">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="bulletin" value="{$bulletin}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="classe" value="{$classe}">
				<input type="hidden" name="onglet" class="onglet" value="{$onglet}">
					
				{if isset($mentions.$matricule.$annee.$bulletin) && ($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin != '')}
					<h4>Mention accordée <strong>{$mentions.$matricule.$annee.$bulletin|default:'-'}</strong>.</h4>
				{/if}
				 <textarea name="commentaire" id="commentaire" rows="7" class="ckeditor form-control">{$remarqueTitu.$bulletin|default:'&nbsp;'}</textarea>


			</form>
		
		</div>  <!-- col-md-... -->
		
		<div class="col-md-2 col-sm4">
	
			<img src="../photos/{$infoPerso.photo}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}" class="photo img-responsive">
			
		</div>  <!-- col-md-... -->

	</div>  <!-- row -->
	
</div>  <!-- container -->

<script type="text/javascript">
	
var periode={$bulletin};

<!-- quel est l'onglet actif? -->
var onglet = "{$onglet|default:''}";

<!-- activer l'onglet dont le numéro a été passé -->
$(".nav-tabs li a[href='#tabs-"+onglet+"']").tab('show');


$(document).ready(function(){
		
	<!-- si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet' -->
	$(".nav-tabs li a").click(function(){
		var ref=$(this).attr("href").split("-")[1];
		$(".onglet").val(ref);
		});

	 
	 $("#avisTitu").submit(function(){
		$.blockUI();
		$("#wait").show();
		})
		
	$("#couleur").click(function(){
		if ($(this).find('span').text() == 'Désactiver la couleur') {
			$(".mentionS").removeClass("mentionS").addClass("xmentionS");
			$(".mentionAB").removeClass("mentionAB").addClass("xmentionAB");
			$(".mentionB").removeClass("mentionB").addClass("xmentionB");
			$(".mentionBplus").removeClass("mentionBplus").addClass("xmentionBplus");
			$(".mentionTB").removeClass("mentionTB").addClass("xmentionTB");
			$(".mentionTBplus").removeClass("mentionTBplus").addClass("xmentionTBplus");
			$(".mentionE").removeClass("mentionE").addClass("xmentionE");
			$(this).find('span').text("Activer la couleur");
			}
			else {
				$(".xmentionS").removeClass("xmentionS").addClass("mentionS");
				$(".xmentionAB").removeClass("xmentionAB").addClass("mentionAB");
				$(".xmentionB").removeClass("xmentionB").addClass("mentionB");
				$(".xmentionBplus").removeClass("xmentionBplus").addClass("mentionBplus");
				$(".xmentionTB").removeClass("xmentionTB").addClass("mentionTB");
				$(".xmentionTBplus").removeClass("xmentionTBplus").addClass("mentionTBplus");
				$(".xmentionE").removeClass("xmentionE").addClass("mentionE");
				$(this).find('span').text("Désactiver la couleur");
				}
		})
	})

</script>
