<CFPARAM NAME="Attributes.URLPath" DEFAULT="">
<CFPARAM NAME="Attributes.Limit" DEFAULT="0">
<CFPARAM NAME="Attributes.Start" DEFAULT="1">

<CFIF IsNumeric(ListGetAt(Attributes.Limit,1)) IS 0 OR ListGetAt(Attributes.Limit,1) LTE 0>
	<CFSET Attributes.Limit = -1>
</CFIF>
<CFIF IsNumeric(ListGetAt(Attributes.Start,1)) IS 0 OR ListGetAt(Attributes.Start,1) LTE 0>
	<CFSET Attributes.Start = 1>
</CFIF>

<CFSWITCH EXPRESSION="#ListFirst(Attributes.URLPath,"/")#">
	<CFCASE VALUE="planets">
		<CFINCLUDE TEMPLATE="page-query-planet.cfm">
		<!--- Landing Page: DONE --->
		<!--- Specific Planet: DONE --->
		<!--- Compare the Planets: TO DO --->
	</CFCASE>
	<CFCASE VALUE="missions">
		<CFINCLUDE TEMPLATE="page-query-mission.cfm">
		<!--- Landing Page: DONE --->
		<!--- List View: DONE --->
		<!--- By Name: TO DO --->
		<!--- By Year: TO DO --->
		<!--- Specific Mission: DONE --->
	</CFCASE>
	<CFCASE VALUE="news">
		<CFINCLUDE TEMPLATE="page-query-news.cfm">
		<!--- Landing Page: DONE --->
		<!--- Archive: DONE --->
		<!--- Specific Article: DONE --->
		<!--- Calendar: TO DO --->
		<!--- FAQ: TO DO --->
	</CFCASE>
	<CFCASE VALUE="people">
		<CFINCLUDE TEMPLATE="page-query-people.cfm">
		<!--- Landing Page/Featured People: DONE --->
		<!--- Archive: DONE --->
		<!--- Specific Person: DONE --->
	</CFCASE>
	<CFCASE VALUE="galleries">
		<CFINCLUDE TEMPLATE="page-query-galleries.cfm">
		<!--- Landing Page: DONE --->
		<!--- Image Gallery: DONE --->
		<!--- Specific Image Details: DONE --->
		<!--- Video Gallery: DONE --->
		<!--- Specific Video Details: DONE --->
		<!--- Download Gallery: DONE --->
		<!--- Specific Download Details: DONE --->
		<!--- Interactive Gallery: DONE --->
	</CFCASE>
	<CFCASE VALUE="educ">
		<CFINCLUDE TEMPLATE="page-query-educ.cfm">
	</CFCASE>
	<CFDEFAULTCASE>
		<!--- Planet Carousel: TO DO --->
		<!--- Fast Lesson Finder: TO DO --->
	</CFDEFAULTCASE>
</CFSWITCH>

<CFIF IsDefined("PageOutput.Content") IS 0>
	<!--- Generic Content Page --->
	<CFQUERY NAME="qryContentPageInfo" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_content_pages
	WHERE LOWER(DirectoryName) = '#LCase(ListFirst(Attributes.URLPath,"/"))#'
		AND (LOWER(FileName)
		<CFIF ListLen(Attributes.URLPath,"/") GT 1>
			= '#LCase(ListRest(Attributes.URLPath,"/"))#'
		<CFELSE>
			= 'index'
		</CFIF>
		)
		AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
	</CFQUERY>

	<CFSET PageOutput = StructNew()>
	<CFSET SidebarOutput = StructNew()>

	<CFIF qryContentPageInfo.RecordCount GT 0>
		<CFSET PageOutput.Section = ListFirst(Attributes.URLPath,"/")>
		<CFSET PageOutput.Title = qryContentPageInfo.PageName>
		<CFSET PageOutput.Path = "#qryContentPageInfo.DirectoryName#/#qryContentPageInfo.FileName#">
		<CFSET PageOutput.UpdateDate = DateFormat(qryContentPageInfo.DateModified,"d mmm yyyy")>
		<CFIF FileExists(ExpandPath("../text/#ListFirst(Attributes.URLPath,"/")#/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt"))>
			<CFFILE ACTION="Read" FILE="#ExpandPath("../text/#ListFirst(Attributes.URLPath,"/")#/#Replace(qryContentPageInfo.FileName,"/","-","All")#.txt")#" VARIABLE="PageText">
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#PageText#"
				OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
			<CFSET PageOutput.Content = CEval(PageTextModified)>
		</CFIF>
		
		<CFQUERY NAME="qrySubPages" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_content_pages
		WHERE ParentID = #qryContentPageInfo.PageID#
			AND Status = 'Active'
		ORDER BY PageOrder
		</CFQUERY>
		
		<CFSET SidebarOutput.Subnav = ArrayNew(1)>
		<CFLOOP QUERY="qrySubPages">
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav) + 1] = StructNew()>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].Title = qrySubPages.NavTitle>
			<CFSET SidebarOutput.Subnav[ArrayLen(SidebarOutput.Subnav)].URL = "#qrySubPages.DirectoryName#/#qrySubPages.FileName#">
		</CFLOOP>
		
		<CFIF Request.ShowAdmin GT 0>
			<CFSET PageOutput.AdminLinks = ArrayNew(1)>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-edit.cfm?URLPath=#PageOutput.Path#">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-delete.cfm?URLPath=#PageOutput.Path#">
			<CFIF qryContentPageInfo.Status IS "Pending">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Page">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-publish.cfm?URLPath=#PageOutput.Path#">
			</CFIF>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Page">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/contentpage-edit.cfm?ParentID=#qryContentPageInfo.DirectoryName#">
		</CFIF>
	<CFELSE>
		<CFINCLUDE TEMPLATE="page-query-notfound.cfm">
	</CFIF>
</CFIF>