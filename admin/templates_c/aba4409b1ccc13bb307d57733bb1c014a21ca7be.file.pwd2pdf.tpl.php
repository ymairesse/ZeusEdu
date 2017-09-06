<?php /* Smarty version Smarty-3.1.13, created on 2017-06-18 16:49:23
         compiled from "../../templates/eleves/pwd2pdf.tpl" */ ?>
<?php /*%%SmartyHeaderCode:145348784594692f3e7d4f1-61770500%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'aba4409b1ccc13bb307d57733bb1c014a21ca7be' => 
    array (
      0 => '../../templates/eleves/pwd2pdf.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '145348784594692f3e7d4f1-61770500',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'type' => 0,
    'noPage' => 0,
    'classe' => 0,
    'detailsEleve' => 0,
    'sexe' => 0,
    'dataPwd' => 0,
    'mail' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_594692f3e9ec37_95435836',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_594692f3e9ec37_95435836')) {function content_594692f3e9ec37_95435836($_smarty_tpl) {?><?php if (($_smarty_tpl->tpl_vars['type']->value=='classe')&&($_smarty_tpl->tpl_vars['noPage']->value==1)){?>
<h1 style="page-break-before:always; text-align:center; font-size: 120px; padding-top: 10em;"><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</h1>
<?php }?>

<page backtop="7mm" backbottom="7mm" backleft="10mm" backright="10mm">
    <page_header>
        <h1 style="font-size: 12pt"><?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['groupe'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['prenom'];?>
</h1>
    </page_header>
    <page_footer>
        <div style="text-align:right; font-size: 10px;">
            <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['groupe'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['prenom'];?>

        </div>
    </page_footer>

    <?php $_smarty_tpl->tpl_vars['sexe'] = new Smarty_variable($_smarty_tpl->tpl_vars['detailsEleve']->value['sexe'], null, 0);?>

    <p>Bien <?php if ($_smarty_tpl->tpl_vars['sexe']->value=='F'){?>chère<?php }else{ ?>cher<?php }?> <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['prenom'];?>
</p>

    <p><strong>Les informations qui figurent sur ce document sont extrêmement confidentielles. Elles ne peuvent, en aucun cas, être confiée à un-e autre élève.</strong></p>
    <br>
    <p>Elles permettent d'accéder:</p>
    <ul>
        <li>Aux ordinateurs de l'école</li>
        <li>À la plate-forme Thot (<a href="http://isnd.be/thot">http://isnd.be/thot</a>)</li>
        <li>À ton adresse mail (voir <a href="http://mail.isnd.be">http://mail.isnd.be</a> ou <a href="http://isnd.be/mail">http://isnd.be/mail</a>)</li>
    </ul>

    <h3>Ton nom <?php if ($_smarty_tpl->tpl_vars['sexe']->value=='F'){?>d'utilisatrice<?php }else{ ?>d'utilisateur<?php }?> pour l'informatique à l'ISND est:</h3>
    <p style="text-align:center;">
        <pre style="font-weight: bold"><?php echo $_smarty_tpl->tpl_vars['dataPwd']->value['user'];?>
</pre>
    </p>
    <p>Il est formé de la <strong>première lettre de ton prénom</strong> suivie d'un maximum de <strong>7 lettres de ton nom de famille</strong>. On trouve ensuite <strong>4 chiffres</strong> qui sont ton matricule à l'école. Ces 4 chiffres figurent sur ta carte d'étudiant-e et dans ton journal de classe.</p>

    <h3>Ton mot de passe est</h3>
    <p style="text-align:center;">
        <pre style="font-weight: bold"><?php echo $_smarty_tpl->tpl_vars['dataPwd']->value['passwd'];?>
</pre>
    </p>
    <p>Le mot de passe est formé d'une série de <?php echo preg_match_all('/[^\s]/u',$_smarty_tpl->tpl_vars['dataPwd']->value['passwd'], $tmp);?>
 lettres minuscules. C'est une succession de consonnes et de voyelles.</p>

    <h3>Ton adresse mail est</h3>
    <p style="text-align:center;">
        <?php $_smarty_tpl->tpl_vars['mail'] = new Smarty_variable((($_smarty_tpl->tpl_vars['dataPwd']->value['user']).('@')).($_smarty_tpl->tpl_vars['dataPwd']->value['mailDomain']), null, 0);?>
        <pre style="font-weight: bold"><?php echo $_smarty_tpl->tpl_vars['mail']->value;?>
</pre>
    </p>

    <?php if (preg_match_all('/[^\s]/u',$_smarty_tpl->tpl_vars['dataPwd']->value['passwd'], $tmp)==6){?>
    <p>Dans ton cas, le mot de passe pour les mails est le même que celui qui figure plus haut auquel tu dois ajouter "<span style="font-size: 14pt">00</span>" (un double zéro) à la fin: <strong> <?php echo ($_smarty_tpl->tpl_vars['dataPwd']->value['passwd']).('00');?>
</strong>.</p>
    <?php }?>
    <hr>

    <p>Il est possible que tu aies besoin de ton nom <?php if ($_smarty_tpl->tpl_vars['sexe']->value=='F'){?>d'utilisatrice<?php }else{ ?>d'utilisateur<?php }?> et ton mot de passe pour une activité informatique dans n'importe quel cours, même si le professeur ne prévient pas. Tu devrais donc connaître ces informations par cœur à tout moment.
    <br> Tu pourrais éventuellement noter le mot de passe dans ton journal de classe, discrètement et à une page connue de toi seul-e.</p>
    <p>L'oubli de mot de passe gêne le déroulement du cours et sera considéré comme un "oubli de matériel scolaire".</p>
    <br>
    <p> Tu es responsable de la conservation de la confidentialité de ce document. <strong>Le fait de le laisser à l'abandon est une faute grave.</strong></p>
    <p>Si tu penses que ton mot de passe a été découvert par une autre personne, contacte d'urgence M.&nbsp;Lambert ou M.&nbsp;Mairesse.</p>

</page>

<?php if ($_smarty_tpl->tpl_vars['type']->value=='classe'){?>
<div style="page-break-before:always"></div>
<?php }?>
<?php }} ?>