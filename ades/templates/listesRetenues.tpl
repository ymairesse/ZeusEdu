<div class="container">
	
<h3>Dates et modification des dates de retenues</h3>

<a class="btn btn-primary pull-right btn-lg" role="button" href="index.php?action=retenues&amp;mode=edit&amp;typeRetenue={$typeRetenue}">Nouvelle retenue</a>

<h4>Type: {$infosRetenue.titreFait} Nombre: <span id="nbRetenues">{$listeRetenues|@count}</span></h4>

<form name="editRetenues" id="editRetenues" method="POST" action="index.php" class="form-vertical" role="form">
	
	<button type="button" class="btn btn-primary" id="cache" title="Montrer les retenues cachées">Cacher/Montrer</button>

	<div class="table-responsive">
		
		<table class="table table-condensed table-hover" id="tableRetenues">
			<thead>
				<tr>
				<th>&nbsp;</th>
				<th>Date</th>
				<th>Heure</th>
				<th>Durée</th>
				<th>Local</th>
				<th>Places</th>
				<th>Occupation</th>
				<th>Visible</th>
				<th>Éditer</th>
				<th>Cloner</th>
				</tr>
			</thead>
			{foreach from=$listeRetenues key=id item=uneRetenue}
			<tr id="{$id}" class="{if $uneRetenue.occupation < $uneRetenue.places}libre {else}rempli {/if}{if $uneRetenue.affiche == 'N'}cache{/if}">
				<td class="del"><a href="javascript:void(0)">{if $uneRetenue.occupation == 0}<span class="glyphicon glyphicon-remove-circle" style="color:red"></span>{else}&nbsp;{/if}</a></td>
				<td>{$uneRetenue.jourSemaine|truncate:3:''} <span class="date">{$uneRetenue.dateRetenue}</span></td>
				<td class="heure">{$uneRetenue.heure}</td>
				<td class="duree">{$uneRetenue.duree}h</td>
				<td class="local">{$uneRetenue.local}</td>
				<td class="places">{$uneRetenue.places}</td>
				<td class="occupation">{$uneRetenue.occupation}</td>
				
				<td style="text-align:center; cursor:pointer" id="vis_{$uneRetenue.idretenue}" class="visible" title="cliquer pour changer l'état" data-container="body" data-toggle="tooltip" data-html="true" data-placement="bottom">
					{if $uneRetenue.affiche == 'O'}
					<span class="glyphicon glyphicon-eye-open vis"></span>
						{else}
					<span class="glyphicon glyphicon-eye-close invis"></span>
					{/if}
				</td>
				
				<td style="text-align:center" title="Modifier" data-container="body" data-toggle="tooltip" data-html="true" data-placement="bottom">
					<a href="index.php?action=retenues&amp;mode=edit&amp;idretenue={$uneRetenue.idretenue}">
					<span class="glyphicon glyphicon-edit"></span>	
					</a>
				</td>
				
				<td style="text-align:center" title="Cloner" class="cloner" data-container="body" data-toggle="tooltip" data-html="true" data-placement="bottom">
					<a href="javascript:void(0)">
						<span class="glyphicon glyphicon glyphicon-user" style="font-size:1.2em; color: #0083FF"></span>
						<span class="glyphicon glyphicon glyphicon-user" style="font-size:0.8em; color: #FF0083"></span>
					</a>
				</td>
			</tr>
			{/foreach}
		</table>

</div>

<input type="hidden" name="typeRetenue" value="{$infosRetenue.typeRetenue}" id="typeRetenue">
</form>

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$(".cache").hide();
		
		$("#cache").click(function(){
				$('.cache').toggle();
			})
		
		$("#tableRetenues").on("click", ".visible", function(){
			var visible = $(this);
			var id=$(this).attr('id');
			var texte = $(this).find('.vis')?'O':'N';
			$.post('inc/visibleInvisible.inc.php', {
				'id': id,
				'texte': texte
			   },
			   function (resultat) {
				if (resultat == 'N') {
					visible.find('.glyphicon').removeClass().addClass('glyphicon glyphicon-eye-close invis');
					visible.parents('tr').fadeOut();
					}
					else {
						visible.find('.glyphicon').removeClass().addClass('glyphicon glyphicon-eye-open vis');
					}
			   }
			)
			})

		// clonage d'une retenue existante
		$("#tableRetenues").on("click", ".cloner", function(){
			var moi = $(this);
			var ligne = $(this).parent().clone(true);
			var id = ligne.attr("id");
			var date = ligne.find(".date").text();
			var heure = ligne.find(".heure").text();
			var duree = ligne.find(".duree").text();
			var local = ligne.find(".local").text();
			var places = ligne.find(".places").text();
			var typeRetenue = $("#typeRetenue").val();

			$.post(
				'inc/saveCloneRetenue.inc.php', {
				'ligne': ligne.html(),
				'date': date,
				'heure': heure,
				'duree': duree,
				'local': local,
				'places': places,
				'typeRetenue': typeRetenue
				},
				function(resultat) {
					var newId=resultat.id;
					var newDate=resultat.date;
					ligne.attr("id",newId);
					ligne.find(".occupation").text(0);
					ligne.html(ligne.html().split(id).join(newId));
					ligne.html(ligne.html().split(date).join(newDate));
					moi.closest('tr').after(ligne).fadeIn();	
					},
				"json"
				)
			})
		
		$("#tableRetenues").on("click", ".del", function(){
			if (confirm('Veuillez confirmer la suppression de cette retenue')) {
			var moi = $(this);
			var idretenue = moi.parent().attr("id");
			$.post('inc/delRetenue.inc.php', {
				'idretenue': idretenue
				},
				function(resultat) {
					if (resultat == 1) {
						moi.parent().fadeOut().remove();
						nb = $("#nbRetenues").text();
						$("#nbRetenues").text(nb-resultat);
						}
					}
				);
			}
			})
	})

</script>

