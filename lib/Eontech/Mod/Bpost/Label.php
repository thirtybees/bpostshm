<?php
/**
 * bPost Label class
 *
 * @author    Tijs Verkoyen <php-bpost@verkoyen.eu>
 * modified  Serge <serge@stigmi.eu>
 *          Needed to modify this to allow multiple barcodes per label
 * @version   3.0.0
 * @copyright Copyright (c), Tijs Verkoyen. All rights reserved.
 * @license   BSD License
 */

class EontechModBpostLabel
{
	/**
	 * barcode tags
	 *
	 * @var array
	 */
	private $barcodes;

	/**
	 * @var string
	 */
	private $mime_type;

	/**
	 * @var string
	 */
	private $bytes;

	/**
	 * @param string $barcode
	 */
	public function addBarcode($barcode)
	{
		$this->barcodes[] = $barcode;
	}

	/**
	 * @return array
	 */
	public function getBarcodes()
	{
		return $this->barcodes;
	}

	/**
	 * @param string $bytes
	 */
	public function setBytes($bytes)
	{
		$this->bytes = $bytes;
	}

	/**
	 * @return string
	 */
	public function getBytes()
	{
		return $this->bytes;
	}

	/**
	 * @param string $mime_type
	 * @throws EontechModException
	 */
	public function setMimeType($mime_type)
	{
		if (!in_array($mime_type, self::getPossibleMimeTypeValues()))
			throw new EontechModException(
				sprintf(
					'Invalid value, possible values are: %1$s.',
					implode(', ', self::getPossibleMimeTypeValues())
				)
			);

		$this->mime_type = $mime_type;
	}

	/**
	 * @return string
	 */
	public function getMimeType()
	{
		return $this->mime_type;
	}

	/**
	 * @return array
	 */
	public static function getPossibleMimeTypeValues()
	{
		return array(
			'image/png',
			'image/pdf',
			'application/pdf',
		);
	}

	/**
	 * Output the bytes directly to the screen
	 */
	public function output()
	{
		header('Content-type: '.$this->getMimeType());
		echo $this->getBytes();
		exit;
	}

	/**
	 * @param  \SimpleXMLElement $xml
	 * @return EontechModBpostLabel
	 */
	public static function createFromXML(\SimpleXMLElement $xml)
	{
		$label = new EontechModBpostLabel();
		if (isset($xml->barcode))
			foreach ($xml->barcode as $barcode)
				$label->addBarcode((string)$barcode);
		if (isset($xml->mimeType) && $xml->mimeType != '')
			$label->setMimeType((string)$xml->mimeType);
		if (isset($xml->bytes) && $xml->bytes != '')
			$label->setBytes((string)base64_decode($xml->bytes));

		return $label;
	}
}
