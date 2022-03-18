<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Footer">
		<xsl:param name="Footer" />
		<xsl:param name="IsDuplicate" />
		<br />
		<br />
		<br />
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="30%" class="ful">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Государственный регистратор</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td width="1%">&#160;</td>
				<td width="25%" class="ful">&#160;</td>
				<td width="1%">&#160;</td>
				<td class="ful">
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="$Footer/Registrator" />
						<xsl:with-param name="IsDuplicate" select="$IsDuplicate" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="note">&#160;</td>
				<td>&#160;</td>
				<td class="note">(подпись, М.П.)</td>
				<td>&#160;</td>
				<td class="note">(фамилия, инициалы)</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
