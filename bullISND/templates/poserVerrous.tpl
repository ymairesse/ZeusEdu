<div class="container">

<h2 style="clear:both">Verrouillage des bulletins n° {$bulletin}</h2>

	<form name="formulaire" id="formulaire" class="form" method="POST" action="index.php">

		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="mode" value="poserVerrous">
		<input type="hidden" name="etape" value="enregistrer">
		<input type="hidden" name="bulletin" value="{$bulletin}">

		<div class="row">

			<div class="col-md-9 col-xs-12">
				<h3>Choix des classes</h3>
				<div class="row">

					{foreach from=$listeClasses key=degre item=niveauxDegre}

					<div class="col-md-4 col-sm-6">
						<h4>Degré {$degre}</h4>
						<ul>
						{foreach from=$niveauxDegre key=niveaux item=classes}
							<li><span class="collapsible">Classes de {$niveaux}e</span>
								<input type="radio" value="{$niveaux}" name="radioNiveau" class="niveau">
							<ul>
								{foreach from=$classes item=uneClasse}
									<li>{$uneClasse}
									<input type="checkbox" name="classe_{$uneClasse}" value="1" class="classe">
									</li>
								{/foreach}
							</ul>
							</li>
						{/foreach}
						</ul>
					</div>  <!-- col-md-4.. -->

					{/foreach}

				</div>  <!-- row -->

			</div>   <!-- col-md-10... -->

			<div class="col-md-3 col-xs-12">
				<h3>Action</h3>
				<div class="radio">
					<label><input type="radio" name="verrou" value="0"{if $verrou == 0} checked{/if}>Déverrouiller</label>
				</div>
				<div class="radio">
					<label><input type="radio" name="verrou" value="1"{if $verrou == 1} checked{/if}>Verrouiller les cotes</label>
				</div>
				<div class="radio">
					<label><input type="radio" name="verrou" value="2"{if $verrou == 2} checked{/if}>Verrouiller cotes et commentaires</label>
				</div>

				<div class="btn-group-vertical btn-block">
					<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
					<button type="reset" class="btn btn-default pull-right">Annuler</button>
				</div>
			</div>

			<div class="clearfix"></div>

		</div>  <!-- row -->

	</form>

</div>  <!-- container -->


<script type="text/javascript">

$(document).ready(function(){

	$(".niveau").click(function(){
		// suppression de tous les coches ailleurs
		$(".niveau").nextAll("ul").find("li input:checkbox").prop("checked", false);
		// ajout des checked sur le niveau sélectionné
		$(this).nextAll("ul").find("li input:checkbox").prop("checked","checked")
		})

	$(".classe").click(function(){
		$("#niveaux").find("input:checkbox").not($(this).parent().parent().find("input:checkbox")).attr("checked", false);
		$(".niveau").siblings().next().filter("input").attr("checked", false);
		$(this).parent().parent().parent().find("input:radio").attr("checked", true);
		})

	$(".collapsible").click(function(){
		$(this).parent().children().filter("ul").toggle("slow")
		})

	$(".collapsible").parent().children().filter("ul").hide();

	$("#reset").click(function(){
		$(".classe").attr("checked", false);
		})

	$("#formulaire").submit(function(){
		$.blockUI();
		$("#wait").show();
		})
})

</script>
