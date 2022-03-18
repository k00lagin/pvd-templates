<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Notice">
		<xsl:param name="Notice" />
		<xsl:for-each select="$Notice">
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<td width="1%">1.</td>
					<td width="33%">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Вид объекта недвижимости:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:choose>
									<xsl:when test="ObjectDesc/ObjectTypeText">
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="ObjectDesc/ObjectTypeText"
											/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td width="1%">2.</td>
					<td width="33%">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Кадастровый номер:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:choose>
									<xsl:when test="ObjectDesc/CadastralNumber">
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="ObjectDesc/CadastralNumber"
											/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="ObjectDesc/ConditionalNumber"
											/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td width="1%">3.</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Адрес:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param
										name="Node"
										select="ObjectDesc/Address/Content"
									/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</table>
			<xsl:call-template name="Value">
				<xsl:with-param name="Node" select="NoticeText" />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
