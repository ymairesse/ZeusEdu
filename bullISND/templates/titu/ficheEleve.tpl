<div class="container-fluid">

	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

	<div class="row">

		<div class="col-md-11 col-sm-9">

			<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
				<li class="active"><a href="#tabs-1" data-toggle="tab">Notes</a></li>
				<li><a href="#tabs-2" data-toggle="tab">Données scolaires</a></li>
				<li><a href="#tabs-3" data-toggle="tab">Données personnelles</a></li>
				<li><a href="#tabs-4" data-toggle="tab">Parents et responsable</a></li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane active" id="tabs-1">
					{include file="titu/pad/tabEleve1.inc.tpl"}
				</div>
				<!-- tabs-1 -->

				<div class="tab-pane" id="tabs-2">
					{include file="titu/pad/tabEleve2.inc.tpl"}
				</div>
				<!-- tabs-2 -->

				<div class="tab-pane" id="tabs-3">
					{include file="titu/pad/tabEleve3.inc.tpl"}
				</div>
				<!-- tabs-3 -->

				<div class="tab-pane" id="tabs-4">
					{include file="titu/pad/tabEleve4.inc.tpl"}
				</div>
				<!-- tabs-4 -->

			</div>
			<!-- my-tab-content -->

		</div>
		<!-- col-md-10 ... -->

		<div class="col-md-1 col-sm-3">

			<img src="../photos/{$eleve.photo}.jpg" class="photo img-responsive" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}">

		</div>

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">
	//  quel est l'onglet actif?
	var onglet = "{$onglet|default:''}";

	// activer l'onglet dont le numéro a été passé
	$(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');

	$(document).ready(function() {

		$(".popover-eleve").mouseover(function(){
			$(this).popover('show');
			})
		$(".popover-eleve").mouseout(function(){
			$(this).popover('hide');
			})

		var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
		var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
		var modifie = false;


		// si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
		$("#tabs li a").click(function() {
			var ref = $(this).attr("href").split("-")[1];
			$(".onglet").val(ref);
		});


		function modification() {
			if (!(modifie)) {
				modifie = true;
				$("#mod").show();
				window.onbeforeunload = function() {
					var reponse = confirm(confirmationBeforeUnload);
					if (!(reponse)) {
						$.unblockUI();
					}
					return reponse
				};
			}
		}

		$("#padEleve").keyup(function(e) {
			var readonly = $(this).attr("readonly");
			if (!(readonly)) {
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
				if ((key > 31) || (key == 8)) {
					modification();
				}
			}
		})

		$("#padEleve").submit(function() {
			modifie = false;
			window.onbeforeunload = function() {};
			$.blockUI();
			$("#wait").show();
		})

		$("#annuler").click(function() {
			if (confirm(confirmationReset)) {
				$("#mod").hide();
				modifie = false;
				window.onbeforeunload = function() {};
				return true
			} else {
				$.unblockUI();
				return false;
			}
		})

		// le copier/coller provoque aussi  une "modification"
		$("input, textarea").bind('paste', function() {
			modification()
		});

	})
</script>
