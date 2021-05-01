<?php

switch ($mode) {
	case 'stage':
		require_once 'inc/stages/encodageStages.php';
		break;

	default:
		require_once 'inc/encodageBulletins.php';
		break;
}
