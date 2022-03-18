<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="HeaderNotice">
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<tr align="center">
				<td width="50%">
					<p>
						ФЕДЕРАЛЬНАЯ СЛУЖБА ГОСУДАРСТВЕННОЙ РЕГИСТРАЦИИ,<br />КАДАСТРА И
						КАРТОГРАФИИ
					</p>
					<p>
						<xsl:value-of select="eDocument/Sender/@Name" />
					</p>
				</td>
				<td>
					<xsl:value-of select="ReestrExtract/Recipient" />
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
