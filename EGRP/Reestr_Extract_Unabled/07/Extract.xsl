<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Extract">
		<xsl:param name="Extract" />
		<xsl:variable name="FooterRecipient" select="FootContent/Recipient" />
		<xsl:for-each select="$Extract">
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<td width="25%">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Правообладатель:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:choose>
									<xsl:when test="Person">
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="Person/Content" />
										</xsl:call-template>
										<xsl:choose>
											<xsl:when test="Person/MdfDate">
												<br />
												<i style="mso-bidi-font-style: normal">
													<xsl:text>Дата модификации:</xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param
															name="Node"
															select="Person/MdfDate"
														/>
													</xsl:call-template>
												</i>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="Organization">
										<xsl:call-template name="Value">
											<xsl:with-param
												name="Node"
												select="Organization/Content"
											/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="Governance">
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="Governance/Content" />
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Признан:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param name="Node" select="StageUnabled" />
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Наименование суда:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param name="Node" select="JudicialName" />
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:text>Решение суда:</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param name="Node" select="DecisionAttribut" />
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:text>Получатель выписки:</xsl:text>
					</td>
					<td>
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:call-template name="Value">
									<xsl:with-param name="Node" select="$FooterRecipient" />
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
