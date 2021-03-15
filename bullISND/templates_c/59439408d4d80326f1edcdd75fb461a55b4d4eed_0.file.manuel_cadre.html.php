<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:39:42
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/manuel_cadre.html' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e586e2c58b4_72554305',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '59439408d4d80326f1edcdd75fb461a55b4d4eed' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/manuel_cadre.html',
      1 => 1587142495,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e586e2c58b4_72554305 (Smarty_Internal_Template $_smarty_tpl) {
?><h3>Cadre et statut des cours</h3>

<p><strong>Cadre du cours (officiel)</strong></p>
<p>Code officiel du cours issu du logiciel ProEco. Ces codes sont définis par le Ministère et permettent de classer les cours en différentes catégories.</p>

<p><strong>Ordre</strong></p>
<p>Ordre d'apparition de ce type de cours dans les différents documents (bulletin, feuille de délibé) indépendamment du nombre d'heures du cours qui est généralement prépondérant.</p>

<p><strong>Statut du cours (dans l'application)</strong></p>
<p>Par rapport aux cadres, les statuts de cours dans l'application sont plus limités mais plus ciblés. Le programmeur de l'application pourra utiliser les statuts dans le code.</p>

<p><strong>Pas d'échec</strong></p>
<p>Les notes de certains cours, même inférieures à 50%, ne doivent pas être considérées comme des échecs dans les règles du Conseil de Classe. Cocher la case si le type de cours ne donne pas lieu à un échec à comptabiliser</p>

<p><strong>Pas de totalisation</strong></p>
<p>Les notes de certains cours peuvent être exclues de la totalisation dans les règles du Conseil de Classe. Cocher la case si le type de cours ne donne pas lieu à la totalisation.</p>
<?php }
}
