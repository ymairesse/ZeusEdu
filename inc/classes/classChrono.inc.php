<?php

class Chrono {

    var $ini;

    function __construct() {
        $this->start();
    }

    function getMicrotime(){
		$temps = explode(' ', microtime());
		return $temps[0]+$temps[1];
    }

    function start() {
		$this->ini = $this->getMicrotime();
    }

    function stop() {
        $temps = $this->getMicrotime();
        $this->duree  = $temps - $this->ini;
        return $this->duree;
    }

}

?>
