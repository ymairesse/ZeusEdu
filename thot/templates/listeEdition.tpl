<div class="container">
<h2>Édition des notifications</h2>

<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
	<li class="active"><a href="#tabs-1" data-toggle="tab">À un élève</a></li>
	<li><a href="#tabs-2" data-toggle="tab">À un cours</a></li>
	<li><a href="#tabs-3" data-toggle="tab">À une classe</a></li>

	{if ($userStatus == 'admin') || ($userStatus == 'direction')}
	<li><a href="#tabs-4" data-toggle="tab">À un niveau</a></li>
	<li><a href="#tabs-5" data-toggle="tab">À l'ensemble des élèves</a></li>
	{/if}
</ul>

<div id="FicheEleve" class="tab-content">

	{include file="editNotifications/eleve.tpl"}

	{include file="editNotifications/cours.tpl"}

	{include file="editNotifications/classe.tpl"}

	{if ($userStatus == 'admin') || ($userStatus == 'direction')}

		{include file="editNotifications/niveau.tpl"}

		{include file="editNotifications/ecole.tpl"}

	{/if}

</div> <!-- tab-content -->

</div> <!-- container -->

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression multiple de notifications   ..  -->
<!-- .......................................................................... -->
<div class="modal fade noprint" id="modalBulkDelete" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Effacement des notifications
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<form name="delete" method="POST" action="index.php" role="form" class="form-vertical">
					<p>Vous allez supprimer <strong id="nbNotifications"></strong> notification(s)</p>
					<p>Veuillez Confirmer leur suppression définitive</p>
					{foreach from=$listeNotifications key=type item=unType}
						{foreach from=$unType key=id item=wtf}
						<input type="checkbox" id="del_{$id}" name="del_{$id}" value="{$id}">
						{/foreach}
					{/foreach}
					<button type="submit" class="btn btn-danger pull-right">Supprimer ces notifications</button>
					<input type="hidden" name="onglet" value="{$onglet}" class="onglet">
					<input type="hidden" name="action" value="admin">
					<input type="hidden" name="mode" value="delBulk">
					<div class="clearfix"></div>
				</form>
			</div>  <!-- modal-body -->
		</div>  <!-- modal-content -->
	</div>  <!-- modal-dialog -->

</div>  <!-- modal -->



<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression d'une notification          ..  -->
<!-- .......................................................................... -->
<div class="modal fade noprint" id="modalDelete" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">
					Effacement d'une notification
				</h4>
			</div>  <!-- modal-header -->
			<div class="modal-body">
				<form name="choixEdit" method="POST" action="index.php" role="form" class="form-vertical">
					<p><strong>Objet</strong> <span id="spanDelObjet"></span></p>
					<p><strong>Texte</strong> <span id="spanDelTexte"></span></p>
					<p><strong>Date de début</strong> <pan id="spanDelDatedebut"></pan></p>
					<p>Confirmez la suppression définitive de cette notification</p>

					<button type="submit" class="btn btn-danger pull-right">Supprimer cette notification</button>
					<input type="hidden" name="onglet" value="{$onglet}" class="onglet">
					<input type="hidden" name="id" id="delID" value="">
					<input type="hidden" name="action" value="admin">
					<input type="hidden" name="mode" value="delNotification">
				</form>
			</div>  <!-- modal-body -->
		</div>  <!-- modal-content -->
	</div>  <!-- modal-dialog -->

</div>  <!-- modal -->




<script type="text/javascript">

// quel est l'onglet actif?
var onglet = "{$onglet|default:0}";

// activer l'onglet dont le numéro a été passé
$(".nav-tabs li a[href='#tabs-"+onglet+"']").tab('show');


$(document).ready(function(){

	// si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
	$(".nav-tabs li a").click(function(){
		var ref=$(this).attr("href").split("-")[1];
		$(".onglet").val(ref);
		});

    $(".selectAll").click(function(){
      $(this).closest('table').find('.checkDelete').trigger('click');
    })

	$(".btn-delete").click(function(){
		var id = $(this).data('id');
		$("#delID").val(id);
		var objet = $(this).closest('tr').find('.objet').text();
		$("#spanDelObjet").text(objet);
		var dateDebut = $(this).closest('tr').find('.dateDebut').text();
		$("#spanDelDatedebut").text(dateDebut);
		var texte = $(this).closest('tr').next().find('.texte').text();
		$("#spanDelTexte").text(texte);
		$("#modalDelete").modal('show');
	})

	$(".checkDelete").click(function(){
		var ch = $(this).prop('checked');
		var toto = $(this);
		var id=$(this).data('id');
		$("#del_"+id).prop('checked',ch);
	})

	$(".delModal").click(function(){
		var nb = $("#modalBulkDelete input:checkbox:checked").length;
		$("#nbNotifications").text(nb);
		$("#modalBulkDelete").modal('show');
	})

})

</script>
