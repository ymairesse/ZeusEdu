<?php /* Smarty version Smarty-3.1.13, created on 2020-01-30 15:54:22
         compiled from "./templates/menu.tpl" */ ?>
<?php /*%%SmartyHeaderCode:12799758065e32ee1e333320-90764447%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '243b1378187b2878c10cdd133ad5f270cdcebcd8' => 
    array (
      0 => './templates/menu.tpl',
      1 => 1563779227,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '12799758065e32ee1e333320-90764447',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'userStatus' => 0,
    'alias' => 0,
    'identite' => 0,
    'titulaire' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32ee1e3370e5_82776531',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32ee1e3370e5_82776531')) {function content_5e32ee1e3370e5_82776531($_smarty_tpl) {?><div class="container-fluid hidden-print">
	
	<nav class="navbar navbar-default" role="navigation">
		
	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barreNavigation">
			<span class="sr-only">Navigation portable</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		
		<a class="navbar-brand" href="../index.php"><button type="button" class="btn btn-primary"><span class="glyphicon glyphicon-home"></span></button></a>

	</div> 
	
	<div class="collapse navbar-collapse" id="barreNavigation">
		
		<ul class="nav navbar-nav">
			<li><a href="index.php"><button class="btn btn-primary">HERMES <img src="images/hermesIco.png" alt="HERMES" title="Page d'accueil de HERMES"></button></a></li>
			<li><a href="index.php">Envoyer un mail</a>
			<li class="dropdown"><a class="dropdown-toogle" data-toggle="dropdown" href="javascript:void(0)">Gestion <b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="index.php?action=archives">Consulter mes archives</a></li>
					<li><a href="index.php?action=gestion">Gérer les listes de destinataires</a></li>
				</ul>
			</li>
			<?php if ($_smarty_tpl->tpl_vars['userStatus']->value=='admin'){?>
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Préférences <b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="index.php?action=preferences&amp;mode=signature">Editeur de signature</a></li>
			</ul>
			<?php }?>

		</ul>  <!-- nav navbar-nav -->
		
		<ul class="nav navbar-nav pull-right">
			<?php if (isset($_smarty_tpl->tpl_vars['alias']->value)){?>
			<li><a href="../aliasOut.php"><img src="../images/alias.png" alt="Alias"><?php echo $_smarty_tpl->tpl_vars['alias']->value;?>
</a></li>
			<?php }?>
			<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#"><?php echo $_smarty_tpl->tpl_vars['identite']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['identite']->value['nom'];?>

			<?php if ($_smarty_tpl->tpl_vars['titulaire']->value){?>[<?php echo implode(',',$_smarty_tpl->tpl_vars['titulaire']->value);?>
]<?php }?><b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="../profil/index.php"><span class="glyphicon glyphicon-user"></span> Modifiez votre profil</a></li>
					<li><a href="../logout.php"><span class="glyphicon glyphicon-off"></span> Déconnexion</a></li>
				</ul>
			</li>
			
		</ul>		
	
	</div>  <!-- collapse -->
	
	</nav>

</div>  <!-- container -->
<?php }} ?>