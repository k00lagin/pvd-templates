<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Header">
    <xsl:param name="Header"/>
    <xsl:param name="ExtractExists"/>
    <xsl:param name="NoticeExists"/>
    <xsl:param name="Recipient"/>
    <xsl:param name="Agent"/>
    <xsl:param name="Address"/>
    <div class="c">      
      <p>
        <b>
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="$Header/ExtractTitle"/>
          </xsl:call-template>
        </b>
      </p>
    </div>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <td width="15%">Дата выдачи:&#160;</td>
        <td width="15%" class="ul">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="parent::ReestrExtract/DeclarAttribute/@ExtractDate"/>
            <xsl:with-param name="IsDuplicate" select="$ExtractExists > 0 or $NoticeExists > 0"/>
          </xsl:call-template>
        </td>
        <td align="right"> &#160;</td>        
      </tr>
    </table>
    <p>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="$Header/Content"/>
      </xsl:call-template>
    </p>
  </xsl:template>
</xsl:stylesheet>
