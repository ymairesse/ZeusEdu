<?php
/**
 * File: SimpleImage.php
 * Author: Simon Jarvis
 * Modified by: Miguel Fermín
 * Based in: http://www.white-hat-web-design.co.uk/articles/php-image-resizing.php.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details:
 * http://www.gnu.org/licenses/gpl.html
 */
class SimpleImage
{
    public $image;
    public $image_type;
    public function __construct($filename = null)
    {
        if (!empty($filename)) {
            $this->load($filename);
        }
    }
    public function load($filename)
    {
        $image_info = getimagesize($filename);
        $this->image_type = $image_info[2];
        if ($this->image_type == IMAGETYPE_JPEG) {
            $this->image = imagecreatefromjpeg($filename);
        } elseif ($this->image_type == IMAGETYPE_GIF) {
            $this->image = imagecreatefromgif($filename);
        } elseif ($this->image_type == IMAGETYPE_PNG) {
            $this->image = imagecreatefrompng($filename);
        } else {
            throw new Exception("The file you're trying to open is not supported");
        }
    }
    public function save($filename, $image_type = IMAGETYPE_JPEG, $compression = 75, $permissions = null)
    {
        echo $image_type;
        if ($image_type == IMAGETYPE_JPEG) {
            $test = imagejpeg($this->image, $filename, $compression);
        } elseif ($image_type == IMAGETYPE_GIF) {
            $test = imagegif($this->image, $filename);
        } elseif ($image_type == IMAGETYPE_PNG) {
            $test = imagepng($this->image, $filename);
        }
        if ($permissions != null) {
            chmod($filename, $permissions);
        }
    }
    public function output($image_type = IMAGETYPE_JPEG, $quality = 80)
    {
        if ($image_type == IMAGETYPE_JPEG) {
            header('Content-type: image/jpeg');
            imagejpeg($this->image, null, $quality);
        } elseif ($image_type == IMAGETYPE_GIF) {
            header('Content-type: image/gif');
            imagegif($this->image);
        } elseif ($image_type == IMAGETYPE_PNG) {
            header('Content-type: image/png');
            imagepng($this->image);
        }
    }
    public function getWidth()
    {
        return imagesx($this->image);
    }
    public function getHeight()
    {
        return imagesy($this->image);
    }
    public function resizeToHeight($height)
    {
        $ratio = $height / $this->getHeight();
        $width = round($this->getWidth() * $ratio);
        $this->resize($width, $height);
    }
    public function resizeToWidth($width)
    {
        $ratio = $width / $this->getWidth();
        $height = round($this->getHeight() * $ratio);
        $this->resize($width, $height);
    }
    public function square($size)
    {
        $new_image = imagecreatetruecolor($size, $size);
        if ($this->getWidth() > $this->getHeight()) {
            $this->resizeToHeight($size);

            imagecolortransparent($new_image, imagecolorallocate($new_image, 0, 0, 0));
            imagealphablending($new_image, false);
            imagesavealpha($new_image, true);
            imagecopy($new_image, $this->image, 0, 0, ($this->getWidth() - $size) / 2, 0, $size, $size);
        } else {
            $this->resizeToWidth($size);

            imagecolortransparent($new_image, imagecolorallocate($new_image, 0, 0, 0));
            imagealphablending($new_image, false);
            imagesavealpha($new_image, true);
            imagecopy($new_image, $this->image, 0, 0, 0, ($this->getHeight() - $size) / 2, $size, $size);
        }
        $this->image = $new_image;
    }

    public function scale($scale)
    {
        $width = $this->getWidth() * $scale / 100;
        $height = $this->getHeight() * $scale / 100;
        $this->resize($width, $height);
    }

    public function resize($width, $height)
    {
        $new_image = imagecreatetruecolor($width, $height);

        imagecolortransparent($new_image, imagecolorallocate($new_image, 0, 0, 0));
        imagealphablending($new_image, false);
        imagesavealpha($new_image, true);

        imagecopyresampled($new_image, $this->image, 0, 0, 0, 0, $width, $height, $this->getWidth(), $this->getHeight());
        $this->image = $new_image;
    }
    public function cut($x, $y, $width, $height)
    {
        $new_image = imagecreatetruecolor($width, $height);
        imagecolortransparent($new_image, imagecolorallocate($new_image, 0, 0, 0));
        imagealphablending($new_image, false);
        imagesavealpha($new_image, true);
        imagecopy($new_image, $this->image, 0, 0, $x, $y, $width, $height);
        $this->image = $new_image;
    }
    public function maxarea($width, $height = null)
    {
        $height = $height ? $height : $width;

        if ($this->getWidth() > $width) {
            $this->resizeToWidth($width);
        }
        if ($this->getHeight() > $height) {
            $this->resizeToheight($height);
        }
    }

    public function minarea($width, $height = null)
    {
        $height = $height ? $height : $width;

        if ($this->getWidth() < $width) {
            $this->resizeToWidth($width);
        }
        if ($this->getHeight() < $height) {
            $this->resizeToheight($height);
        }
    }
    public function cutFromCenter($width, $height)
    {
        if ($width < $this->getWidth() && $width > $height) {
            $this->resizeToWidth($width);
        }
        if ($height < $this->getHeight() && $width < $height) {
            $this->resizeToHeight($height);
        }

        $x = ($this->getWidth() / 2) - ($width / 2);
        $y = ($this->getHeight() / 2) - ($height / 2);

        return $this->cut($x, $y, $width, $height);
    }
    public function maxareafill($width, $height, $red = 0, $green = 0, $blue = 0)
    {
        $this->maxarea($width, $height);
        $new_image = imagecreatetruecolor($width, $height);
        $color_fill = imagecolorallocate($new_image, $red, $green, $blue);
        imagefill($new_image, 0, 0, $color_fill);
        imagecopyresampled($new_image,
                            $this->image,
                            floor(($width - $this->getWidth()) / 2),
                            floor(($height - $this->getHeight()) / 2),
                            0, 0,
                            $this->getWidth(),
                            $this->getHeight(),
                            $this->getWidth(),
                            $this->getHeight()
                        );
        $this->image = $new_image;
    }
}
