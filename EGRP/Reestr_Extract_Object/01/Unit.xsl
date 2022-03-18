<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="GetUnitName">
		<xsl:param name="UnitCode" />
		<xsl:choose>
			<xsl:when test="$UnitCode='012001001000'">
				<xsl:value-of select="'м.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012001002000'">
				<xsl:value-of select="'км.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012002001000'">
				<xsl:value-of select="'кв.м.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012002002000'">
				<xsl:value-of select="'га.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012002003000'">
				<xsl:value-of select="'кв.км.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012003001000'">
				<xsl:value-of select="'сут.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012003002000'">
				<xsl:value-of select="'нед.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012003003000'">
				<xsl:value-of select="'дек.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012003004000'">
				<xsl:value-of select="'мес.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012003005000'">
				<xsl:value-of select="'год'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012004001000'">
				<xsl:value-of select="'руб.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012004002000'">
				<xsl:value-of select="'тыс.руб.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012004003000'">
				<xsl:value-of select="'млн.руб.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012004004000'">
				<xsl:value-of select="'млрд.руб.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012005001000'">
				<xsl:value-of select="'руб./кв.м.'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012005002000'">
				<xsl:value-of select="'руб./га'" />
			</xsl:when>
			<xsl:when test="$UnitCode='012005003000'">
				<xsl:value-of select="'руб./кв.км.'" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
