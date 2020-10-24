<?php

class PDF_HTML extends PDF_Rotate
{
    protected $B=0;
    protected $I=0;
    protected $U=0;
    protected $HREF='';
    protected $ALIGN='';
    protected $SPAN='';
    protected $COLOR='';
    protected $BACKGROUND='';
    protected $H1 = false;
    protected $H2 = false;
    protected $H3 = false;

    protected $X=0;

    function RotatedText($x,$y,$txt,$angle) {
        //Rotation du texte autour de son origine
        $this->Rotate($angle,$x,$y);
        $this->Text($x,$y,$txt);
        $this->Rotate(0);
    }

    function WriteHTML($html)
    {
        $this->X = $this->GetX();

        //HTML parser
        $html=str_replace("\n", ' ', $html);
        $a=preg_split('/<(.*)>/U', $html, -1, PREG_SPLIT_DELIM_CAPTURE);

        foreach($a as $i => $texte)
        {
            if($i % 2 == 0)
            {
                // si $i est pair,  c'est un texte
                if($this->HREF)
                    $this->PutLink($this->HREF, $texte);
                elseif($this->COLOR != '')
                    $this->SetColor($this->COLOR, $texte);
                elseif($this->BACKGROUND != '')
                    $this->SetBackground($this->BACKGROUND, $texte);
                else {
                    if ($this->H1)
                        $height = 14;
                    elseif ($this->H2)
                        $theigh = 11;
                    elseif ($this->H3)
                        $height = 7;
                    else $height = 5;

                    $this->Write($height, $texte);
                    }
            }
            else
            {
                // si $i est impair, c'est une balise
                // Elle est fermante
                if($texte[0]=='/')
                    $this->CloseTag(strtoupper(substr($texte, 1)));
                else
                {
                    // Ou elle est ouvrante
                    $a2=explode(' ', $texte);
                    // quels sont les attributs
                    $tag=strtoupper(array_shift($a2));
                    $prop=array();

                    foreach($a2 as $v)
                    {
                        if(preg_match('/([^=]*)=["\']?([^"\']*)/', $v, $a3))
                            $prop[strtoupper($a3[1])] = $a3[2];
                    }

                    $this->OpenTag($tag, $prop);
                }
            }
        }
    }

    function OpenTag($tag, $prop)
    {
        //Opening tag
        if ($tag == 'H1') {
            $this->SetTitleSize(18);
            $this->H1 = true;
            }
        if ($tag == 'H2') {
            $this->SetTitleSize(14);
            $this->H2 = true;
            }
        if ($tag == 'H3'){
            $this->SetTitleSize(12);
            $this->H3 = true;
            }
        if ($tag == 'STRONG')
            $this->SetStyle('B', true);
        if ($tag == 'EM')
            $this->SetStyle('I', true);
        if ($tag == 'U')
            $this->SetStyle('U', true);
        if($tag == 'A')
            $this->HREF = $prop['HREF'];
        if($tag == 'SPAN') {
            if (!(empty($prop['STYLE']))) {
                $leStyle = explode(':', $prop['STYLE']);
                if ($leStyle[0] == 'color') {
                    $rvb = $this->hex2dec($leStyle[1]);
                    $this->COLOR = $rvb;
                }
                if ($leStyle[0] == 'background-color') {
                    $rvb = $this->hex2dec($leStyle[1]);
                    $this->BACKGROUND = $rvb;
                }
            }
        }
        if($tag == 'BR') {
            $this->Ln(5);
            $this->SetX($this->X);
        }
        if ($tag == 'P') {
            $this->Ln(5);
            $this->SetX($this->X);
        }

    }

    function titleReset(){
        $this->SetTitleSize(9);
        $this->Ln();
        // get back to the margin
        $this->SetX($this->X);
    }

    function CloseTag($tag)
    {
        //Closing tag
        if($tag=='A')
            $this->HREF='';
        if($tag=='P')
            $this->ALIGN='';
        if ($tag == 'H1') {
            $this->H1 = false;
            $this->titleReset();
        }
        if ($tag == 'H2') {
            $this->H2 = false;
            $this->titleReset();
        }
        if ($tag == 'H3') {
            $this->H3 = false;
            $this->titleReset();
        }
        if ($tag == 'STRONG')
            $this->SetStyle('B', false);
        if ($tag == 'EM')
            $this->SetStyle('I', false);
        if ($tag == 'U')
            $this->SetStyle('U', false);
        if($tag=='SPAN') {
            if ($this->COLOR != '') {
                $this->SetTextColor(0,0,0);
                $this->COLOR = '';
                }
            else if ($this->BACKGROUND != '') {
                $this->SetFillColor(255,255,255);
                $this->BACKGROUND = '';
                }
            }
    }

    function SetStyle($tag, $enable)
    {
        //Modify style and select corresponding font
        $this->$tag+=($enable ? 1 : -1);
        $style='';
        foreach(array('B', 'I', 'U') as $s)
            if($this->$s>0)
                $style.=$s;
        $this->SetFont('', $style);
    }

    function SetColor($rvb, $txt) {
        $this->SetTextColor($rvb['R'],$rvb['V'],$rvb['B']);
        $this->write('5', $txt);
        $this->SetTextColor(0);
    }

    function SetBackground($rvb, $txt) {
        // for some reason, have to push $txt one character (space) to the right
        $posX = $this->GetX();
        $this->Cell($this->GetStringWidth(' '), 5, ' ', 0, 0);
        $this->SetFillColor($rvb['R'],$rvb['V'],$rvb['B']);
        $longueur = $this->GetStringWidth($txt);
        $this->Cell($longueur, 5, $txt, 0, 0, 'C', true);
        $this->SetFillColor(0);
        // get back one character (space) to the left
        $this->SetX($this->GetX()-$this->GetStringWidth(' '));
    }

    function SetTitleSize($size){
        $this->SetFontSize($size);
        $this->SetX($this->X);
    }


    function PutLink($URL, $txt)
    {
        //Put a hyperlink
        $this->SetTextColor(0, 0, 255);
        $this->SetStyle('U', true);
        $this->Write(5, $txt, $URL);
        $this->SetStyle('U', false);
        $this->SetTextColor(0);
    }

    function hex2dec($couleur){
        $R = substr($couleur, 1, 2);
        $rouge = hexdec($R);
        $V = substr($couleur, 3, 2);
        $vert = hexdec($V);
        $B = substr($couleur, 5, 2);
        $bleu = hexdec($B);
        $tbl_couleur = array();
        $tbl_couleur['R']=$rouge;
        $tbl_couleur['V']=$vert;
        $tbl_couleur['B']=$bleu;
        return $tbl_couleur;
    }
}
