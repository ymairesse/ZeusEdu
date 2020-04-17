<?php

if ($userStatus == 'educ')
    $smarty->assign('icones', 'books/booksIcons');
    else $smarty->assign('icones', Null);


switch ($mode) {
    case 'edit':
        $smarty->assign('searchBar', Null);
        $smarty->assign('formulaire', 'books/gestBook');
        break;
    case 'emprunt':
        $smarty->assign('searchBar', Null);
        $smarty->assign('formulaire', 'books/formEmprunt');
        break;
    default:
        $smarty->assign('searchBar', Null);
        $smarty->assign('formulaire', 'books/homeBook');
        break;
}

$smarty->assign('corpsPage', 'books/mainPage');
