<?php
/* Smarty version 3.1.34-dev-7, created on 2021-04-27 14:06:37
  from '/home/yves/www/sio2/peda/edt/edt.css' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6087fe4dbd3239_81938562',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'f9875bdba1f3369ac48c0c93115421d4583f6bfb' => 
    array (
      0 => '/home/yves/www/sio2/peda/edt/edt.css',
      1 => 1619464352,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6087fe4dbd3239_81938562 (Smarty_Internal_Template $_smarty_tpl) {
?>.cours {
    font-weight:normal !important;
}

.bat_A {
    background-color: #ff5555 !important;
    color: #111 !important;
}
.bat_B {
    background-color: #5555ff !important;
}
.bat_C {
    background-color: #22ff22 !important;
    color:black !important;
}
.bat_F {
    background-color: #00ccff !important;
    color: black !important;
}

table.table-absences td {
    border: 1px solid #aaa !important;
    font-size: 8pt;
    height: 80px;
}

.table-absences .draggable {
    background: #eee;
}

.repris {
    background: #F0AD4E !important;
}
.licencie {
    background: #d9534f !important;
    color: black;
}
.travaux {
    background: #5bc0de !important;
}
.educ {
    background: #5cb85c !important;
}

.autre {
    background: pink !important;
}

.periodeActive {
    background: yellow;
}

.table-absences td div[draggable="true"] {
        cursor: move;
        }

.table-absences[draggable=false] {
    cursor: no-drop;
    }

.table-absences .dropMe {
    background-color: #00ff00 !important;
    }
.table-absences .drop {
    background-color: #daf4aa;
    }

/* l'objet a été déplacé */
.wasDragged, .movedFrom {
    background-color: #ffff0096;
    cursor: not-allowed;
    opacity: 0.6;
    cursor: no-drop;
    color: #999;

    }

/* un objet a été déposé sur cet élément */
.dropped, .movedTo {
    background-color: #ffff00 !important;
    cursor: no-drop !important;
    }

.table-absences .dropped, .table-absences .dropped > div {
    cursor: no-drop !important;;
}

/* l'objet est en cours de déplacement */
.table-absences .enroute {
    background-color: #99f !important;
    opacity: 0.6;
    }

#tableInfos th, #tableInfos td {
  border: 1px solid #999;
  border-collapse: collapse;
}

#listeInfos td li {
    border-bottom: 1px solid #F6D58F;
    cursor: pointer;
}

.opacity0 {
    opacity: 0.2;
}
.opacity100 {
    opacity: 100;
}
.badge {
    font-size: 6pt;
}
.actif {
    background-color: #fff;
}

.bottom {
    background: #ff6;
}

#contextMenu {
  position: absolute;
  display: none;
}

tr.indisponible > th {
    text-decoration: line-through;
    font-weight: normal;
    background-color: #ccc;

}
<?php }
}
