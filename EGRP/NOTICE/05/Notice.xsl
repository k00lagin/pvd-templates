<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Notice">
		<xsl:param name="Notice" />
		<br />
		<table class="t" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="100%">
					<xsl:choose>
						<xsl:when test="NoticeBody/LawBase">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/LawBase" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="NoticeBody/DocFound">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/DocFound" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="NoticeBody/KUVD_Date">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/KUVD_Date" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="NoticeBody/NoticeSubject">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/NoticeSubject" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="NoticeBody/Reasons">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/Reasons" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td width="100%">
					<xsl:choose>
						<xsl:when test="NoticeBody/Content">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="NoticeBody/Content" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</table>
		<br />
		<br />
		<br />
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="40%" class="ful">
					<xsl:choose>
						<xsl:when test="DeclarAttribute/RegAppointment">
							<xsl:call-template name="Value">
								<xsl:with-param
									name="Node"
									select="DeclarAttribute/RegAppointment"
								/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Государственный регистратор</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="1%">&#160;</td>
				<td width="12%" class="ful">&#160;</td>
				<td width="1%">&#160;</td>
				<td class="ful">
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="DeclarAttribute/Registrator" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<xsl:choose>
					<xsl:when test="DeclarAttribute/RegAppointment">
						<td class="note">(должность уполномоченного должностного лица)</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="note">&#160;</td>
					</xsl:otherwise>
				</xsl:choose>
				<td>&#160;</td>
				<td class="note">(подпись, М.П.)</td>
				<td>&#160;</td>
				<td class="note">(фамилия, инициалы)</td>
			</tr>
		</table>
		<br />
		<br />
		<div style="font-size: x-small">
			<xsl:choose>
				<xsl:when test="DeclarAttribute/OperatorNameFull">
					<xsl:text>Исполнитель:</xsl:text>
					<br />
					<xsl:call-template name="Value">
						<xsl:with-param
							name="Node"
							select="DeclarAttribute/OperatorNameFull"
						/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="DeclarAttribute/OperatorTel">
					<xsl:text>, телефон:</xsl:text>
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="DeclarAttribute/OperatorTel" />
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
</xsl:stylesheet>
