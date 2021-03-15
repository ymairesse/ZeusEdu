<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 12:26:28
  from '/home/yves/www/sio2/peda/bullISND/templates/users/interim.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604df2e45a99f2_52361144',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '038def4759a5ffab455d082078bf7f0a5902b719' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/users/interim.tpl',
      1 => 1464422680,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604df2e45a99f2_52361144 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

    <div class="alert alert-info">
        <p>Sélectionner un enseignant et un interimaire possible. Cliquez ensuite sur le bouton
            <button type="button" class="btn btn-primary" id="interim">Interim</button>
        </p>
    </div>

    <div class="row">

        <div class="col-md-6 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des enseignants</h3>
                </div>
                <div class="panel-body" style="height:40em; overflow:auto">
                    <table class="table table-condensed" id="listeProfs">
                        <thead>
                            <tr>
                                <th>Acronyme</th>
                                <th>Nom</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>

                        <tbody>
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfs']->value, 'data', false, 'acronyme');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                            <tr class="unProf">
                                <td><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
</td>
                                <td><?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</td>
                                <td>
                                    <input type="radio" class="prof" name="prof" value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
" data-nomprof="<?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
">
                                </td>
                            </tr>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </tbody>

                    </table>
                </div>
            </div>
            <div class="panel-footer">

            </div>
        </div>
        <!-- col-md-... -->

        <div class="col-md-6 col-sm-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Liste des intérimaires possibles</h3>
                </div>
                <div class="panel-body" style="height:40em; overflow:auto">
                    <table class="table table-condensed" id="listeInterims">
                        <thead>
                            <tr>
                                <th>Acronyme</th>
                                <th>Nom</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>

                        <tbody>
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeInterims']->value, 'data', false, 'acronyme');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
                            <tr class="unInterim">
                                <td>
                                    <input type="radio" name="interim" value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
" data-nomprof="<?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
">
                                </td>
                                <td><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
</td>
                                <td><?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</td>
                            </tr>
                            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </tbody>

                    </table>
                </div>
            </div>
            <div class="panel-footer">

            </div>
        </div>
        <!-- col-md-... -->

    </div>
    <!-- row -->

</div>
<!-- container -->

<div class="modal fade" id="modalInterim" tabindex="-1" role="dialog" aria-labelledby="titleInterim" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="index.php" method="POST" class="form-vertical" role="form">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="titleInterim">Sélection des cours en interim</h4>
                </div>
                <div class="modal-body">
                    <div class="col-sm-7">
                        <div id="coursProf" style="height:20em; overflow:auto"></div>
                    </div>
                    <div class="col-sm-5">
                        <div id="coursInterim" style="height:20em; overflow:auto"></div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="modal-footer">
                    <div class="btn-group pull-right">
                        <input type="hidden" name="prof" value="" id="inputModalProf">
                        <input type="hidden" name="interim" value="" id="inputModalInterim">
                        <input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
                        <input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
                        <input type="hidden" name="etape" value="enregistrer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Affecter les cours</button>
                    </div>

                </div>
            </form>
        </div>
    </div>
</div>


<?php echo '<script'; ?>
 type="text/javascript">
    $(document).ready(function() {

        $('.unProf').click(function() {
            $(this).find('input:radio').prop('checked', true);
            $('.unProf').removeClass('selected');
            $(this).addClass('selected');
        })

        $('.unInterim').click(function() {
            $(this).find('input:radio').prop('checked', true);
            $('.unInterim').removeClass('selected');
            $(this).addClass('selected');
        })

        $(document).on('click','.unCours', function() {
            var checkBox = $(this).find('input:checkbox');
            if (checkBox.prop('checked') == true) {
                checkBox.prop('checked',false);
                $(this).removeClass('selected');
            }
            else {
                checkBox.prop('checked',true);
                $(this).addClass('selected');
            }
        })

        $("#interim").click(function() {
            // identité du prof titulaire
            var prof = $("#listeProfs").find("input:radio:checked");
            var acronymeProf = prof.val();
            var nomProf = prof.data('nomprof');
            // identité du prof interimaire
            var interim = $("#listeInterims").find("input:radio:checked");
            var acronymeInterim = interim.val();
            var nomInterim = interim.data('nomprof');

            $('#inputModalProf').val(acronymeProf);
            $('#inputModalInterim').val(acronymeInterim);

            if ((acronymeProf != undefined) && (acronymeInterim != undefined)) {
                // présenter les cours du prof titulaire
                $.post('inc/users/coursProf.inc.php', {
                        acronyme: acronymeProf,
                        nomProf: nomProf
                    },
                    function(resultat) {
                        $("#coursProf").html(resultat);
                    });
                // pour information, les cours de l'interimaire pressenti
                $.post('inc/users/coursInterim.inc.php', {
                        acronyme: acronymeInterim,
                        nomProf: nomInterim
                    },
                    function(resultat) {
                        $("#coursInterim").html(resultat);
                    })
                $('#modalInterim').modal('show');
            }
        })

    })
<?php echo '</script'; ?>
>
<?php }
}
