<?php

switch ($mode) {
    case 'photos':
        $unAn = time() + 365 * 24 * 3600;
        if (!isset($_COOKIE['photosVis'])) {
            setcookie('photosVis', 'visible', $unAn);
        } else {
                if ($_COOKIE['photosVis'] == 'visible') {
                    setcookie('photosVis', 'invisible', $unAn);
                } else {
                    setcookie('photosVis', 'visible', $unAn);
                }
            }
        break;
    default:
        // wtf
}
