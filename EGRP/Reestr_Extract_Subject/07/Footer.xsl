<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Footer">
		<xsl:param name="Footer" />
		<xsl:param name="IsDuplicate" />
		<xsl:param name="IsExstract" />
		<p>
			<xsl:choose>
				<xsl:when test="$Footer/ExtractRegion/Region and $IsExstract=1">
					<br />
					<!--<xsl:text>Выписка содержит сведения Единого государственного реестра недвижимости о правах на объекты недвижимости, расположенные на территории :</xsl:text>-->
					<xsl:text
						>Выписка содержит сведения Единого государственного реестра
						недвижимости о правах на объекты недвижимости, расположенные на
						территории субъектов(а) Российской Федерации, указанных(ого) Вами в
						запросе (территориальный орган, осуществляющий функции по
						государственной регистрации прав на недвижимое имущество и сделок с
						ним, государственному кадастровому учету недвижимого имущества на
						подведомственной территории –
					</xsl:text>
					<xsl:for-each select="$Footer/ExtractRegion/Region">
						<xsl:value-of select="./text()" />
					</xsl:for-each>
					<xsl:text>).</xsl:text>
				</xsl:when>
				<xsl:otherwise>&#160;</xsl:otherwise>
			</xsl:choose>
		</p>
		<p>
			<xsl:call-template name="Value">
				<xsl:with-param name="Node" select="$Footer/Content" />
			</xsl:call-template>
		</p>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="40%" class="ful">
					<xsl:call-template name="Value">
						<xsl:with-param
							name="Node"
							select="//Extract/eDocument/Sender/@Appointment"
						/>
						<xsl:with-param name="IsDuplicate" select="$IsDuplicate" />
					</xsl:call-template>
				</td>
				<td width="1%">&#160;</td>
				<td width="12%" class="ful">&#160;</td>
				<td width="1%">&#160;</td>
				<td class="ful">
					<xsl:call-template name="Value">
						<xsl:with-param
							name="Node"
							select="parent::ReestrExtract/DeclarAttribute/@Registrator"
						/>
						<xsl:with-param name="IsDuplicate" select="$IsDuplicate" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="note">(полное наименование должности)</td>
				<td>&#160;</td>
				<td class="note">(подпись, М.П.)</td>
				<td>&#160;</td>
				<td class="note">(инициалы, фамилия)</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
