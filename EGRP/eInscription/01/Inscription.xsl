<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

    <xsl:template match="//eInscription">  

        <html>
            <head>
                <meta http-equiv="X-UA-Compatible" content="IE=8" />
                <title>ЕГРП. Регистрационная надпись</title>
                <style type="text/css">
                    .block{ 
                    border: solid 1px black;
                    width: 700px; 
                    }
                </style>
            </head>
            <body>

                <div class="block">
                    
                    <table border="0" cellspacing="1" cellpadding="1" width="100%" >
                        <tr >
                            <td align="center" colspan="2" style="font-size:12pt" height="30">
								<xsl:call-template name="Panel">
								  <xsl:with-param name="Text">
									<xsl:call-template name="Value">
									  <xsl:with-param name="Node" select="//eInscription/Department"/>
									</xsl:call-template>
								  </xsl:with-param>
								</xsl:call-template>									
                            </td>
                        </tr>
                    </table>                    
                  <xsl:for-each select="//eInscription/Contents/Content">
                          <xsl:variable name="place" select="Number"/>
                          <table border="0" cellspacing="1" cellpadding="1" width="100%" >
                            <tr>
                              <td>&#160;</td>
                            </tr>

                            <tr>
                                <xsl:call-template name="LabelWithText">
                                    <xsl:with-param name="Width">300</xsl:with-param>
                                    <xsl:with-param name="Label"  select="Action"/>
                                    <xsl:with-param name="Text" select="Description"/>
                                </xsl:call-template>
                            </tr>
                            <tr>
                                <xsl:call-template name="LabelWithDate">
                                    <xsl:with-param name="Width">300</xsl:with-param>
                                    <xsl:with-param name="Label">Дата регистрации</xsl:with-param>
                                    <xsl:with-param name="Text" select="Date"/>		
                                </xsl:call-template>								
                            </tr>
                            <xsl:choose>
                              <xsl:when test="contains($place, '&#xD;')">
                                <xsl:variable name="sign" select="'&#xD;'"/>
                              </xsl:when>
                              <xsl:when test="contains($place, '##')">
                                <xsl:variable name="sign" select="'##'"/>
                              </xsl:when>
                            </xsl:choose>
                          <xsl:choose>                            
                            <xsl:when test="contains($place, '##')">
                              <tr>
                                <xsl:call-template name="LabelWithText">
                                  <xsl:with-param name="Width">300</xsl:with-param>
                                  <xsl:with-param name="Label">Номер регистрации</xsl:with-param>
                                  <xsl:with-param name="Text"  select="substring-before($place, '##')"/>
                                </xsl:call-template>
                              </tr>
                            </xsl:when>
                            <xsl:otherwise>
                              <tr>
                                <xsl:call-template name="LabelWithText">
                                  <xsl:with-param name="Width">300</xsl:with-param>
                                  <xsl:with-param name="Label">Номер регистрации</xsl:with-param>
                                  <xsl:with-param name="Text"  select="$place"/>
                                </xsl:call-template>
                              </tr>
                            </xsl:otherwise>
                          </xsl:choose>
                            <tr>
                                <td>&#160;</td>
                            </tr>                                            
                    </table>
                  <table border="0" cellspacing="1" cellpadding="1" width="100%" >
                    <tr>
                      <td>
                        <xsl:value-of select="substring-after($place, '##')"/>
                      </td>  
                    </tr>
                  </table>
                </xsl:for-each>        
                    <table border="0" cellspacing="1" cellpadding="5" width="100%" >

                        <tr>
                            <td width="220" align="left" valign="bottom">Государственный регистратор прав</td>
                            <td width="2">&#160;</td>
                            <td width="50" valign="bottom" align="center" style="border-bottom: solid 1pt black"></td>
                            <td width="2">&#160;</td>
                            <td width="150" align="center" valign="bottom" style="border-bottom: solid 1pt black">
								<xsl:call-template name="Panel">
								  <xsl:with-param name="Text">
									<xsl:call-template name="Value">
									  <xsl:with-param name="Node" select="//eInscription/RegistrarName"/>
									</xsl:call-template>
								  </xsl:with-param>
								</xsl:call-template>							
                            </td>
                        </tr>
                        <tr>
                            <td width="220"></td>
                            <td width="2"></td>
                            <td width="50" valign="top" align="center" style="font-size:8pt">(подпись)</td>
                            <td width="2">&#160;</td>
                            <td width="150" valign="top" align="center" style="font-size:8pt">( Ф.И.О.)</td>
                        </tr>
                    </table>
                </div> 
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>
