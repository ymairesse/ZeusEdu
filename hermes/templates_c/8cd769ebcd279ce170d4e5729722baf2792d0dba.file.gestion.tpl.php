<?php /* Smarty version Smarty-3.1.13, created on 2020-01-30 15:54:22
         compiled from "./templates/gestion.tpl" */ ?>
<?php /*%%SmartyHeaderCode:14040032095e32ee1e338224-84220009%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '8cd769ebcd279ce170d4e5729722baf2792d0dba' => 
    array (
      0 => './templates/gestion.tpl',
      1 => 1580337834,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '14040032095e32ee1e338224-84220009',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32ee1e33aee3_54264430',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32ee1e33aee3_54264430')) {function content_5e32ee1e33aee3_54264430($_smarty_tpl) {?><div class="container-fluid">

<h2>Gestion des listes de destinataires</h2>

	<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
        <li class="active"><a href="#tabs-1" data-toggle="tab">Ajouts</a></li>
        <li><a href="#tabs-2" data-toggle="tab">Suppressions</a></li>
        <li><a href="#tabs-3" data-toggle="tab">Publication et abonnements</a></li>
    </ul>
    </ul>

    <div id="my-tab-content" class="tab-content">

		<div class="tab-pane active" id="tabs-1">
			<?php echo $_smarty_tpl->getSubTemplate ("inc/addMailing.inc.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>

		<div class="tab-pane" id="tabs-2">
			<?php echo $_smarty_tpl->getSubTemplate ("inc/supprMailing.inc.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>

		<div class="tab-pane" id="tabs-3">
			<?php echo $_smarty_tpl->getSubTemplate ("inc/abonnements.inc.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>

	</div>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){

	$(".checkListe").click(function(event){
		event.stopPropagation();
		})

	$(".checkListe").click(function(){
		var id=$(this).prop("id").substr(6,99);
		$("#blocMails_"+id).find('.selecteur').trigger('click');
		$("#selectionDest").text($("input.mailsSuppr:checked").length);
		})

	$(".label").click(function(){
		$(this).prev().trigger('click');
		})

	$(".mailsAjout").click(function(){
		var nb = $(".mailsAjout:input:checkbox:checked").length
		$("#selectionAdd").text(nb);
		})
	$("#resetAdd").click(function(){
		$("#selectionAdd").text(0);
		})
	$("#resetDel").click(function(){
		$("#selectionDest").text(0)
		})

	$("#deleteList").submit(function(){
		if (!(confirm('Les éléments sélectionnés seront effacés. Veuillez confirmer.')))
			return false;
			else {
				$("#wait").show();
				}
		})

	// $("#creation").submit(function(){
	// 	if ($("#nomListe").val() == '') {
	// 		alert('Veuille donner un nom pour cette liste');
	// 		return false;
	// 		}
	// 	})

	$(".mailsSuppr").click(function(){
		$("#selectionDest").text($("input.mailsSuppr:checked").length);

		})

	$("#selectListe").change(function(){
		var id = $(this).val();
		$.post( "inc/listContent.inc.php", {
			id: id
			},
			function (resultat){
				$("#listeExistants").html(resultat);
				});
		});

})

</script>
<?php }} ?>