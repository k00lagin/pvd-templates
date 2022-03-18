<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Extract">
		<xsl:param name="Extract" />
		<xsl:variable name="FooterRecipient" select="FootContent/Recipient" />
		<xsl:for-each select="$Extract">
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<td width="1%">1</td>
					<td width="30%">
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
									<xsl:when test="Object/ObjectTypeText">
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="Object/ObjectTypeText"
											/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>2</td>
					<td>
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
									<xsl:when test="Object/CadastralNumber">
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="Object/CadastralNumber"
											/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>данные отсутствуют</xsl:text>
										<!--<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="ObjectDesc/ConditionalNumber"/>
										</xsl:call-template>-->
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>3</td>
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
										select="Object/ObjectAddress/Content"
									/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</table>
			<table class="t" border="0" cellpadding="2" cellspacing="0" width="100%">
				<xsl:for-each select="RightAsserts">
					<tr>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="RightAssertText" />
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:for-each>
		<p>
			<xsl:text>Получатель выписки: </xsl:text>
			<xsl:value-of select="$FooterRecipient" />
		</p>
	</xsl:template>
</xsl:stylesheet>
