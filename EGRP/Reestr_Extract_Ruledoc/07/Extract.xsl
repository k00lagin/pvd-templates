<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Extract">
		<xsl:param name="Extract" />
		<xsl:variable name="FooterRecipient" select="FootContent/Recipient" />
		<xsl:for-each select="$Extract">
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<td width="40%">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Вид объекта недвижимости:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param
										name="Node"
										select="ObjectDesc/ObjectTypeText"
									/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Кадастровый номер:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
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
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Адрес:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
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
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Дата закрытия раздела ЕГРН:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param name="Node" select="ObjectDesc/ReEndDate" />
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="ObjectDesc/MdfDate">
						<tr>
							<td>
								<i style="mso-bidi-font-style: normal">
									<xsl:call-template name="Panel">
										<xsl:with-param name="Text">
											<xsl:text>дата модификации:</xsl:text>
										</xsl:with-param>
									</xsl:call-template>
								</i>
							</td>
							<td colspan="2">
								<i style="mso-bidi-font-style: normal">
									<xsl:call-template name="Panel">
										<xsl:with-param name="Text">
											<xsl:call-template name="Value">
												<xsl:with-param
													name="Node"
													select="ObjectDesc/MdfDate"
												/>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</i>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Реквизиты правоустанавливающего документа:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td colspan="2">
						<xsl:for-each select="DocFound">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="Name">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="Name" />
											</xsl:call-template>
											<xsl:if test="Series">
												<xsl:text>&#160;</xsl:text>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Series" />
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="Number">
												<xsl:text>&#160;№&#160;</xsl:text>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Number" />
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="Date">
												<xsl:text>&#160;от&#160;</xsl:text>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Date" />
												</xsl:call-template>
											</xsl:if>
											<br />
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<b>Содержание правоустанавливающего документа:</b>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<xsl:for-each select="DocFound">
					<tr>
						<td colspan="3">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Content" />
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
				<tr>
					<td colspan="2">
						<xsl:text>Получатель выписки:</xsl:text>
					</td>
					<td>
						<xsl:value-of select="$FooterRecipient" />
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
