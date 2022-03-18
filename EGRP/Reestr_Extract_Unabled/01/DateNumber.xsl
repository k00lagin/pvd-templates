<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="DateNumber">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="40px" align="center">Дата</td>
				<td width="100px" align="center" style="border-bottom: solid 1pt black">
					<xsl:value-of select="ReestrExtract/@ExtractDate" />
				</td>
				<td align="right">№&#160;</td>
				<td width="150px" align="center" style="border-bottom: solid 1pt black">
					<xsl:value-of select="ReestrExtract/@ExtractNumber" />
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
