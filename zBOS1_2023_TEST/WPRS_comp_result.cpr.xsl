<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--  To see the input used for this xslt, check the "Create source.xml file 
        when creating report" menu item under the "Reports" menu in FsComp.
        When checked a .source.xml file is created each time you create a report.
        It shows the actual xml input to the xslt processor.
        This is helpfull if you like to modify this file.
  -->

  <xsl:output method="text" encoding="utf-8" indent="no" />

  <!--  Set the decimal separator to be used (. or ,) when decimal data is displayed.
        All decimal data in the source is with . and will be displayed with . unless
        formated otherwise using format-number() function.
  -->
  <xsl:variable name="decimal_separator" select="'.'"/>
  <xsl:decimal-format decimal-separator='.' grouping-separator=' ' />
  <!-- note! make sure both above use same, ie either . or ,!! -->

  <xsl:param name="top_x_tasks">all</xsl:param>
  <xsl:param name="result_id" select="0"></xsl:param>
  <xsl:param name="tasks" select="0"></xsl:param>

  <!--  The node-set that this variable returns is what is used 
        to create the result list.
        Here some of the params above is used.
  -->
  <xsl:variable name="comp_result" select="/Fs/FsCompetition[1]/FsCompetitionResults/FsCompetitionResult[@top=$top_x_tasks and @id=$result_id and @tasks=$tasks]"/>
  <xsl:variable name="filter" select="$comp_result/FsParticipant"/>
  
  <!-- string replacement -->
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
		  <xsl:when test="contains($text,$replace)">
			<xsl:value-of select="substring-before($text,$replace)"/>
			<xsl:value-of select="$with"/>
			<xsl:call-template name="replace-string">
			  <xsl:with-param name="text" select="substring-after($text,$replace)"/>
			  <xsl:with-param name="replace" select="$replace"/>
			  <xsl:with-param name="with" select="$with"/>
			</xsl:call-template>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="$text"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:template>


  <!-- record template, used for each pilot in the ranked list of pilots -->
  <xsl:template name="record">
    <xsl:variable name="pilot_id" select="@id"/>
	<xsl:variable name="new_sponsor">
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@sponsor"/>
			<xsl:with-param name="replace" select="'&#xD;&#xA;'" />
			<xsl:with-param name="with" select="' '"/>
		</xsl:call-template>
	</xsl:variable>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@name"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@nat_code_3166_a3"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="@points"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@female"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@birthday"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@fai_licence"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@glider"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="$new_sponsor"/>
    <xsl:text><![CDATA[	]]></xsl:text>
    <xsl:value-of select="/Fs/FsCompetition/FsParticipants/FsParticipant[@id=$pilot_id]/@CIVLID"/>
    <xsl:text><![CDATA[
]]></xsl:text>
  </xsl:template>

  <xsl:template match="/">
    <xsl:text><![CDATA[Name	NAT	Score	Female	Birthday	Valid FAI licence	Glider	Sponsor	CIVL ID
]]></xsl:text>
    <xsl:for-each select="$filter">
      <!-- participant rows -->
      <xsl:call-template name="record"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
