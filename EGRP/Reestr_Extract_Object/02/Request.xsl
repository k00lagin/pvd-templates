<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Request">
		<xsl:text>На основании запроса</xsl:text>
		<xsl:if test="ReestrExtract/@RequeryNumber and not(ReestrExtract/@RequeryNumber='')">
			<xsl:value-of select="concat(' № ',//ReestrExtract/@RequeryNumber)"/>
		</xsl:if>
		<xsl:if test="ReestrExtract/@RequeryDate and not(ReestrExtract/@RequeryDate='')">
			<xsl:value-of select="concat(' от ',//ReestrExtract/@RequeryDate)"/>
		</xsl:if>
		<xsl:text>, поступившего на рассмотрение</xsl:text>
		<xsl:if test="ReestrExtract/@OfficeDate and not(ReestrExtract/@OfficeDate='')">
			<xsl:value-of select="concat(' ',//ReestrExtract/@OfficeDate)"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
