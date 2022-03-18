<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Header">
    <xsl:param name="Header"/>
    <xsl:param name="ExtractExists"/>
    <xsl:param name="NoticeExists"/>
    <xsl:param name="Recipient"/>
    <xsl:param name="Agent"/>
    <xsl:param name="PostIndex"/>
    <xsl:param name="Address"/>
    <div class="c">
          <div class="ExtractHeaderMargin">&#160;</div>
      <p>
        <b>
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="$Header/NoticeName"/>
          </xsl:call-template>
        </b>
      </p>
      <p>
        <b>
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="$Header/DeptName"/>
          </xsl:call-template>
        </b>
      </p>
      <table class="NoticeHeaderNumber" border="0" cellspacing="0" cellpadding="0" width="25%">
        <tr>
          <td align="left">Дата&#160;</td>
          <td align="left" width="15%" class="ul">
            <xsl:call-template name="Value">
              <xsl:with-param name="Node" select="DeclarAttribute/NoticeDate"/>
            </xsl:call-template>
          </td>
          <td align="right">&#160;&#160;</td>
          <td align="right">&#160;&#160;</td>
        </tr>
      </table> 
      <table class="t" border="0" cellpadding="2" cellspacing="0" width="100%">
      <tr>
       <td class="vc" width="100%">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="RealReg/HeadContent"/>
          </xsl:call-template>
      </td> 
     </tr>
      </table>  
    </div> 
  </xsl:template>
</xsl:stylesheet>
