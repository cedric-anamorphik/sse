<CFIF ListLen(Attributes.URLPath,"/") GT 1 AND ListGetAt(Attributes.URLPath,2,"/") IS "lessons">
	<CFSET PageOutput.Section = "educ">
	<CFSET PageOutput.Title = "Education: Fast Lesson Finder">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFPARAM NAME="Attributes.Category" DEFAULT="">
	<CFPARAM NAME="Attributes.Grade" DEFAULT="">
	<CFPARAM NAME="Attributes.LessonLength" DEFAULT="">
	<CFPARAM NAME="Attributes.Target" DEFAULT="">
	<CFPARAM NAME="Attributes.Mission" DEFAULT="">
	<CFPARAM NAME="Attributes.Topic" DEFAULT="">
	<CFPARAM NAME="Attributes.TagDCI" DEFAULT="">
	<CFPARAM NAME="Attributes.TagPr" DEFAULT="">
	<CFPARAM NAME="Attributes.TagCCC" DEFAULT="">
	<CFPARAM NAME="Attributes.Keywords" DEFAULT="">

	<CFQUERY NAME="qryLessonBodyIDs" DATASOURCE="#Application.DSN#">
	SELECT DISTINCT(LXP.PlanetID) AS PlanetID
	FROM sse3_lessonsxplanets LXP, sse3_lessons L
		WHERE LXP.LessonID = L.LessonID AND L.Status = 'Active'
	ORDER BY LXP.PlanetID
	</CFQUERY>

	<CFQUERY NAME="qryListBodies" DATASOURCE="#Application.DSN#">
	SELECT PlanetID, SearchName, ObjectName, ParentID, PlanetOrder, BodyType
	FROM sse3_planets_moons
	WHERE Status = 'Active'
		AND <CFIF qryLessonBodyIDs.RecordCount GT 0>PlanetID IN (#ValueList(qryLessonBodyIDs.PlanetID)#)<CFELSE>1 = 0</CFIF>
	ORDER BY ParentID, PlanetOrder
	</CFQUERY>

	<CFMODULE TEMPLATE="../utilities/Make_Tree.cfm" QUERY="#qryListBodies#" UNIQUE="PlanetID" PARENT="ParentID" RESULT="qryListBodies">

	<CFQUERY NAME="qryLessonMissionIDs" DATASOURCE="#Application.DSN#">
	SELECT DISTINCT(LXM.MissionID) AS MissionID
	FROM sse3_lessonsxmissions LXM, sse3_lessons L
		WHERE LXM.LessonID = L.LessonID AND L.Status = 'Active'
	ORDER BY LXM.MissionID
	</CFQUERY>

	<CFQUERY NAME="qryListMissions" DATASOURCE="#Application.DSN#">
	SELECT MissionID, MissionDirectory, FullName, ShortName
	FROM sse3_missions
	WHERE Status = 'Active'
		AND <CFIF qryLessonMissionIDs.RecordCount GT 0>MissionID IN (#ValueList(qryLessonMissionIDs.MissionID)#)<CFELSE>1 = 0</CFIF>
	ORDER BY UPPER(FullName)
	</CFQUERY>

	<CFQUERY NAME="qryListTopics" DATASOURCE="#Application.DSN#">
	SELECT *
	FROM sse3_lessons_topics
	WHERE Status = 'Active'
	ORDER BY UPPER(TopicTitle)
	</CFQUERY>
	
	<CFSET PageOutput.FastLessonFinder = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Action = "educ/lessons">
	<CFSET PageOutput.FastLessonFinder.Fields = ArrayNew()>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Grade">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Grade Level">
	<CFSET FieldOptions = ArrayNew()>
	<CFSET FieldOptions[1] = StructNew()>
	<CFSET FieldOptions[1].Value = "k2">
	<CFSET FieldOptions[1].Text = "K-2">
	<CFSET FieldOptions[2] = StructNew()>
	<CFSET FieldOptions[2].Value = "35">
	<CFSET FieldOptions[2].Text = "3-5">
	<CFSET FieldOptions[3] = StructNew()>
	<CFSET FieldOptions[3].Value = "68">
	<CFSET FieldOptions[3].Text = "6-8">
	<CFSET FieldOptions[4] = StructNew()>
	<CFSET FieldOptions[4].Value = "912">
	<CFSET FieldOptions[4].Text = "9-12">
	<CFLOOP FROM="1" TO="#ArrayLen(FieldOptions)#" INDEX="f">
		<CFIF ListFindNoCase(Attributes.Grade,FieldOptions[f].Value)>
			<CFSET FieldOptions[f].Selected = 1>
		</CFIF>
	</CFLOOP>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "LessonLength">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Lesson Text">
	<CFSET FieldOptions = ArrayNew()>
	<CFSET FieldOptions[1] = StructNew()>
	<CFSET FieldOptions[1].Value = "Less Than 30 Minutes">
	<CFSET FieldOptions[1].Text = "Less Than 30 Minutes">
	<CFSET FieldOptions[2] = StructNew()>
	<CFSET FieldOptions[2].Value = "30-60 Minutes">
	<CFSET FieldOptions[2].Text = "30-60 Minutes">
	<CFSET FieldOptions[3] = StructNew()>
	<CFSET FieldOptions[3].Value = "More Than an Hour">
	<CFSET FieldOptions[3].Text = "More Than an Hour">
	<CFLOOP FROM="1" TO="#ArrayLen(FieldOptions)#" INDEX="f">
		<CFIF ListFindNoCase(Attributes.LessonLength,FieldOptions[f].Value)>
			<CFSET FieldOptions[f].Selected = 1>
		</CFIF>
	</CFLOOP>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Target">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Solar System Body">
	<CFSET FieldOptions = ArrayNew()>
	<CFLOOP QUERY="qryListBodies">
		<CFSET FieldOptions[ArrayLen(FieldOptions) + 1] = StructNew()>
		<CFSET FieldOptions[ArrayLen(FieldOptions)].Value = qryListBodies.SearchName>
		<CFSET FieldOptions[ArrayLen(FieldOptions)].Text = qryListBodies.ObjectName>
	</CFLOOP>
	<CFLOOP FROM="1" TO="#ArrayLen(FieldOptions)#" INDEX="f">
		<CFIF ListFindNoCase(Attributes.Target,FieldOptions[f].Value)>
			<CFSET FieldOptions[f].Selected = 1>
		</CFIF>
	</CFLOOP>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Mission">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Mission">
	<CFSET FieldOptions = ArrayNew()>
	<CFLOOP QUERY="qryListMissions">
		<CFSET FieldOptions[ArrayLen(FieldOptions) + 1] = StructNew()>
		<CFSET FieldOptions[ArrayLen(FieldOptions)].Value = qryListMissions.MissionDirectory>
		<CFSET FieldOptions[ArrayLen(FieldOptions)].Text = Replace(qryListMissions.FullName," 0"," ","All")>
	</CFLOOP>
	<CFLOOP FROM="1" TO="#ArrayLen(FieldOptions)#" INDEX="f">
		<CFIF ListFindNoCase(Attributes.Mission,FieldOptions[f].Value)>
			<CFSET FieldOptions[f].Selected = 1>
		</CFIF>
	</CFLOOP>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Topic">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Topic">
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Keywords">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "text">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Keywords">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Value = Attributes.Keywords>
	
	<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND IsNumeric(ListGetAt(Attributes.URLPath,3,"/"))>
		<CFSET Attributes.LessonID = ListGetAt(Attributes.URLPath,3,"/")>
		<!--- Specific Lesson --->
		<CFQUERY NAME="qryLessonInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_lessons
		WHERE LessonID = #Attributes.LessonID#
		</CFQUERY>
		
		<CFQUERY NAME="qryLessonTopics" DATASOURCE="#Application.DSN#">
		SELECT LXT.LessonID, LT.TopicID, LT.TopicTitle
		FROM sse3_lessonsxtopics LXT, sse3_lessons_topics LT
		WHERE LXT.TopicID = LT.TopicID
			AND LT.Status = 'Active'
			AND LXT.LessonID = #Attributes.LessonID#
		ORDER BY LXT.LessonID, UPPER(LT.TopicTitle)
		</CFQUERY>

		<CFQUERY NAME="qryLessonBodies" DATASOURCE="#Application.DSN#">
		SELECT LXP.LessonID, PM.PlanetID, PM.SearchName, PM.ObjectName, PM.ParentID, PM.PlanetOrder, PM.BodyType
		FROM sse3_lessonsxplanets LXP, sse3_planets_moons PM
		WHERE LXP.PlanetID = PM.PlanetID
			AND PM.Status = 'Active'
			AND LXP.LessonID = #Attributes.LessonID#
		ORDER BY LXP.LessonID, PM.ParentID, PM.PlanetOrder
		</CFQUERY>

		<CFQUERY NAME="qryLessonMissions" DATASOURCE="#Application.DSN#">
		SELECT LXM.LessonID, M.MissionID, M.MissionDirectory, M.FullName, M.ShortName, MXP.PlanetID
		FROM sse3_lessonsxmissions LXM, sse3_missions M, sse3_missionsxplanets MXP
		WHERE LXM.MissionID = M.MissionID
			AND M.Status = 'Active'
			AND M.MissionID = MXP.MissionID AND MXP.TargetType = 'Primary'
			AND LXM.LessonID = #Attributes.LessonID#
		ORDER BY LXM.LessonID, UPPER(M.FullName)
		</CFQUERY>
		
		<CFQUERY NAME="qryMissionDestinations" DATASOURCE="#Application.DSN#">
		SELECT PlanetID, SearchName, ObjectName
		FROM sse3_planets_moons
		WHERE <CFIF qryLessonMissions.RecordCount GT 0>PlanetID IN (#ValueList(qryLessonMissions.PlanetID)#)<CFELSE>1 = 0</CFIF>
		ORDER BY PlanetID
		</CFQUERY>
		
		<CFQUERY NAME="qryLessonTags" DATASOURCE="#Application.DSN#">
		SELECT LT.*
		FROM sse3_lessonsxtags LXT, sse3_lessons_tags LT
		WHERE LXT.LessonID = #Attributes.LessonID#
			AND LXT.TagID = LT.TagID AND LT.Status = 'Active'
		ORDER BY UPPER(LT.TagTitle)
		</CFQUERY>
		<CFQUERY NAME="qryLessonTagsDCI" DBTYPE="Query">
		SELECT *
		FROM qryLessonTags
		WHERE TagCategory = 'Disciplinary Core Ideas'
		</CFQUERY>
		<CFQUERY NAME="qryLessonTagsPr" DBTYPE="Query">
		SELECT *
		FROM qryLessonTags
		WHERE TagCategory = 'Practices'
		</CFQUERY>
		<CFQUERY NAME="qryLessonTagsCCC" DBTYPE="Query">
		SELECT *
		FROM qryLessonTags
		WHERE TagCategory = 'Crosscutting Concepts'
		</CFQUERY>
		
		<CFMODULE TEMPLATE="../utilities/bodycontent.cfm" OUTPUT="LessonContent">
			<CFOUTPUT>
			<P CLASS="subTitle">#qryLessonInfo.LessonTitle#</P>
			
			<CFSET DisplayGradeLevel = "">
			<CFIF qryLessonInfo.GradeK2 IS 1>
				<CFSET DisplayGradeLevel = ListAppend(DisplayGradeLevel,"K-2")>
			</CFIF>
			<CFIF qryLessonInfo.Grade35 IS 1>
				<CFSET DisplayGradeLevel = ListAppend(DisplayGradeLevel,"3-5")>
			</CFIF>
			<CFIF qryLessonInfo.Grade68 IS 1>
				<CFSET DisplayGradeLevel = ListAppend(DisplayGradeLevel,"6-8")>
			</CFIF>
			<CFIF qryLessonInfo.Grade912 IS 1>
				<CFSET DisplayGradeLevel = ListAppend(DisplayGradeLevel,"9-12")>
			</CFIF>
			
			<DIV><B>Grade Level:</B> #ListChangeDelims(DisplayGradeLevel,", ")#</DIV>
			
			<DIV><B>Lesson Time:</B> #qryLessonInfo.LessonLength#</DIV>
			
			<CFIF qryLessonBodies.RecordCount GT 0>
				<DIV><B>Body:</B>
				<CFLOOP QUERY="qryLessonBodies">
					<A HREF="#Request.PathLevel#planets/#qryLessonBodies.SearchName#">#qryLessonBodies.ObjectName#</A><CFIF qryLessonBodies.CurrentRow LT qryLessonBodies.RecordCount>, </CFIF>
				</CFLOOP></DIV>
			</CFIF>
			
			<CFIF qryLessonMissions.RecordCount GT 0>
				<DIV><B>Mission:</B>
				<CFLOOP QUERY="qryLessonMissions">
					<CFQUERY NAME="qryCurrentMissionDestination" DBTYPE="Query">
					SELECT *
					FROM qryMissionDestinations
					WHERE PlanetID = #qryLessonMissions.PlanetID#
					</CFQUERY>
					<A HREF="#Request.PathLevel#missions/#qryLessonMissions.MissionDirectory#">#Replace(qryLessonMissions.FullName," 0"," ","All")#</A><CFIF qryCurrentMissionDestination.RecordCount GT 0> (#qryCurrentMissionDestination.ObjectName#)</CFIF><CFIF qryLessonMissions.CurrentRow LT qryLessonMissions.RecordCount>, </CFIF>
				</CFLOOP></DIV>
			</CFIF>
			</P>
			
			<CFIF qryLessonInfo.FileName IS NOT "" AND FileExists(ExpandPath("#Request.PathLevel#docs/educ/#qryLessonInfo.FileName#"))>
				<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="[[LINK||FILE:docs/educ/#qryLessonInfo.FileName#||<B>Download This Lesson</B>]]" OUTPUT="DownloadTextTextModified">
				<P><A HREF="#Request.PathLevel#docs/educ/#qryLessonInfo.FileName#" TARGET="_blank">#DownloadTextTextModified#</A></P>
			<CFELSEIF qryLessonInfo.LessonURL IS NOT "">
				<P><A HREF="#qryLessonInfo.LessonURL#" TARGET="_blank"><B>Download This Lesson</B></A></P>
			</CFIF>
			
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="<B>Short Description:</B> #qryLessonInfo.Blurb#" OUTPUT="BlurbModified">
			
			<DIV>
			#BlurbModified#
			</DIV>
			
			<P><B>Why We Chose This Lesson</B><BR>
			This lesson was chosen for its quality and potential alignment to Next Generation Science Standards.</P>
			
			<CFIF qryLessonInfo.RubricFileName IS NOT "" AND FileExists(ExpandPath("#Request.PathLevel#docs/educ/#qryLessonInfo.RubricFileName#"))>
				<P><A HREF="#Request.PathLevel#docs/educ/#qryLessonInfo.RubricFileName#" TARGET="_blank">Read the Rubric for This Lesson</A></P>
			</CFIF>
			
			<CFIF qryLessonTagsDCI.RecordCount GT 0>
				<P><B>Disciplinary Core Ideas</B></P>
				
				<UL>
				<CFLOOP QUERY="qryLessonTagsDCI">
					<LI><CFIF qryLessonTagsDCI.TagURL IS NOT ""><A HREF="#qryLessonTagsDCI.TagURL#" TARGET="_blank"></CFIF>#qryLessonTagsDCI.TagTitle#<CFIF qryLessonTagsDCI.TagURL IS NOT ""></A></CFIF>
					<CFIF qryLessonTagsDCI.TagDescription IS NOT "">
						<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryLessonTagsDCI.TagDescription#" OUTPUT="TagDescriptionModified">
						#TagDescriptionModified#
					</CFIF>
					</LI>
				</CFLOOP>
				</UL>
				
				<P>Read more: <A HREF="http://www.nextgenscience.org/search-standards-dci" TARGET="_blank">NGSS Disciplinary Core Ideas</A></P>
			</CFIF>
			
			<CFIF qryLessonTagsPr.RecordCount GT 0>
				<P><B>Practices:</B></P>
				
				<UL>
				<CFLOOP QUERY="qryLessonTagsPr">
					<LI><CFIF qryLessonTagsPr.TagURL IS NOT ""><A HREF="#qryLessonTagsPr.TagURL#" TARGET="_blank"></CFIF>#qryLessonTagsPr.TagTitle#<CFIF qryLessonTagsPr.TagURL IS NOT ""></A></CFIF>
					<CFIF qryLessonTagsPr.TagDescription IS NOT "">
						<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryLessonTagsPr.TagDescription#" OUTPUT="TagDescriptionModified">
						#TagDescriptionModified#
					</CFIF>
					</LI>
				</CFLOOP>
				</UL>
				
				<P>Read more: <A HREF="http://www.nextgenscience.org/sites/ngss/files/Appendix%20F%20%20Science%20and%20Engineering%20Practices%20in%20the%20NGSS%20-%20FINAL%20060513.pdf" TARGET="_blank">Science and Engineering Practices in the NGSS</A></P>
			</CFIF>
			
			<CFIF qryLessonTagsCCC.RecordCount GT 0>
				<P><B>Crosscutting Concepts:</B></P>
				
				<UL>
				<CFLOOP QUERY="qryLessonTagsCCC">
					<LI><CFIF qryLessonTagsCCC.TagURL IS NOT ""><A HREF="#qryLessonTagsCCC.TagURL#" TARGET="_blank"></CFIF>#qryLessonTagsCCC.TagTitle#<CFIF qryLessonTagsCCC.TagURL IS NOT ""></A></CFIF>
					<CFIF qryLessonTagsCCC.TagDescription IS NOT "">
						<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryLessonTagsCCC.TagDescription#" OUTPUT="TagDescriptionModified">
						#TagDescriptionModified#
					</CFIF>
					</LI>
				</CFLOOP>
				</UL>
				
				<P>Read more: <A HREF="http://www.nextgenscience.org/sites/ngss/files/Appendix%20G%20-%20Crosscutting%20Concepts%20FINAL%20edited%204.10.13.pdf" TARGET="_blank">NGSS Crosscutting Concepts</A></P>
			</CFIF>
			
			<!--- <P><B>Category:</B> 
			<CFSWITCH EXPRESSION="#qryLessonInfo.Category#">
				<CFCASE VALUE="SpaceMath">Space Math</CFCASE>
				<CFCASE VALUE="Interactive">Interactive</CFCASE>
				<CFCASE VALUE="Cookbook">Solar System Cookbook</CFCASE>
				<CFDEFAULTCASE>None</CFDEFAULTCASE>
			</CFSWITCH>
			</P> --->
			
			<P><B>Credit:</B> <CFIF qryLessonInfo.SourceURL IS NOT ""><A HREF="<CFIF Find("://",qryLessonInfo.SourceURL) IS 0>#Request.PathLevel#</CFIF>#qryLessonInfo.SourceURL#" TARGET="_blank"></CFIF>#qryLessonInfo.Source#<CFIF qryLessonInfo.SourceURL IS NOT ""></A></CFIF></P>
			
			<HR>
			
			<CFIF FileExists(ExpandPath("../text/educ/lesson-#Attributes.LessonID#.txt"))>
				<CFFILE ACTION="Read" FILE="#ExpandPath("../text/educ/lesson-#Attributes.LessonID#.txt")#" VARIABLE="FullTextContent">
			<CFELSE>
				<CFSET FullTextContent = qryLessonInfo.FullText>
			</CFIF>
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#FullTextContent#" OUTPUT="FullTextModified">
			
			<DIV>
			#FullTextModified#
			</DIV>
			</CFOUTPUT>
		</CFMODULE>
		
		<CFSET PageOutput.Content = Request.LessonContent>
		
		<CFIF Request.ShowAdmin GT 0>
			<CFSET PageOutput.AdminLinks = ArrayNew(1)>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Lesson">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/lesson-edit.cfm?LessonID=#Attributes.LessonID#">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Lesson">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/lesson-delete.cfm?LessonID=#Attributes.LessonID#">
			<CFIF qryLessonInfo.Status IS "Pending">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Lesson">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/lesson-publish.cfm?LessonID=#Attributes.LessonID#">
			</CFIF>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Lesson">
			<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/lesson-edit.cfm">
		</CFIF>
	<CFELSE>
		<!--- List of Lessons --->
		<CFINCLUDE TEMPLATE="../utilities/CompoundEvaluation.cfm">

		<CFQUERY NAME="qryLessonIDs" DATASOURCE="#Application.DSN#">
		SELECT DISTINCT(L.LessonID) AS LessonID
		FROM sse3_lessons L
			<CFIF Attributes.Topic IS NOT "" OR (Attributes.Keywords IS NOT "" AND Attributes.Keywords IS NOT "Keywords")>, sse3_lessonsxtopics LXT, sse3_lessons_topics LT</CFIF>
			<CFIF Attributes.Target IS NOT "">, sse3_lessonsxplanets LXP, sse3_planets_moons PM</CFIF>
			<CFIF Attributes.Mission IS NOT "">, sse3_lessonsxmissions LXM, sse3_missions M</CFIF>
			<CFIF IsNumeric(Attributes.TagDCI) OR IsNumeric(Attributes.TagPR) OR IsNumeric(Attributes.TagCCC)>, sse3_lessonsxtags LXTA, sse3_lessons_tags LTA</CFIF>
		WHERE L.Status = 'Active'
			<CFIF Attributes.Grade IS NOT "">
				AND (1 = 0
					<CFIF ListFindNoCase(Attributes.Grade,"K2")>OR L.GradeK2 = 1</CFIF>
					<CFIF ListFindNoCase(Attributes.Grade,"35")>OR L.Grade35 = 1</CFIF>
					<CFIF ListFindNoCase(Attributes.Grade,"68")>OR L.Grade68 = 1</CFIF>
					<CFIF ListFindNoCase(Attributes.Grade,"912")>OR L.Grade912 = 1</CFIF>
				)
			</CFIF>
			<CFIF Attributes.LessonLength IS NOT "">
				AND LessonLength = '#Attributes.LessonLength#'
			</CFIF>
			<CFIF Attributes.Topic IS NOT "">
				AND L.LessonID = LXT.LessonID AND LXT.TopicID = LT.TopicID AND LT.TopicTitle = '#URLDecode(Attributes.Topic)#' AND LT.Status = 'Active'
			</CFIF>
			<CFIF Attributes.Target IS NOT "">
				AND L.LessonID = LXP.LessonID AND LXP.PlanetID = PM.PlanetID AND PM.SearchName = '#Attributes.Target#' AND PM.Status = 'Active'
			</CFIF>
			<CFIF Attributes.Mission IS NOT "">
				AND L.LessonID = LXM.LessonID AND LXM.MissionID = M.MissionID AND M.MissionDirectory = '#Attributes.Mission#' AND M.Status = 'Active'
			</CFIF>
			<CFIF IsNumeric(Attributes.TagDCI) OR IsNumeric(Attributes.TagPR) OR IsNumeric(Attributes.TagCCC)>
				AND L.LessonID = LXTA.LessonID AND LXTA.TagID = LTA.TagID AND (
					1 = 0
					<CFIF IsNumeric(Attributes.TagDCI)>OR LTA.TagID = #Attributes.TagDCI#</CFIF>
					<CFIF IsNumeric(Attributes.TagPR)>OR LTA.TagID = #Attributes.TagPR#</CFIF>
					<CFIF IsNumeric(Attributes.TagCCC)>OR LTA.TagID = #Attributes.TagCCC#</CFIF>
				)
				AND LTA.Status = 'Active'
			</CFIF>
			<CFIF Attributes.Keywords IS NOT "" AND Attributes.Keywords IS NOT "Keywords">
				AND (
					LOWER(L.LessonTitle) LIKE '%#LCase(Attributes.Keywords)#%' OR 
					LOWER(L.Blurb) LIKE '%#LCase(Attributes.Keywords)#%' OR 
					(L.LessonID = LXT.LessonID AND LXT.TopicID = LT.TopicID AND LOWER(LT.TopicTitle) LIKE '%#LCase(Attributes.Keywords)#%')
				)
			</CFIF>
			<CFIF Attributes.Category IS NOT "">
				AND Category = '#Attributes.Category#'
			</CFIF>
		ORDER BY L.LessonID
		</CFQUERY>

		<CFQUERY NAME="qryListLessons" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_lessons
		WHERE <CFIF qryLessonIDs.RecordCount GT 0>LessonID IN (#ValueList(qryLessonIDs.LessonID)#)<CFELSE>1 = 0</CFIF>
		ORDER BY UPPER(LessonTitle)
		</CFQUERY>

		<CFQUERY NAME="qryListLessonTopics" DATASOURCE="#Application.DSN#">
		SELECT LXT.LessonID, LT.TopicID, LT.TopicTitle
		FROM sse3_lessonsxtopics LXT, sse3_lessons_topics LT
		WHERE LXT.TopicID = LT.TopicID
			AND LT.Status = 'Active'
			AND <CFIF qryLessonIDs.RecordCount GT 0>LXT.LessonID IN (#ValueList(qryLessonIDs.LessonID)#)<CFELSE>1 = 0</CFIF>
		ORDER BY LXT.LessonID, UPPER(LT.TopicTitle)
		</CFQUERY>

		<CFQUERY NAME="qryListLessonBodies" DATASOURCE="#Application.DSN#">
		SELECT LXP.LessonID, PM.PlanetID, PM.SearchName, PM.ObjectName, PM.ParentID, PM.PlanetOrder, PM.BodyType
		FROM sse3_lessonsxplanets LXP, sse3_planets_moons PM
		WHERE LXP.PlanetID = PM.PlanetID
			AND PM.Status = 'Active'
			AND <CFIF qryLessonIDs.RecordCount GT 0>LXP.LessonID IN (#ValueList(qryLessonIDs.LessonID)#)<CFELSE>1 = 0</CFIF>
		ORDER BY LXP.LessonID, PM.ParentID, PM.PlanetOrder
		</CFQUERY>

		<CFQUERY NAME="qryListLessonMissions" DATASOURCE="#Application.DSN#">
		SELECT LXM.LessonID, M.MissionID, M.MissionDirectory, M.FullName, M.ShortName, MXP.PlanetID
		FROM sse3_lessonsxmissions LXM, sse3_missions M, sse3_missionsxplanets MXP
		WHERE LXM.MissionID = M.MissionID
			AND M.Status = 'Active'
			AND M.MissionID = MXP.MissionID AND MXP.TargetType = 'Primary'
			AND <CFIF qryLessonIDs.RecordCount GT 0>LXM.LessonID IN (#ValueList(qryLessonIDs.LessonID)#)<CFELSE>1 = 0</CFIF>
		ORDER BY LXM.LessonID, UPPER(M.FullName)
		</CFQUERY>
		
		<CFSET PageOutput.FastLessonFinder.Lessons = ArrayNew(1)>
		
		<CFLOOP QUERY="qryListLessons">
			<CFQUERY NAME="qryCurrentLessonTopics" DBTYPE="Query">
			SELECT *
			FROM qryListLessonTopics
			WHERE LessonID = #qryListLessons.LessonID#
			</CFQUERY>
			
			<CFSET TopicsList = "">
			<CFLOOP QUERY="qryCurrentLessonTopics">
				<CFSET TopicsList = ListAppend(TopicsList,"<A HREF=""#Request.PathLevel#educ/lessons/?Topic=#URLEncodedFormat(qryCurrentLessonTopics.TopicTitle)#"">#qryCurrentLessonTopics.TopicTitle#</A>")>
			</CFLOOP>
			
			<CFSET GradesList = "">
			<CFIF qryListLessons.GradeK2 IS 1>
				<CFSET GradesList = ListAppend(GradesList,"K-2")>
			</CFIF>
			<CFIF qryListLessons.Grade35 IS 1>
				<CFSET GradesList = ListAppend(GradesList,"3-5")>
			</CFIF>
			<CFIF qryListLessons.Grade68 IS 1>
				<CFSET GradesList = ListAppend(GradesList,"6-8")>
			</CFIF>
			<CFIF qryListLessons.Grade912 IS 1>
				<CFSET GradesList = ListAppend(GradesList,"9-12")>
			</CFIF>
			
			<CFQUERY NAME="qryCurrentLessonBodies" DBTYPE="Query">
			SELECT *
			FROM qryListLessonBodies
			WHERE LessonID = #qryListLessons.LessonID#
			</CFQUERY>
			
			<CFSET BodiesList = "">
			<CFLOOP QUERY="qryCurrentLessonBodies">
				<CFSET BodiesList = ListAppend(BodiesList,"<A HREF=""#Request.PathLevel#planets/#qryCurrentLessonBodies.SearchName#"" TARGET=""_blank"">#qryCurrentLessonBodies.ObjectName#</A>")>
			</CFLOOP>
			
			<CFQUERY NAME="qryCurrentLessonMissions" DBTYPE="Query">
			SELECT *
			FROM qryListLessonMissions
			WHERE LessonID = #qryListLessons.LessonID#
			</CFQUERY>
			
			<CFQUERY NAME="qryMissionDestinations" DATASOURCE="#Application.DSN#">
			SELECT PlanetID, SearchName, ObjectName
			FROM sse3_planets_moons
			WHERE <CFIF qryCurrentLessonMissions.RecordCount GT 0>PlanetID IN (#ValueList(qryCurrentLessonMissions.PlanetID)#)<CFELSE>1 = 0</CFIF>
			ORDER BY PlanetID
			</CFQUERY>
			
			<CFSET MissionsList = "">
			<CFLOOP QUERY="qryCurrentLessonMissions">
				<CFQUERY NAME="qryCurrentMissionDestination" DBTYPE="Query">
				SELECT *
				FROM qryMissionDestinations
				WHERE PlanetID = #qryCurrentLessonMissions.PlanetID#
				</CFQUERY>
				<CFIF qryCurrentMissionDestination.RecordCount GT 0>
					<CFSET MissionsList = ListAppend(MissionsList,"<A HREF=""#Request.PathLevel#missions/#qryCurrentLessonMissions.MissionDirectory#"" TARGET=""_blank"">#qryCurrentLessonMissions.ShortName#</A> (#qryCurrentMissionDestination.ObjectName#)")>
				<CFELSE>
					<CFSET MissionsList = ListAppend(MissionsList,"<A HREF=""#Request.PathLevel#missions/#qryCurrentLessonMissions.MissionDirectory#"" TARGET=""_blank"">#qryCurrentLessonMissions.ShortName#</A>")>
				</CFIF>
			</CFLOOP>
			
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons) + 1] = StructNew()>
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Title = qryListLessons.LessonTitle>
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].URL = "educ/lessons/#qryListLessons.LessonID#">
			<!--- <CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Topic = ListChangeDelims(TopicsList,", ")> --->
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Grade = ListChangeDelims(GradesList,", ")>
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Time = qryListLessons.LessonLength>
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Target = ListChangeDelims(BodiesList,", ")>
			<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Mission = ListChangeDelims(MissionsList,", ")>
			<CFIF qryListLessons.Blurb IS NOT "">
				<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryListLessons.Blurb#" OUTPUT="BlurbModified" FORCETARGET="_blank">
				<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Description = CEval(BlurbModified)>
			<CFELSE>
				<CFSET PageOutput.FastLessonFinder.Lessons[ArrayLen(PageOutput.FastLessonFinder.Lessons)].Description = "">
			</CFIF>
		</CFLOOP>
	</CFIF>
<CFELSEIF ListLen(Attributes.URLPath,"/") IS 1>
	<!--- Education Landing Page --->
	<CFSET PageOutput.Section = "educ">
	<CFSET PageOutput.Title = "Education">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFSET PageOutput.FastLessonFinder = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Action = "educ/lessons">
	<CFSET PageOutput.FastLessonFinder.Fields = ArrayNew()>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "Grade">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Grade Level">
	<CFSET FieldOptions = ArrayNew()>
	<CFSET FieldOptions[1] = StructNew()>
	<CFSET FieldOptions[1].Value = "k2">
	<CFSET FieldOptions[1].Text = "K-2">
	<CFSET FieldOptions[2] = StructNew()>
	<CFSET FieldOptions[2].Value = "35">
	<CFSET FieldOptions[2].Text = "3-5">
	<CFSET FieldOptions[3] = StructNew()>
	<CFSET FieldOptions[3].Value = "68">
	<CFSET FieldOptions[3].Text = "6-8">
	<CFSET FieldOptions[4] = StructNew()>
	<CFSET FieldOptions[4].Value = "912">
	<CFSET FieldOptions[4].Text = "9-12">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields) + 1] = StructNew()>
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Name = "LessonLength">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Type = "select">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Label = "Lesson Time">
	<CFSET FieldOptions = ArrayNew()>
	<CFSET FieldOptions[1] = StructNew()>
	<CFSET FieldOptions[1].Value = "Less Than 30 Minutes">
	<CFSET FieldOptions[1].Text = "Less Than 30 Minutes">
	<CFSET FieldOptions[2] = StructNew()>
	<CFSET FieldOptions[2].Value = "30-60 Minutes">
	<CFSET FieldOptions[2].Text = "30-60 Minutes">
	<CFSET FieldOptions[3] = StructNew()>
	<CFSET FieldOptions[3].Value = "More Than an Hour">
	<CFSET FieldOptions[3].Text = "More Than an Hour">
	<CFSET PageOutput.FastLessonFinder.Fields[ArrayLen(PageOutput.FastLessonFinder.Fields)].Options = FieldOptions>
	
	<CFSET PageOutput.Links = ArrayNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Space Math">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "educ/lessons?Category=SpaceMath">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Interactives">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "educ/lessons?Category=Interactive">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Images">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "galleries/">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = "Handouts">
	<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "educ/lithos">
</CFIF>