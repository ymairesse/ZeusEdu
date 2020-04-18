<?php

switch ($mode) {
    case 'categories':
        require_once 'inc/forums/gestCategories.php';
        break;
    case 'sujets':
        echo "sujets";
        break;
    case 'lecture':
        echo "lecture";
        break;
}
