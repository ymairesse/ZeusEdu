<div class="container-fluid">
	<h2>Gestion de l'accès aux bulletins</h2>
	<div class="row">

	<form name="limiteClasse" id="limiteClasse" method="POST" action="index.php" role="form" class="form-vertical">

	<div class="btn-group">
		<button type="button" class="btn btn-primary" id="periodeMoins1"><i class="fa fa-arrow-left"></i> Précédent </button>
		<button type="button" class="btn btn-primary" id="periodeNow">Période en cours [{$PERIODEENCOURS}]</button>
		<button type="button" class="btn btn-primary" id="periodePlus1">Suivant <i class="fa fa-arrow-right"></i></button>
	</div>

		<div class="btn-group pull-right">
			<button type="reset" class="btn btn-default">Annuler</button>
			<button type="submit" class="btn btn-primary">Enregistrer</button>
		</div>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value= "{$mode}">
		<input type="hidden" name="etape" value="enregistrer">
		<input type="hidden" name="classe" value="{$classe}">
		<input type="hidden" name="periodeEnCours" id="periodeEnCours" value="{$PERIODEENCOURS}">
		<input type="hidden" name="nbPeriodes" id="nbPeriodes" value="{$NBPERIODES}">

	<div class="clearfix"></div>

		{* répartition des élèves dans deux colonnes sur les écrans larges; sinon, les deux tableaux seront superposés *}
		{assign var=nbCol1 value=round($listeBulletinsEleves|count / 2)}
		{assign var=listeDouble value=array($listeBulletinsEleves|array_slice:0:$nbCol1:true, $listeBulletinsEleves|array_slice:$nbCol1:Null:true)}

		{foreach from=$listeDouble key=i item=liste}

		<div class="col-md-6 col-sm-12">

		<table class="table table-condensed table-hover table-bulletin" id="tableauBulletin{$i}">

			<thead>
				<tr>
					<th style="width:230px">&nbsp;</th>
					{foreach from=$listeBulletins item=noBulletin}
						<th	data-bulletin="{$noBulletin}">
							{$noBulletin}
						</th>
					{/foreach}
				</tr>
			</thead>

			{foreach from=$liste key=matricule item=unEleve}
				<tr>
					<td style="width:230px"
							class="pop"
							data-toggle="popover"
							data-content="<img src='../photos/{$listeEleves.$matricule.photo}.jpg' style='width:100px' alt='{$matricule}' class='noprint'>"
							data-container="body"
							data-html="true"
							data-placement="right"
							data-original-title="<span class='noprint'>{$unEleve.nom|cat:' '|cat:$unEleve.prenom|truncate:15:''}</span>">
							<span class="visible-xs">{$unEleve.nom|truncate:12:'..'} {$unEleve.prenom|truncate:3:'.'}</span>
							<span class="visible-sm visible-md visible-lg">{$unEleve.nom|truncate:20:'...'|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}</span>
					</td>

					{* on passe les différents bulletins des périodes de l'année en revue *}
					{foreach from=$listeBulletins item=noBulletin}
						<td data-periode="{$noBulletin}" data-matricule="{$matricule}">
								{if $noBulletin <= $PERIODEENCOURS}
								<input type="radio"
												name="bulletin_{$matricule}"
												id="periode{$noBulletin}_matricule{$matricule}"
												class="leBulletin"
												value="{$noBulletin}"
												data-matricule="{$matricule}"
												data-periode="{$noBulletin}"
												{if (($listeBulletinsEleves.$matricule.bulletin == '') && ($noBulletin == $PERIODEENCOURS)) || ($listeBulletinsEleves.$matricule.bulletin == $noBulletin)} checked{/if}>
								&nbsp; {$noBulletin} &nbsp;
								{else}
								<i class="fa fa-minus-circle"></i>
								{/if}
						</td>
					{/foreach}  {* $listeBulletins *}
				</tr>
			{/foreach}  {* $liste *}
		</table>

		</div>  <!-- col-md... -->

		{/foreach}  {* $listeDouble *}
	<p>&nbsp;</p>
	</form>

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

	$("#limiteClasse").submit(function(){
		$("#wait").show();
		$.blockUI();
		})

		$("#periodeNow").click(function(){
			var periodeNow = $("#periodeEnCours").val();
			$('.leBulletin').each(function(){
				if ($(this).val() == periodeNow)
					$(this).trigger('click');
			})
		})

		$("#periodeMoins1").click(function(){
			$('.leBulletin:checked').each(function(i){
				var periode = parseInt($(this).data('periode'));
				var matricule = $(this).data('matricule');
				if (periode > 0)
					$("#periode"+(periode-1)+"_matricule"+matricule).trigger('click');
			})
		})

		$("#periodePlus1").click(function(){
			var nbPeriodes = $("#nbPeriodes").val();
			$('.leBulletin:checked').each(function(){
				var periode = parseInt($(this).data('periode'));
				var matricule = $(this).data('matricule');
				if (periode < nbPeriodes)
					$("#periode"+(periode+1)+"_matricule"+matricule).trigger('click');
			})
		})

})

</script>
