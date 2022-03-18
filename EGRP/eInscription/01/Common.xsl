<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />
	<xsl:include href="Output.xsl" />
	<xsl:include href="Inscription.xsl" />

	<xsl:template match="/">
		<!-- тут сделать проверку версии-->
		<!-- <xsl:template match="Extract[eDocument[@Version='04']]">-->

		<!-- <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
						<fo:layout-master-set>
								<fo:simple-page-master master-name="A4"
																			 page-width="297mm" page-height="210mm"
																			 margin-top="0.5in" margin-bottom="0.5in"
																			 margin-left="0.5in" margin-right="0.5in">
										<fo:region-body/>
								</fo:simple-page-master>
						</fo:layout-master-set>

						<fo:page-sequence master-reference="A4">
								<fo:flow flow-name="xsl-region-body">
										<xsl:apply-templates />
								</fo:flow>
						</fo:page-sequence>
				</fo:root>-->

		<xsl:apply-templates />
	</xsl:template>
</xsl:stylesheet>
