<CFIF ListLen(Attributes.URLPath,"/") GT 1>
	<CFIF ListLen(Attributes.URLPath,"/") GT 2 AND ListFindNoCase("target,mission,category",ListGetAt(Attributes.URLPath,2,"/"))>
		<!--- Filtered gallery --->
		<CFSET PageOutput.Section = "galleries">
		<CFSET PageOutput.Title = "Galleries">
		<CFSET PageOutput.Path = Attributes.URLPath>
		<CFSET PageOutput.Content = "">
		
		<CFSET FilterType = ListGetAt(Attributes.URLPath,2,"/")>
		<CFSET FilterValue = ListGetAt(Attributes.URLPath,3,"/")>
		
		<CFIF FilterType IS "category" AND FilterValue IS "video">
			<!--- Video Gallery --->
			<CFQUERY NAME="qryListVideos" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
			SELECT *
			FROM sse3_videos
			WHERE Status = 'Active'
			ORDER BY VideoDate DESC, VideoID DESC
			</CFQUERY>
			
			<CFSET PageOutput.Gallery = ArrayNew(1)>
			<CFSET PrevVideoID = "">
			<CFLOOP QUERY="qryListVideos" STARTROW="#Attributes.Start#">
				<CFIF PrevVideoID IS NOT qryListVideos.VideoID AND FileExists(ExpandPath("../images/galleries/#qryListVideos.VideoThm#"))>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery) + 1] = StructNew()>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Title = qryListVideos.VideoTitle>
					<CFIF IsDate(qryListVideos.VideoDate)>
						<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Date = DateFormat(qryListVideos.VideoDate,"d mmm yyyy")>
					</CFIF>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Content = qryListVideos.MediumDesc>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Image = "images/galleries/#qryListVideos.VideoThm#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].URL = "galleries/video/#qryListVideos.URLPath#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].ID = qryListVideos.VideoID>
				</CFIF>
				<CFSET PrevVideoID = qryListVideos.VideoID>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Video">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/video-edit.cfm">
			</CFIF>
		<CFELSEIF FilterType IS "category" AND FilterValue IS "downloads">
			<!--- Downloads Gallery --->
			<CFQUERY NAME="qryListDownloads" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
			SELECT *
			FROM sse3_downloads
			WHERE Status = 'Active'
			ORDER BY DateCreated DESC, DownloadID DESC
			</CFQUERY>
			
			<CFSET PageOutput.Gallery = ArrayNew(1)>
			<CFSET PrevDownloadID = "">
			<CFLOOP QUERY="qryListDownloads" STARTROW="#Attributes.Start#">
				<CFIF PrevDownloadID IS NOT qryListDownloads.DownloadID AND FileExists(ExpandPath("../images/galleries/#qryListDownloads.DownloadImageThm#"))>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery) + 1] = StructNew()>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Title = qryListDownloads.DownloadTitle>
					<CFIF IsDate(qryListDownloads.DateCreated)>
						<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Date = DateFormat(qryListDownloads.DateCreated,"d mmm yyyy")>
					</CFIF>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Content = qryListDownloads.MediumDesc>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Image = "images/galleries/#qryListDownloads.DownloadImageThm#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].URL = "galleries/downloads/#qryListDownloads.URLPath#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].ID = qryListDownloads.DownloadID>
				</CFIF>
				<CFSET PrevDownloadID = qryListDownloads.DownloadID>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Download">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/download-edit.cfm">
			</CFIF>
		<CFELSEIF FilterType IS "category" AND FilterValue IS "interactive">
			<!--- Interactive Gallery --->
			<CFQUERY NAME="qryListInteractives" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
			SELECT *
			FROM sse3_interactives
			WHERE Status = 'Active'
			ORDER BY DateCreated DESC, InteractiveID DESC
			</CFQUERY>
			
			<CFSET PageOutput.Gallery = ArrayNew(1)>
			<CFSET PrevInteractiveID = "">
			<CFLOOP QUERY="qryListInteractives" STARTROW="#Attributes.Start#">
				<CFIF PrevInteractiveID IS NOT qryListInteractives.InteractiveID AND FileExists(ExpandPath("../images/galleries/#qryListInteractives.ImageThm#"))>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery) + 1] = StructNew()>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Title = qryListInteractives.InteractiveTitle>
					<CFIF IsDate(qryListInteractives.DateCreated)>
						<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Date = DateFormat(qryListInteractives.DateCreated,"d mmm yyyy")>
					</CFIF>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Content = qryListInteractives.InteractiveDesc>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Image = "images/galleries/#qryListInteractives.ImageThm#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].URL = qryListInteractives.Link1URL>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].ID = qryListInteractives.InteractiveID>
				</CFIF>
				<CFSET PrevInteractiveID = qryListInteractives.InteractiveID>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Interactive">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/interactive-edit.cfm">
			</CFIF>
		<CFELSE>
			<CFSWITCH EXPRESSION="#FilterType#">
				<CFCASE VALUE="target">
					<CFQUERY NAME="qryGalleryPlanetInfo" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_planets_moons
					WHERE LOWER(SearchName) = '#LCase(FilterValue)#'
					AND Status = 'Active'
					</CFQUERY>
					<CFIF qryGalleryPlanetInfo.RecordCount GT 0>
						<CFSET PageOutput.Title = "Galleries: #qryGalleryPlanetInfo.ObjectName#">
					</CFIF>
				</CFCASE>
				<CFCASE VALUE="mission">
					<CFQUERY NAME="qryGalleryMissionInfo" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_missions
					WHERE LOWER(MissionDirectory) = '#LCase(FilterValue)#'
					AND Status = 'Active'
					</CFQUERY>
					<CFIF qryGalleryMissionInfo.RecordCount GT 0>
						<CFSET PageOutput.Title = "Galleries: #Replace(qryGalleryMissionInfo.FullName," 0"," ","All")#">
					</CFIF>
				</CFCASE>
				<CFCASE VALUE="category">
					<CFQUERY NAME="qryGalleryCategoryInfo" DATASOURCE="#Application.DSN#">
					SELECT *
					FROM sse3_gallery_categories
					WHERE LOWER(SearchName) = '#LCase(FilterValue)#'
					AND Status = 'Active'
					</CFQUERY>
					<CFIF qryGalleryCategoryInfo.RecordCount GT 0>
						<CFSET PageOutput.Title = "Galleries: #qryGalleryCategoryInfo.DisplayName#">
					</CFIF>
				</CFCASE>
			</CFSWITCH>
			
			<CFQUERY NAME="qryListImages" DATASOURCE="#Application.DSN#" MAXROWS="#Attributes.Limit#">
			SELECT G.*
			FROM sse3_gallery G
				<CFSWITCH EXPRESSION="#FilterType#">
					<CFCASE VALUE="target">, sse3_galleryxplanets GXP</CFCASE>
					<CFCASE VALUE="mission">, sse3_galleryxmissions GXM</CFCASE>
					<CFCASE VALUE="category">, sse3_galleryxcategories GXC</CFCASE>
				</CFSWITCH>
			WHERE G.Status = 'Active'
				<CFSWITCH EXPRESSION="#FilterType#">
					<CFCASE VALUE="target">
						AND G.ImageID = GXP.ImageID AND <CFIF IsNumeric(qryGalleryPlanetInfo.PlanetID)>GXP.PlanetID = #qryGalleryPlanetInfo.PlanetID#<CFELSE>1 = 0</CFIF>
					</CFCASE>
					<CFCASE VALUE="mission">
						AND G.ImageID = GXM.ImageID AND <CFIF IsNumeric(qryGalleryMissionInfo.MissionID)>GXM.MissionID = #qryGalleryMissionInfo.MissionID#<CFELSE>1 = 0</CFIF>
					</CFCASE>
					<CFCASE VALUE="category">
						AND G.ImageID = GXC.ImageID AND <CFIF IsNumeric(qryGalleryCategoryInfo.CategoryID)>GXC.CategoryID = #qryGalleryCategoryInfo.CategoryID#<CFELSE>1 = 0</CFIF>
					</CFCASE>
				</CFSWITCH>
			ORDER BY G.ImageDate DESC, G.ImageID DESC
			</CFQUERY>
			
			<CFSET PageOutput.Gallery = ArrayNew(1)>
			<CFSET PrevImageID = "">
			<CFLOOP QUERY="qryListImages" STARTROW="#Attributes.Start#">
				<CFIF PrevImageID IS NOT qryListImages.ImageID AND FileExists(ExpandPath("../images/galleries/#qryListImages.ImageThm#"))>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery) + 1] = StructNew()>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Title = qryListImages.ImageTitle>
					<CFIF IsDate(qryListImages.ImageDate)>
						<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Date = DateFormat(qryListImages.ImageDate,"d mmm yyyy")>
					</CFIF>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Content = qryListImages.MediumDesc>
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].Image = "images/galleries/#qryListImages.ImageThm#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].URL = "galleries/#qryListImages.URLPath#">
					<CFSET PageOutput.Gallery[ArrayLen(PageOutput.Gallery)].ID = qryListImages.ImageID>
				</CFIF>
				<CFSET PrevImageID = qryListImages.ImageID>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Image">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-edit.cfm">
			</CFIF>
		</CFIF>
	<CFELSEIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "video">
		<!--- Single video --->
		<CFQUERY NAME="qryVideoInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_videos
		WHERE LOWER(URLPath) = '#LCase(ListGetAt(Attributes.URLPath,3,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFQUERY NAME="qryVideoPlanets" DATASOURCE="#Application.DSN#">
		SELECT PM.*
		FROM sse3_planets_moons PM, sse3_videosxplanets VXP
		WHERE PM.PlanetID = VXP.PlanetID
			AND <CFIF IsNumeric(qryVideoInfo.VideoID)>VXP.VideoID = #qryVideoInfo.VideoID#<CFELSE>1 = 0</CFIF>
			AND PM.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryVideoMissions" DATASOURCE="#Application.DSN#">
		SELECT M.*
		FROM sse3_missions M, sse3_videosxmissions VXM
		WHERE M.MissionID = VXM.MissionID
			AND <CFIF IsNumeric(qryVideoInfo.VideoID)>VXM.VideoID = #qryVideoInfo.VideoID#<CFELSE>1 = 0</CFIF>
			AND M.Status = 'Active'
		</CFQUERY>
		
		<CFIF qryVideoInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "galleries">
			<CFSET PageOutput.Title = "Galleries: Video: #qryVideoInfo.VideoTitle#">
			<CFSET PageOutput.Path = "galleries/video/#qryVideoInfo.URLPath#">
			<CFSET PageOutput.UpdateDate = DateFormat(qryVideoInfo.DateModified,"d mmmm yyyy")>
			<CFSET PageOutput.Source = qryVideoInfo.Source>
			<CFSET PageOutput.PubDate = DateFormat(qryVideoInfo.VideoDate,"d mmmm yyyy")>
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryVideoInfo.Caption#" 
				OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
			<CFSET PageOutput.Content = CEval(PageTextModified)>
			<CFIF FileExists(ExpandPath("../images/galleries/#qryVideoInfo.VideoImage#"))>
				<CFSET PageOutput.FeatureImage = "images/galleries/#qryVideoInfo.VideoImage#">
			</CFIF>
			<CFIF qryVideoInfo.VideoEmbed IS NOT "">
				<CFSET PageOutput.FeatureVideo = qryVideoInfo.VideoEmbed>
			</CFIF>
			<CFIF qryVideoInfo.MediumDesc IS NOT "">
				<CFSET PageOutput.FeatureCaption = qryVideoInfo.MediumDesc>
			</CFIF>
			
			<CFQUERY NAME="qryVideoFiles" DATASOURCE="#Application.DSN#">
			SELECT *
			FROM sse3_video_files
			WHERE VideoID = #qryVideoInfo.VideoID# AND Status = 'Active'
			ORDER BY FileOrder
			</CFQUERY>
			
			<CFQUERY NAME="qryVideoLinks" DATASOURCE="#Application.DSN#">
			SELECT *
			FROM sse3_video_links
			WHERE VideoID = #qryVideoInfo.VideoID# AND Status = 'Active'
			ORDER BY LinkOrder
			</CFQUERY>
			
			<CFSET PageOutput.Links = ArrayNew(1)>
			<CFLOOP QUERY="qryVideoFiles">
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = qryVideoFiles.FileTitle>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Content = qryVideoFiles.FileDesc>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "docs/video/#qryVideoFiles.FileName#">
			</CFLOOP>
			<CFLOOP QUERY="qryVideoLinks">
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = qryVideoLinks.LinkTitle>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Content = qryVideoLinks.LinkDesc>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = qryVideoLinks.LinkURL>
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks = ArrayNew(1)>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Video">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/video-edit.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Video">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/video-delete.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				<CFIF qryVideoInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Video">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/video-publish.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Video">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/video-edit.cfm">
			</CFIF>
		</CFIF>
	<CFELSEIF ListLen(Attributes.URLPath,"/") GT 2 AND ListGetAt(Attributes.URLPath,2,"/") IS "downloads">
		<!--- Single download --->
		<CFQUERY NAME="qryDownloadInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_downloads
		WHERE LOWER(URLPath) = '#LCase(ListGetAt(Attributes.URLPath,3,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFIF qryDownloadInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "galleries">
			<CFSET PageOutput.Title = "Galleries: Downloads: #qryDownloadInfo.DownloadTitle#">
			<CFSET PageOutput.Path = "galleries/downloads/#qryDownloadInfo.URLPath#">
			<CFSET PageOutput.UpdateDate = DateFormat(qryDownloadInfo.DateModified,"d mmmm yyyy")>
			<CFSET PageOutput.PubDate = DateFormat(qryDownloadInfo.DateCreated,"d mmmm yyyy")>
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryDownloadInfo.Caption#" 
				OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
			<CFSET PageOutput.Content = CEval(PageTextModified)>
			<CFIF FileExists(ExpandPath("../images/galleries/#qryDownloadInfo.DownloadImage#"))>
				<CFSET PageOutput.FeatureImage = "images/galleries/#qryDownloadInfo.DownloadImage#">
			</CFIF>
			<CFIF qryDownloadInfo.MediumDesc IS NOT "">
				<CFSET PageOutput.FeatureCaption = qryDownloadInfo.MediumDesc>
			</CFIF>
			
			<CFQUERY NAME="qryDownloadFiles" DATASOURCE="#Application.DSN#">
			SELECT *
			FROM sse3_download_files
			WHERE DownloadID = #qryDownloadInfo.DownloadID# AND Status = 'Active'
			ORDER BY FileOrder
			</CFQUERY>
			
			<CFSET PageOutput.Links = ArrayNew(1)>
			<CFLOOP QUERY="qryDownloadFiles">
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links) + 1] = StructNew()>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].Title = qryDownloadFiles.FileTitle>
				<CFSET PageOutput.Links[ArrayLen(PageOutput.Links)].URL = "docs/downloads/#qryDownloadFiles.FileName#">
			</CFLOOP>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks = ArrayNew(1)>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Download">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/download-edit.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Download">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/download-delete.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				<CFIF qryDownloadInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Download">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/download-publish.cfm?URLPath=#ListRest(ListRest(PageOutput.Path,"/"),"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Download">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/download-edit.cfm">
			</CFIF>
		</CFIF>
	<CFELSE>
		<!--- Single gallery image --->
		<CFQUERY NAME="qryImageInfo" DATASOURCE="#Application.DSN#">
		SELECT *
		FROM sse3_gallery
		WHERE LOWER(URLPath) = '#LCase(ListRest(Attributes.URLPath,"/"))#'
			AND <CFIF Request.ShowAdmin GT 0>Status != 'Deleted'<CFELSE>Status = 'Active'</CFIF>
		</CFQUERY>
		
		<CFQUERY NAME="qryImagePlanets" DATASOURCE="#Application.DSN#">
		SELECT PM.*
		FROM sse3_planets_moons PM, sse3_galleryxplanets GXP
		WHERE PM.PlanetID = GXP.PlanetID
			AND <CFIF IsNumeric(qryImageInfo.ImageID)>GXP.ImageID = #qryImageInfo.ImageID#<CFELSE>1 = 0</CFIF>
			AND PM.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryImageMissions" DATASOURCE="#Application.DSN#">
		SELECT M.*
		FROM sse3_missions M, sse3_galleryxmissions GXM
		WHERE M.MissionID = GXM.MissionID
			AND <CFIF IsNumeric(qryImageInfo.ImageID)>GXM.ImageID = #qryImageInfo.ImageID#<CFELSE>1 = 0</CFIF>
			AND M.Status = 'Active'
		</CFQUERY>
		
		<CFQUERY NAME="qryImageCategories" DATASOURCE="#Application.DSN#">
		SELECT GC.*
		FROM sse3_gallery_categories GC, sse3_galleryxcategories GXC
		WHERE GC.CategoryID = GXC.CategoryID
			AND <CFIF IsNumeric(qryImageInfo.ImageID)>GXC.ImageID = #qryImageInfo.ImageID#<CFELSE>1 = 0</CFIF>
			AND GC.Status = 'Active'
		</CFQUERY>
		
		<CFIF qryImageInfo.RecordCount GT 0>
			<CFSET PageOutput.Section = "galleries">
			<CFSET PageOutput.Title = qryImageInfo.ImageTitle>
			<CFSET PageOutput.Path = "galleries/#qryImageInfo.URLPath#">
			<CFSET PageOutput.UpdateDate = DateFormat(qryImageInfo.DateModified,"d mmmm yyyy")>
			<CFSET PageOutput.Source = qryImageInfo.Source>
			<CFSET PageOutput.PubDate = DateFormat(qryImageInfo.ImageDate,"d mmmm yyyy")>
			<CFMODULE TEMPLATE="../utilities/TextContentParse.cfm" TEXTCONTENT="#qryImageInfo.Caption#" 
				OUTPUT="PageTextModified" IMAGEOUTPUT="PageOutput.Images">
			<CFSET PageOutput.Content = CEval(PageTextModified)>
			<CFIF FileExists(ExpandPath("../images/galleries/#qryImageInfo.ImageFull#"))>
				<CFSET PageOutput.FeatureImage = "images/galleries/#qryImageInfo.ImageFull#">
			<CFELSEIF FileExists(ExpandPath("../images/galleries/#qryImageInfo.ImageBrowse#"))>
				<CFSET PageOutput.FeatureImage = "images/galleries/#qryImageInfo.ImageBrowse#">
			</CFIF>
			<CFIF qryImageInfo.MediumDesc IS NOT "">
				<CFSET PageOutput.FeatureCaption = qryImageInfo.MediumDesc>
			</CFIF>
			<CFSET PageOutput.DownloadURL = PageOutput.FeatureImage>
			<CFIF qryImageInfo.ImageURL IS NOT "">
				<CFSET PageOutput.MoreURL = qryImageInfo.ImageURL>
			</CFIF>
			
			<CFIF Request.ShowAdmin GT 0>
				<CFSET PageOutput.AdminLinks = ArrayNew(1)>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Edit This Image">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-edit.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Delete This Image">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-delete.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				<CFIF qryImageInfo.Status IS "Pending">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Publish This Image">
					<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-publish.cfm?URLPath=#ListRest(PageOutput.Path,"/")#">
				</CFIF>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Image">
				<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-edit.cfm">
			</CFIF>
		</CFIF>
	</CFIF>
