<?php /* Smarty version Smarty-3.1.13, created on 2017-06-18 16:49:15
         compiled from "./templates/eleves/printPwd.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1254266401594692eb860622-50194576%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '23387c229fb145fa11c290433008d31f6925d4b5' => 
    array (
      0 => './templates/eleves/printPwd.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1254266401594692eb860622-50194576',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listeClasses' => 0,
    'classe' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_594692eb86b422_03250585',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_594692eb86b422_03250585')) {function content_594692eb86b422_03250585($_smarty_tpl) {?><div class="container">

    <div class="row">

        <h3>Impression des mots de passe "élèves"</h3>

        <div class="col-md-2 col-sm-3">
            <select class="selectClasse form-control" name="selectClasse">
                <option value="">Classe</option>

                <?php  $_smarty_tpl->tpl_vars['classe'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['classe']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['listeClasses']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['classe']->key => $_smarty_tpl->tpl_vars['classe']->value){
$_smarty_tpl->tpl_vars['classe']->_loop = true;
?>
                <option value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</option>
                <?php } ?>

            </select>

        </div>

        <div class="col-md-4 col-sm-4">
            <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
            <br>
            <button type="button" class="btn btn-primary btn-block hidden" id="tous">Tous les élèves</button>

            <div id="eleves">

            </div>

        </div>

        <div class="col-md-6 col-sm-5" id="print">


        </div>

    </div>

</div>


<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function() {
            $('#ajaxLoader').addClass('hidden');
        });

        $(".selectClasse").change(function() {
            var classe = $(".selectClasse").val();
            $("#print").addClass('hidden');
            $.post('inc/listeEleves.inc.php', {
                    classe: classe
                },
                function(resultat) {
                    $("#eleves").html(resultat);
                    if (classe != '')
                        $("#tous").removeClass('hidden');
                    else $("#tous").addClass('hidden');
                })
        })

        $("#eleves").on('change', '#selectEleve', function() {
            var matricule = $("#selectEleve").val();
            $.post('inc/eleves/pw2pdf.inc.php', {
                    matricule: matricule
                },
                function(resultat) {
                    $("#print").removeClass('hidden');
                    $("#print").html(resultat);
                })
        })

        $("#tous").click(function() {
            $("#print").addClass('hidden');
            var classe = $(".selectClasse").val();
            if (classe != '')
                $.post('inc/eleves/pwClasse2pdf.inc.php', {
                        classe: classe
                    },
                    function(resultat) {
                        $("#print").removeClass('hidden');
                        $("#print").html(resultat);
                    })
        })
    })
</script>
<?php }} ?>