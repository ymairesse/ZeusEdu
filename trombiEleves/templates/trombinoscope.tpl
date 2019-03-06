<div class="container-fluid">

	<div class="noprint notice">
		<div class="btn-group pull-right">
			<button type="button"
				class="btn btn-default btn-sm"
				id="btn-pdf"
				title="Télécharger les pages au format PDF"
				data-cible="{$cible}"
				data-classe="{$classe|default:''}"
				data-coursgrp="{$coursGrp|default:''}">
				<i class="fa fa-file-pdf-o fa-lg" style="color:red"></i> {$nomFichier}.pdf
			</button>
			<button type="button"
				class="btn btn-default btn-sm"
				id="btn-csv"
				title="Télécharger les pages au format CSV"
				data-cible="{$cible}"
				data-classe="{$classe|default:''}"
				data-coursgrp="{$coursGrp|default:''}">
				<i class="fa fa-file-excel-o fa-lg" style="color:green"></i> {$nomFichier}.csv
			</button>
		</div>
		Pour l'impression, préférez la version PDF proposée ci-contre <i class="fa fa-file-pdf-o fa-lg" style="color:red"></i>.<br>
		Les listes d'élèves, prêtes pour le tableur <i class="fa fa-file-excel-o fa-lg" style="color:green"></i>, sont aussi disponibles ci-contre (format CSV).
	</div>

	<h1>
		{if $cible == 'coursGrp'}
				{$coursGrp}
			{elseif $cible == 'classe'}
				{$classe}
			{else}
				Titulaire(s): {", "|implode:$titulaires}
		{/if}
	</h1>

	<ul id="trombi">
		{foreach from=$tableauEleves key=matricule item=unEleve name=trombi}
			{* 16 photos par page, à l'impression *}
			{if $smarty.foreach.trombi.iteration % 17 == 0}
				<li class="unePhoto" id="{$matricule}" style="page-break-before:always">
			{else}
				<li class="unePhoto" id="{$matricule}">
			{/if}
			<a href="index.php?action=parEleve&amp;matricule={$matricule}">
			<figure class="EBS">
				<img src="../photos/{$unEleve.photo}.jpg"
					style="width:128px; height:190px"
					alt="{$matricule}"
					class="pop"
					data-original-title="{$unEleve.nom} {$unEleve.prenom}"
					data-html="true"
					data-container="body"
					data-content="Cliquer pour le détail"
					data-placement="top">
				{if isset($listeEBS[$matricule])}
			 	<figcaption class="EBS"><i class="fa fa-user-circle-o"></i></figcaption>
				{/if}
		 	</figure>
			</a>
			 <a href="mailto:{$unEleve.mail}" title="{$unEleve.mail}"><img src="images/emailIco.png"></a>
			{$unEleve.classe} {$unEleve.nom}  {$unEleve.prenom}

			</li>
		{/foreach}
	</ul>

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$('#btn-pdf').click(function(){
			var cible = $(this).data('cible');
			var coursGrp = $(this).data('coursgrp');
			var classe = $(this).data('classe');
			$.post('inc/generatePDF.inc.php', {
				cible: cible,
				coursGrp: coursGrp,
				classe: classe
			}, function(resultat){
				bootbox.alert({
					title: 'Génération du fichier',
					message: 'Vous pouvez télécharger le document en cliquant sur ce lien ' + resultat,
				})
			})
		})

		$('#btn-csv').click(function(){
			var cible = $(this).data('cible');
			var coursGrp = $(this).data('coursgrp');
			var classe = $(this).data('classe');
			$.post('inc/generateCSV.inc.php', {
				cible: cible,
				coursGrp: coursGrp,
				classe: classe
			}, function(resultat){
				bootbox.alert({
					title: 'Génération du fichier',
					message:  'Vous pouvez télécharger le document en cliquant sur ce lien ' + resultat,
				})
			})
		})

	})

</script>
