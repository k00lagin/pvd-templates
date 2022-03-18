<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="GetAreaName">
		<xsl:param name="AreaCode"/>
		<xsl:choose>
			<xsl:when test="$AreaCode='001'">
				<xsl:value-of select="'Площадь застройки'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='002'">
				<xsl:value-of select="'Общая площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='003'">
				<xsl:value-of select="'Общая площадь без лоджии'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='004'">
				<xsl:value-of select="'Общая площадь с лоджией'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='005'">
				<xsl:value-of select="'Жилая площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='007'">
				<xsl:value-of select="'Основная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='008'">
				<xsl:value-of select="'Декларированная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='009'">
				<xsl:value-of select="'Уточненная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='010'">
				<xsl:value-of select="'Фактическая площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='011'">
				<xsl:value-of select="'Вспомогательная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='012'">
				<xsl:value-of select="'Площадь помещений общего пользования без лоджии'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='013'">
				<xsl:value-of select="'Площадь помещений общего пользования с лоджией'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='014'">
				<xsl:value-of select="'Технические помещения (Прочие) без лоджии'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='015'">
				<xsl:value-of select="'Технические помещения (Прочие) с лоджией'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='020'">
				<xsl:value-of select="'Застроенная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='021'">
				<xsl:value-of select="'Незастроенная площадь'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='022'">
				<xsl:value-of select="'Значение площади отсутствует'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='023'">
				<xsl:value-of select="'Протяженность'"/>
			</xsl:when>
			<xsl:when test="$AreaCode='024'">
				<xsl:value-of select="'Степень готовности'"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