<CFELSE>
	<CFSET PageOutput.Section = "galleries">
	<CFSET PageOutput.Title = "Galleries">
	<CFSET PageOutput.Path = Attributes.URLPath>
	<CFSET PageOutput.Content = "">
	
	<CFSET FeaturedCategoryList = "GreatShots,Historical,Video,Interactive">
	<CFSET FeaturedPlanetList = "Jupiter,Saturn,Mercury,Mars,Venus,Neptune,Uranus,Dwarf">
	<CFSET FeaturedMissionList = "Curiosity,Juno,Voyager2,Cassini">
	
	<CFQUERY NAME="qryListCategoryFilters" DATASOURCE="#Application.DSN#">
	SELECT CategoryID, SearchName, DisplayName, GalleryImage
	FROM sse3_gallery_categories
	WHERE Status = 'Active'
	ORDER BY DisplayName
	</CFQUERY>
	
	<CFSET t = QueryAddRow(qryListCategoryFilters)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"CategoryID",0,qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"SearchName","Video",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"DisplayName","Video",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"GalleryImage","galpic_video.png",qryListCategoryFilters.RecordCount)>
	<CFSET t = QueryAddRow(qryListCategoryFilters)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"CategoryID",0,qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"SearchName","Interactive",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"DisplayName","Interactive",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"GalleryImage","galpic_interactive.png",qryListCategoryFilters.RecordCount)>
	<CFSET t = QueryAddRow(qryListCategoryFilters)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"CategoryID",0,qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"SearchName","Downloads",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"DisplayName","Downloads",qryListCategoryFilters.RecordCount)>
	<CFSET t = QuerySetCell(qryListCategoryFilters,"GalleryImage","galpic_downloads.png",qryListCategoryFilters.RecordCount)>
	
	<CFSET t = QueryAddColumn(qryListCategoryFilters,"GalleryOrder",ArrayNew(1))>
	<CFLOOP QUERY="qryListCategoryFilters">
		<CFIF ListFindNoCase(FeaturedCategoryList,qryListCategoryFilters.SearchName)>
			<CFSET t = QuerySetCell(qryListCategoryFilters,"GalleryOrder",ListFindNoCase(FeaturedCategoryList,qryListCategoryFilters.SearchName),qryListCategoryFilters.CurrentRow)>
		<CFELSE>
			<CFSET t = QuerySetCell(qryListCategoryFilters,"GalleryOrder",(qryListCategoryFilters.CurrentRow + ListLen(FeaturedCategoryList)),qryListCategoryFilters.CurrentRow)>
		</CFIF>
	</CFLOOP>
	<CFQUERY NAME="qryListCategoryFilters" DBTYPE="Query">
	SELECT *
	FROM qryListCategoryFilters
	ORDER BY GalleryOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListPlanetFilterIDs" DATASOURCE="#Application.DSN#">
	SELECT DISTINCT(GXP.PlanetID) AS PlanetID
	FROM sse3_gallery G, sse3_galleryxplanets GXP
	WHERE G.Status = 'Active' AND G.ImageID = GXP.ImageID
	ORDER BY GXP.PlanetID
	</CFQUERY>
	
	<CFQUERY NAME="qryListPlanetFilters" DATASOURCE="#Application.DSN#">
	SELECT PlanetID, SearchName, ObjectName, ParentID, PlanetOrder, GalleryImage
	FROM sse3_planets_moons
	WHERE PlanetID IN (#ValueList(qryListPlanetFilterIDs.PlanetID)#)
		AND Status = 'Active'
	ORDER BY ParentID, PlanetOrder
	</CFQUERY>
	
	<!--- <CFMODULE TEMPLATE="../utilities/Make_Tree.cfm" QUERY="qryListPlanetFilters" RESULT="qryListPlanetFilters" UNIQUE="PlanetID" PARENT="ParentID"> --->
	
	<CFSET t = QueryAddColumn(qryListPlanetFilters,"GalleryOrder",ArrayNew(1))>
	<CFLOOP QUERY="qryListPlanetFilters">
		<CFIF ListFindNoCase(FeaturedPlanetList,qryListPlanetFilters.SearchName)>
			<CFSET t = QuerySetCell(qryListPlanetFilters,"GalleryOrder",ListFindNoCase(FeaturedPlanetList,qryListPlanetFilters.SearchName),qryListPlanetFilters.CurrentRow)>
		<CFELSE>
			<CFSET t = QuerySetCell(qryListPlanetFilters,"GalleryOrder",(qryListPlanetFilters.CurrentRow + ListLen(FeaturedPlanetList)),qryListPlanetFilters.CurrentRow)>
		</CFIF>
	</CFLOOP>
	<CFQUERY NAME="qryListPlanetFilters" DBTYPE="Query">
	SELECT *
	FROM qryListPlanetFilters
	ORDER BY GalleryOrder
	</CFQUERY>
	
	<CFQUERY NAME="qryListMissionFilterIDs" DATASOURCE="#Application.DSN#">
	SELECT DISTINCT(GXM.MissionID) AS MissionID
	FROM sse3_gallery G, sse3_galleryxmissions GXM
	WHERE G.Status = 'Active' AND G.ImageID = GXM.ImageID
	ORDER BY GXM.MissionID
	</CFQUERY>
	
	<CFQUERY NAME="qryListMissionFiltersNoFuture" DATASOURCE="#Application.DSN#">
	SELECT MissionID, MissionDirectory, FullName, GalleryImage
	FROM sse3_missions
	WHERE MissionID IN (#ValueList(qryListMissionFilterIDs.MissionID)#)
		AND StartDate IS NOT NULL AND StartDate <= #CreateODBCDate(Now())#
		AND Status = 'Active'
	ORDER BY StartDate DESC, LOWER(FullName)
	</CFQUERY>
	
	<CFQUERY NAME="qryListMissionFiltersFuture" DATASOURCE="#Application.DSN#">
	SELECT MissionID, MissionDirectory, FullName, GalleryImage
	FROM sse3_missions
	WHERE MissionID IN (#ValueList(qryListMissionFilterIDs.MissionID)#)
		AND StartDate > #CreateODBCDate(Now())#
		AND Status = 'Active'
	ORDER BY StartDate, LOWER(FullName)
	</CFQUERY>
	
	<CFMODULE TEMPLATE="../utilities/QueryConcatenate.cfm" QUERIES="qryListMissionFiltersNoFuture,qryListMissionFiltersFuture" OUTPUT="qryListMissionFilters">
	
	<CFSET t = QueryAddColumn(qryListMissionFilters,"GalleryOrder",ArrayNew(1))>
	<CFLOOP QUERY="qryListMissionFilters">
		<CFSET t = QuerySetCell(qryListMissionFilters,"FullName",Replace(qryListMissionFilters.FullName," 0"," ","All"),qryListMissionFilters.CurrentRow)>
		<CFIF ListFindNoCase(FeaturedMissionList,qryListMissionFilters.MissionDirectory)>
			<CFSET t = QuerySetCell(qryListMissionFilters,"GalleryOrder",ListFindNoCase(FeaturedMissionList,qryListMissionFilters.MissionDirectory),qryListMissionFilters.CurrentRow)>
		<CFELSE>
			<CFSET t = QuerySetCell(qryListMissionFilters,"GalleryOrder",(qryListMissionFilters.CurrentRow + ListLen(FeaturedMissionList)),qryListMissionFilters.CurrentRow)>
		</CFIF>
	</CFLOOP>
	<CFQUERY NAME="qryListMissionFilters" DBTYPE="Query">
	SELECT *
	FROM qryListMissionFilters
	ORDER BY GalleryOrder
	</CFQUERY>
	
	<CFSET PageOutput.CategoryGalleries = ArrayNew(1)>
	<CFLOOP QUERY="qryListCategoryFilters">
		<CFSET PageOutput.CategoryGalleries[ArrayLen(PageOutput.CategoryGalleries) + 1] = StructNew()>
		<CFSET PageOutput.CategoryGalleries[ArrayLen(PageOutput.CategoryGalleries)].Title = qryListCategoryFilters.DisplayName>
		<CFSET PageOutput.CategoryGalleries[ArrayLen(PageOutput.CategoryGalleries)].URL = "galleries/category/#LCase(qryListCategoryFilters.SearchName)#">
		<CFIF FileExists(ExpandPath("../images/galleries/#qryListCategoryFilters.GalleryImage#"))>
			<CFSET PageOutput.CategoryGalleries[ArrayLen(PageOutput.CategoryGalleries)].Image = "images/galleries/#qryListCategoryFilters.GalleryImage#">
		<CFELSE>
			<CFSET PageOutput.CategoryGalleries[ArrayLen(PageOutput.CategoryGalleries)].ImageFeed = "galleries/category/#LCase(qryListCategoryFilters.SearchName)#&Limit=1">
		</CFIF>
	</CFLOOP>
	
	<CFSET PageOutput.PlanetGalleries = ArrayNew(1)>
	<CFLOOP QUERY="qryListPlanetFilters">
		<CFSET PageOutput.PlanetGalleries[ArrayLen(PageOutput.PlanetGalleries) + 1] = StructNew()>
		<CFSET PageOutput.PlanetGalleries[ArrayLen(PageOutput.PlanetGalleries)].Title = qryListPlanetFilters.ObjectName>
		<CFSET PageOutput.PlanetGalleries[ArrayLen(PageOutput.PlanetGalleries)].URL = "galleries/target/#LCase(qryListPlanetFilters.SearchName)#">
		<CFIF FileExists(ExpandPath("../images/galleries/#qryListPlanetFilters.GalleryImage#"))>
			<CFSET PageOutput.PlanetGalleries[ArrayLen(PageOutput.PlanetGalleries)].Image = "images/galleries/#qryListPlanetFilters.GalleryImage#">
		<CFELSE>
			<CFSET PageOutput.PlanetGalleries[ArrayLen(PageOutput.PlanetGalleries)].ImageFeed = "galleries/target/#LCase(qryListPlanetFilters.SearchName)#&Limit=1">
		</CFIF>
	</CFLOOP>
	
	<CFSET PageOutput.MissionGalleries = ArrayNew(1)>
	<CFLOOP QUERY="qryListMissionFilters">
		<CFSET PageOutput.MissionGalleries[ArrayLen(PageOutput.MissionGalleries) + 1] = StructNew()>
		<CFSET PageOutput.MissionGalleries[ArrayLen(PageOutput.MissionGalleries)].Title = qryListMissionFilters.FullName>
		<CFSET PageOutput.MissionGalleries[ArrayLen(PageOutput.MissionGalleries)].URL = "galleries/mission/#LCase(qryListMissionFilters.MissionDirectory)#">
		<CFIF FileExists(ExpandPath("../images/galleries/#qryListMissionFilters.GalleryImage#"))>
			<CFSET PageOutput.MissionGalleries[ArrayLen(PageOutput.MissionGalleries)].Image = "images/galleries/#qryListMissionFilters.GalleryImage#">
		<CFELSE>
			<CFSET PageOutput.MissionGalleries[ArrayLen(PageOutput.MissionGalleries)].ImageFeed = "galleries/mission/#LCase(qryListMissionFilters.MissionDirectory)#&Limit=1">
		</CFIF>
	</CFLOOP>
	
	<CFIF Request.ShowAdmin GT 0>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks) + 1] = StructNew()>
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].Title = "Add New Image">
		<CFSET PageOutput.AdminLinks[ArrayLen(PageOutput.AdminLinks)].URL = "admin/gallery-edit.cfm">
	</CFIF>
</CFIF>