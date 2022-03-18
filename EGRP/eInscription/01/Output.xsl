<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="Value">
        <xsl:param name="Node"/>
        <xsl:call-template name="Replace">
            <xsl:with-param name="Old" select="'&#13;'"/>
            <xsl:with-param name="New">
                <br/>
            </xsl:with-param>
            <xsl:with-param name="Text">
                <xsl:call-template name="Replace">
                    <xsl:with-param name="Old" select="';'"/>
                    <xsl:with-param name="New" select="'; '" />
                    <xsl:with-param name="Text">
                        <xsl:call-template name="Replace">
                            <xsl:with-param name="Old" select="','"/>
                            <xsl:with-param name="New" select="', '" />
                            <xsl:with-param name="Text" select="$Node" />
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="Panel">
        <xsl:param name="Text"/>
        <xsl:copy-of select="$Text"/>
    </xsl:template>
    <xsl:template name="Replace">
        <xsl:param name="Text"/>
        <xsl:param name="Old"/>
        <xsl:param name="New"/>
        <xsl:choose>
            <xsl:when test="contains($Text, $Old)">
                <xsl:variable name="Before" select="substring-before($Text, $Old)"/>
                <xsl:value-of select="$Before"/>
                <xsl:choose>
                    <xsl:when test="string($New)">
                        <xsl:value-of select="$New"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$New"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="Replace">
                    <xsl:with-param name="Text">
                        <xsl:choose>
                            <xsl:when test="string-length($Before) > 0 and $Before = substring-before($Text, $New)">
                                <xsl:value-of select="substring-after($Text, $New)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($Text, $Old)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="Old" select="$Old"/>
                    <xsl:with-param name="New" select="$New"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$Text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Documents">
        <xsl:param name="Documents"/>
        <xsl:for-each select="$Documents/Document">
            <xsl:value-of select="current()"/>
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="Parts">
        <xsl:param name="Parts"/>
        <xsl:for-each select="$Parts/PartName">
            <xsl:value-of select="current()"/>
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="Owners">
        <xsl:param name="Owners"/>
        <xsl:for-each select="$Owners/Owner">
            <xsl:value-of select="current()"/>
            <br/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="LabelWithText">
        <xsl:param name="Label"/>
        <xsl:param name="Text"/>
        <xsl:param name="Align" select="left"/>
        <xsl:param name="Width" select="200"/>
        
        <td valign="Top"> 
            <xsl:attribute name="align">
                <xsl:value-of select="$Align"/>
            </xsl:attribute> 
            <xsl:attribute name="width">
                <xsl:value-of select="$Width"/>
            </xsl:attribute>
            <xsl:value-of select="$Label"/> 
        </td>
        <td align="left" valign="Top">
            <xsl:value-of select="$Text"/>
        </td>
    </xsl:template>

    <xsl:template name="LabelWithDate">
        <xsl:param name="Label"/>
        <xsl:param name="Text"/>
        <xsl:param name="Align" select="left"/>
        <xsl:param name="Width" select="200"/>
        
        <td valign="Top"> 
            <xsl:attribute name="align">
                <xsl:value-of select="$Align"/>
            </xsl:attribute> 
            <xsl:attribute name="width">
                <xsl:value-of select="$Width"/>
            </xsl:attribute>
            <xsl:value-of select="$Label"/> 
        </td>
        <td align="left" valign="Top">
            <xsl:call-template name="Date2String">
                <xsl:with-param name="dateString" select="$Text"/>
            </xsl:call-template>			
        </td>
    </xsl:template>
	
    <xsl:template name="LabelWithText4List">
        <xsl:param name="Label"/>
        <xsl:param name="Text"/>
        <xsl:param name="Align" select="left"/>
        <xsl:param name="Width" select="200"/>
        
        <td valign="Top"> 
            <xsl:attribute name="align">
                <xsl:value-of select="$Align"/>
            </xsl:attribute> 
            <xsl:attribute name="width">
                <xsl:value-of select="$Width"/>
            </xsl:attribute>
            <xsl:value-of select="$Label"/> 
        </td>
        <td align="left" valign="Top">
            <xsl:copy-of select="$Text"/>
        </td>
    </xsl:template>

    <xsl:template name="Date2String">
        <xsl:param name="dateString"/>
        <xsl:choose>
            <xsl:when test='$dateString'>
                <xsl:value-of select='substring($dateString,9,2)'/>&#160;
                
                    <xsl:variable name="month" select="substring($dateString,6,2)"/>    
                
                    <xsl:choose>
                        <xsl:when test="$month='01'">января</xsl:when>
                        <xsl:when test="$month='02'">февраля</xsl:when>
                        <xsl:when test="$month='03'">марта</xsl:when>
                        <xsl:when test="$month='04'">апреля</xsl:when>
                        <xsl:when test="$month='05'">мая</xsl:when>
                        <xsl:when test="$month='06'">июня</xsl:when>
                        <xsl:when test="$month='07'">июля</xsl:when>
                        <xsl:when test="$month='08'">августа</xsl:when>
                        <xsl:when test="$month='09'">сентября</xsl:when>
                        <xsl:when test="$month='10'">октября</xsl:when>
                        <xsl:when test="$month='11'">ноября</xsl:when>
                        <xsl:when test="$month='12'">декабря</xsl:when>
                    </xsl:choose>
        		&#160;
                    <xsl:value-of select='substring($dateString,1,4)'/> г.
            </xsl:when>
            <xsl:otherwise>
                «&#160;&#160;&#160;&#160;»&#160;&#160;&#160;&#160;&#160;&#160;
                &#160;&#160;&#160;&#160;&#160; г.
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>	
	
</xsl:stylesheet>
