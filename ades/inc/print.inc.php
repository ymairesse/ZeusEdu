<?php
if (isset($eleve)) {
	switch ($mode) {
		case 'retenue':
			$idfait = isset($_REQUEST['idfait'])?$_REQUEST['idfait']:Null;
			$infosFait = $Ades->infosFait($idfait);
			foreach ($infosFait as $key=>$chaine) 
				$infosFait[$key] = html_entity_decode($chaine);
			$idretenue = $infosFait['idretenue'];
			$infosRetenue = $Ades->infosRetenue ($idretenue);
			$data = array('fait'=>$infosFait,'eleve'=>$eleve->getDetailsEleve(), 'retenue'=>$infosRetenue);
			$Ades->printRetenue($data,$acronyme);
			$smarty->assign('corpsPage','billetRetenue');
			break;
		default:
			
			break;
		}
}
	
?>