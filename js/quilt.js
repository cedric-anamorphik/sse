$standardId=1,
$myxml=0,
$gradeid=0;

//MD: Build the standards selection list
buildS();
			
function buildS(){
	$.ajax({
		type: "GET",
		url: "feeds/qid_"+$standardId+".xml",
		dataType: "xml",
		success: function(xml){
			$myxml=xml;
			
			$(xml).find('standard').each(function(){
				$standard=$(this).text(),
				$qid=$(this).attr("qid");
				$('<option value="'+$qid+'">'+$standard+'</option>').appendTo('#standard-select');
				
				//MD:MOBILE: Build standards list
				$('<li id="'+$qid+'"><a href="javascript:load_mobileData('+$qid+');" data-theme="b" class="ui-nodisc-icon ui-btn ui-btn-icon-right ui-icon-carat-r" data-rel="close"><p>'+$standard+'</p></a></li>').appendTo('#standards-list');
				
			});
			
			//MD: Build the quilt
			$xmlr = $('#standard-select option:first-child').attr("value");
			
			buildQ();
		}
	});
}

//MD: Build the quilt based on a new subject selected
$('#standard-select').change(function(){
	$xmlr=$('#standard-select option:selected').attr("value");
	$('#quilt_topics tbody tr').remove();
	$('#quilt_window tbody tr').remove();
	$('<tr class="topictabs" id="topic-list"><td id="grades"></td></tr>').appendTo('#quilt_topics tbody');
	$('<tr class="cattabs" id="categories"></tr>').appendTo('#quilt_window tbody');
	$standardId=0;
	buildQ();
});

//MD: Build the quilt 
function buildQ(){
		
	//MD: Add category cells
	$($myxml).find('cattabs > tab').each(function(){
		$tab=$(this).text(),
		$ltr=$(this).attr("cname");
		$('<td class="ctab" id="'+$ltr+'"><div class="tabTop">'+$ltr+'</div><div class="tabBottom">'+$tab+'</div></td>').appendTo('#quilt-body #categories');
	});
	
	$($myxml).find('topics > topic').each(function(){
		$title=$(this).text(),
		$key=$(this).attr("tnameroman"),
		$id=$(this).attr("tid"),
		$categories=$($myxml).find('cattabs > tab'),
		$catLen=$categories.length;
		
		//MD: Add topic rows and first (topic's title) cell
		$('<tr id="'+$id+'"></tr>').appendTo('#quilt-body tbody');
		$('<tr class="topic-row" id="'+$id+'"><td class="trow"><div class="roman-num">'+$key+'</div><div class="title-cell">'+$title+'</div></td></tr>').appendTo('#topic_column tbody');
		
		//MD:MOBILE: Add topic list
		// $('<li id="'+$id+'"><a href="#" data-theme="b" class="ui-nodisc-icon ui-btn ui-btn-icon-right ui-icon-carat-r" data-rel="close">'+$title+'<span class="ui-li-count">'+$catLen+' categories</span></a><br /></li>').appendTo('#standards-list');
	});
	
	//MD:Build category/activity cells
	buildC();
	
	function buildC(){
		$g=0,
		$t=0,
		$gradeLevel=$($myxml).find('grades > grade')[$gradeid],
		$topicLevel=$($gradeLevel).find('topic')[$g],
		$catLen=$($topicLevel).find('category').length,
		$topicLen=$($gradeLevel).find('topic').length;
		
		while($t<$topicLen){
			createCells($g);
			$t++;
			$g++;
		}
		
		function createCells($g){
			$($topicLevel).find('category').each(function(){
				$cstat=$(this).attr("enabled"),
				$cact=$(this).find('activity'),
				$chead=$(this).find('header').text(),
				$ccont=$(this).find('content').text(),
				$cid=$(this).attr("cid"),
				$catLetter=String.fromCharCode(parseInt($cid)+65);				
				
				//MD: Append new cells to each topic row
				if ($cstat!=1){
					$('<td class="cat" id="'+$catLetter+'" ></td>').appendTo('#quilt-body tr#'+$g);
				} else {
					$('<td class="acat" id="'+$catLetter+'"></td>').appendTo('#quilt-body tr#'+$g);
				}
			});
		}
		
	}
	
	//MD: Grade selector
	$('<table class="g-selector"><tr><td class="gtl gl" id="0">Pre 1-2</td><td class="gtr gl" id="1">3-5</td></tr><tr><td class="gbl gl" id="2">6-8</td><td class="gbr gl" id="3">9-12</td></tr></table>').appendTo('#grades');
	
	//MD: Build the quilt based on a new grade selected
	if($('table.g-selector tbody tr td.gl')){
		$('table.g-selector').on('click','td.gl', function() {
			$xmlr=$('#standard-select option:selected').attr("value")+"_"+$(this).attr("id");
			$gradeid=$(this).attr("id");
			$('#quilt_topics tbody tr').remove();
			$('#quilt_window tbody tr').remove();
			$('<tr class="topictabs" id="topic-list"><td id="grades"></td></tr>').appendTo('#quilt_topics tbody');
			$('<tr class="cattabs" id="categories"></tr>').appendTo('#quilt_window tbody');
			buildQ();
		});
	};
	
	//MD: Sectional dimensional and positional settings at load
	setDimensions();
	
	
	//MD: Highlight currently selected/displayed grade
	$('td.gl#'+$gradeid).css({backgroundColor:"#392f48", color:"#fff", fontWeight:"bold"});
	
	//MD: Feeds fades in
	$('#standard-select').fadeIn("slow");
	
	//MD: Quilt fades in
	$('#quilt-body').fadeIn("slow");
	
	//MD: Activity section fades in
	$('#information').fadeIn("slow");
}; //MD: End of buildQ

//MD: Setting dimensions
function setDimensions(){
	$offset=$('#activities').width()+6,
	$infowin=$('#information').width(),
	$qlen=$('#quilt-body').width()+131,
	$qhei=$('#quilt-body').height()+20,
	$infoTop=$qhei+142,
	$sum=$infowin-$offset-3;
	$('#summary').width($sum);
	$('#details').width($sum);
	$('#quilt_window').css("max-width", $qlen);
	$('#quilt_window').css("height", $qhei);
	$('#information').css("top", $infoTop);
}

//MD: Highlight categories and topics
$(document).ready(function () {
	//MD: Hide quilt elements while loading
	$('#standard-select').hide();
	$('#quilt-body').hide();
	$('#information').hide();
	
	loadBanner();
	
	//MD: Handle selection of categories
	if($('#quilt-body td.cat')){
		$('#quilt-body').delegate('td.acat, td.selcat, .trow:first', 'mouseover mouseleave', function (e) {
			if (e.type == 'mouseover') {
				$('tr#categories td.actab').not('tr#categories td#'+$(this).attr("id")).removeClass("actab").addClass("ctab");
				$('#'+$(this).attr("id")).removeClass("ctab").addClass("actab");
				//MD: Highlight topic
				$('tr.topic-row#'+$(this).parent().attr("id")+' div.title-cell').removeClass("title-cell").addClass("atitle-cell");
				$('tr.topic-row div[1]').not('tr.topic-row#'+$(this).parent().attr("id")+' div[1]').removeClass("atitle-cell").addClass("title-cell");
				$('tr.topic-row#'+$(this).parent().attr("id")+' td:first-child').removeClass("trow").addClass("atrow"); 
				$('tr.topic-row td:first-child').not('tr.topic-row#'+$(this).parent().attr("id")+' td:first-child').removeClass("atrow").addClass("trow");
			} else {
				//MD: Highlight category
				$('tr#categories td.actab').not('tr#categories td#'+$(this).attr("id")).removeClass("actab").addClass("ctab");
				$('#'+$(this).attr("id")).removeClass("actab").addClass("ctab");
				//MD: Highlight topic
				$('tr.topic-row#'+$(this).parent().attr("id")+' div.atitle-cell').removeClass("atitle-cell").addClass("title-cell");
				$('tr.topic-row div[1]').not('tr.topic-row#'+$(this).parent().attr("id")+' div[1]').removeClass("atitle-cell").addClass("title-cell");
				$('tr.topic-row#'+$(this).parent().attr("id")+' td:first-child').removeClass("atrow").addClass("trow");
				$('tr.topic-row td:first-child').not('tr.topic-row#'+$(this).parent().attr("id")+' td:first-child').removeClass("atrow").addClass("trow");
			}
		});
		//MD: Highlight selected category cell
		$('#quilt-body').delegate('td.acat', 'click', function () {
			//MD: Clean up old selections and highlight current activity selected
			$('tr#categories td.actab').not('tr#categories td#'+$(this).attr("id")).removeClass("actab");
			$oldCat=$("#quilt-body").find('td.selcat');
			$oldCat.removeClass("selcat").addClass("acat");
			$(this).removeClass("acat").addClass("selcat");
			
			//MD: Load activities
			$h=0,
			$tid=$(this).parent().attr("id"),
			$catid=($(this).attr("id").charCodeAt())-65,
			$currGrade=$($myxml).find('grade')[$standardId],
			$specTop=$($currGrade).find('topic')[$tid],
			$specCat=$($specTop).find('category')[$catid],
			$hLength=$($specCat).find('header').length,
			$('.category-subhead').attr("id", $catid);
			
			//MD: Clear any old content if there is some
			$('#info, #sum-cont').empty();
			
			//MD: Load first activity summary
			loadFSum();
			
			function loadFSum(){
				$first_hdr=$($specCat).find('header')[0],
				$fhdr=$($first_hdr).text(),
				$first_cont=$($specCat).find('content')[0],
				$fcont=$($first_cont).text(),
				$first_link=$($specCat).find('link')[0],
				$flink=$($first_link).text(),
				$first_subhd=$($specCat).find('subhead')[0],
				$fsubh=$($first_subhd).text(),
				$first_altloc=$($specCat).find('altloctext')[0];
				$faltloc=$($first_altloc).text();
				$('#sum-cont').append('<span id="txt-hdr">'+$fhdr+'</span><br>');
				$('#sum-cont').append('<span id="txt-cont">'+$fcont+'</span><br><br>');
				$('#sum-cont').append('<span id="txt-link"><a href="'+$flink+'" target="_blank">Click to go to activity site</a></span><br><br>');
				$('#sum-cont').append('<span id="txt-subhd">'+$fsubh+'</span><br>');
				$('#sum-cont').append('<span id="txt-altloc">'+$faltloc+'</span>');
			}
			
			//MD: Activities that are accidentally enabled
			function activitiesNoLongerExist(){
				$('#sum-cont').hide();
				$('#sum-cont').empty();
				$('#sum-cont span').empty();
				$('#sum-cont').append('<span id="txt-hdr">These activities have been removed for now, please come back again and hopefully we may have new activities listed</span><br>');
			}
			
			//MD: Generate activity headers
			for(i=0;i<$hLength;i++){
				$aheader=$($specCat).find('header')[$h],
				$hdr=$($aheader).text();
				if($hLength==1){
					$('<div id="'+$tid+'" class="hdr-sel"><div class="hdr-cell"><p class="cell-text">'+$hdr+'</p></div><div class="arrow-sel"><img src="images/arrow.png"></img></div></div>').appendTo('#info');
					$('div.hdr-sel').children(".hdr-cell").css("background-color", "#f4ba3d")
					$('div.hdr-sel').children(".arrow-sel").css("background-color", "#f4ba3d").css("opacity", "1");
					
					//MD: Set header height
					$cellC=$('#info>div#'+$tid+'>div.hdr-cell')[$h],
					$tcellC=$('#info>div#'+$tid+'>div.temp-cell')[0],
					$arrowC=$('#info>div#'+$tid+'>div.arrow-cont')[$h],
					$arrowS=$('#info>div#'+$tid+'>div.arrow-sel')[$h],
					$cellHeight=$($cellC).height(),
					$tcellHeight=$($tcellC).height(),
					$cellP=$($cellC).parent(),
					$tcellP=$($tcellC).parent();
					$($tcellP).css("height", $tcellHeight);
					$($cellP).css("height", $cellHeight);
					$($arrowC).css("height", $cellHeight);
					$($arrowS).css("height", $cellHeight);
				} else if($hLength>1){
					$('<div id="'+$tid+'" class="hdr-cont"><div class="hdr-cell"><p class="cell-text">'+$hdr+'</p></div><div class="arrow-cont"><img src="images/arrow.png"></img></div></div>').appendTo('#info');
					
					//MD: Set header height
					$cellC=$('#info>div#'+$tid+'>div.hdr-cell')[$h],
					$tcellC=$('#info>div#'+$tid+'>div.temp-cell')[0],
					$arrowC=$('#info>div#'+$tid+'>div.arrow-cont')[$h],
					$arrowS=$('#info>div#'+$tid+'>div.arrow-sel')[$h],
					$cellHeight=$($cellC).height(),
					$tcellHeight=$($tcellC).height(),
					$cellP=$($cellC).parent(),
					$tcellP=$($tcellC).parent(),
					$($tcellP).css("height", $tcellHeight);
					$($cellP).css("height", $cellHeight);
					$($arrowC).css("height", $cellHeight);
					$($arrowC).css("height", $cellHeight);
				}
				$h++;
			};
			
			//MD: Set focus on first activity in the list
			$('#info div.hdr-cont:first-child').removeClass("hdr-cont").addClass("temp-hdr");
			$('#info div.temp-hdr div.hdr-cell').removeClass("hdr-cell").addClass("temp-cell");	
			$('#info div.temp-hdr div.arrow-cont').css("opacity", "1");
			
			//MD: Handle triggers that load the activity summary
			$('#info').delegate('div.hdr-cont, div.temp-hdr', 'mouseenter mouseleave click', function(e){
				if (e.type == 'mouseenter'){
					$ida=$(this).attr("id"),
					$idi=$(this).index(),
					$idc=$(".category-subhead").attr("id"),
					$aCurrGrade=$($myxml).find('grade')[$standardId],
					$asumTop=$($aCurrGrade).find('topic')[$ida],
					$asumCat=$($asumTop).find('category')[$idc],
					$asumAct=$($asumCat).find('activity')[$idi],
					$act_hdr=$($asumAct).find('header'),
					$a_hdr=$($act_hdr).text(),
					$act_cont=$($asumAct).find('content'),
					$a_cont=$($act_cont).text(),
					$act_link=$($asumAct).find('link'),
					$a_link=$($act_link).text(),
					$act_subhd=$($asumAct).find('subhead'),
					$a_subhd=$($act_subhd).text(),
					$act_altloc=$($asumAct).find('altloctext'),
					$a_altloc=$($act_altloc).text();
					
					//MD: Load activity summary
					function loadSum(){
						$('#sum-cont').hide();
						$('#sum-cont').empty();
						$('#sum-cont span').empty();
						$('#sum-cont').append('<span id="txt-hdr">'+$a_hdr+'</span><br>');
						$('#sum-cont').append('<span id="txt-cont">'+$a_cont+'</span><br><br>');
						$('#sum-cont').append('<span id="txt-link"><a href="'+$a_link+'" target="_blank">Click to go to activity site</a></span><br><br>');
						$('#sum-cont').append('<span id="txt-subhd">'+$a_subhd+'</span><br>');
						$('#sum-cont').append('<span id="txt-altloc">'+$a_altloc+'</span>');
						$('#sum-cont').show();
					};
					
					//MD: Activity selection area
					//MD: First let's remove the focus from the first activity item in the list
					if($(this)!=$('div.temp-hdr')){
						$('div.temp-hdr').removeClass("temp-hdr").addClass("hdr-cont");
						$('div.temp-cell').removeClass("temp-cell").addClass("hdr-cell");
						
						//MD: Now let's handle selection highlighting
						$currSel=$('div.hdr-cont').index(this),
						$currChild=$(this).children(".hdr-cell").index(this),
						$currArrow=$(this).children(".arrow-cont");
						$('div.hdr-cont').not($currSel).css("background-color", "#c0c5c9");
						$('div.hdr-cont div.hdr-cell').not($currChild).css("background-color", "#c0c5c9");
						$(this).css("background-color", "#fff");
						$(this).children(".hdr-cell").css("background-color", "#fff");
						
						//MD: Display the arrow selection indicator
						$(this).children(".arrow-cont").css("opacity", "1");
						$('div.hdr-cont div.arrow-cont').not($currArrow).css("opacity", "0");
					};
					if($('div.hdr-sel').length > 0 && $(this)!=$('div.hdr-sel')){
						//MD: Handle selection highlighting when a selection has already been made
						$currSel=$('div.hdr-cont').index(this),
						$currChild=$(this).children(".hdr-cell").index(this),
						$currArrow=$(this).children(".arrow-cont");
						$('div.hdr-cont').not($currSel).css("background-color", "#c0c5c9");
						$('div.hdr-cont div.hdr-cell').not($currChild).css("background-color", "#c0c5c9");
						$(this).css("background-color", "#f4ba3d");
						$(this).children(".hdr-cell").css("background-color", "#fff");
						$('div.hdr-cont').children(".arrow-cont").css("background-color", "#fff");
						
						//MD: Display the arrow selection indicator
						$(this).children(".arrow-cont").css("opacity", "1");
						$('div.hdr-cont div.arrow-cont').not($currArrow).css("opacity", "0");
						
						//MD: Enable this line if you want other activity headers to display their details on rollover when a header is already selected
						//loadSum();
					};
					
				};
				if (e.type == 'click'){
						$currClick = $('div.hdr-cont').index(this),
						$currArr = $('div.hdr-sel div.arrow-sel').index(this);
						
						//MD: Hightlight clicked activity header
						//MD: Clear any current selections
						$('#info div.hdr-cont').css("background-color", "#c0c5c9");
						$('#info div.hdr-sel').removeClass("hdr-sel").addClass("hdr-cont");
						$('#info div.hdr-cont').children(".arrow-sel").removeClass("arrow-sel").addClass("arrow-cont");
						
						//MD: Highlight selected
						$(this).removeClass("hdr-cont").addClass("hdr-sel");
						$(this).children(".arrow-cont").removeClass("arrow-cont").addClass("arrow-sel");
						$(this).children(".hdr-cell").css("background-color", "#f4ba3d");
						$(this).children(".arrow-sel").css("background-color", "#f4ba3d");
						$('#info div.hdr-cont').children(".hdr-cell").css("background-color", "#c0c5c9");
						$('#info div.hdr-cont').children(".arrow-cont").css("background-color", "#c0c5c9");
						
						//MD: Display arrow indicator
						$(this).children(".arrow-sel").css("opacity", "1");
						$('div.hdr-cont div.arrow-cont').not($currArr).css("opacity", "0");
						
						//MD: Load the summary details on click
						loadSum();
				};
				if (e.type == 'mouseleave'){
					if($('div.hdr-sel').length > 0 && $(this)!=$('div.hdr-sel')){
						$currId=$('div.hdr-sel').attr("id"),
						$currIn=$('div.hdr-sel').index(),
						$currSubj=$(".category-subhead").attr("id"),
						$currGra=$($myxml).find('grade')[$standardId],
						$currTop=$($currGra).find('topic')[$currId],
						$currCat=$($currTop).find('category')[$currSubj],
						$currAct=$($currCat).find('activity')[$currIn],
						$curr_header=$($currAct).find('header'),
						$curr_hdr=$($curr_header).text();
						$curr_content=$($currAct).find('content'),
						$curr_cont=$($curr_content).text(),
						$curr_link=$($currAct).find('link'),
						$curr_lnk=$($curr_link).text(),
						$curr_subhead=$($currAct).find('subhead'),
						$curr_subhd=$($curr_subhead).text(),
						$curr_altlocation=$($currAct).find('altloctext'),
						$curr_altloc=$($curr_altlocation).text();
						
						// && $(this)!=$('div.hdr-sel')
						//MD: Remove highlight from unselected activity headers
						$('div.hdr-cont').css("background-color", "#c0c5c9");
						$('div.hdr-cont').children(".hdr-cell").css("background-color", "#c0c5c9");
						$('div.hdr-cont').children(".arrow-cont").css("background-color", "#c0c5c9");
						$('div.hdr-cont div.arrow-cont').css("opacity", "0");
						
						//MD: Load activity summary
						function loadCurr(){
							$('#sum-cont').empty();
							$('#sum-cont').append('<span id="txt-hdr">'+$curr_hdr+'</span><br>');
							$('#sum-cont').append('<span id="txt-cont">'+$curr_cont+'</span><br><br>');
							$('#sum-cont').append('<span id="txt-link"><a href="'+$curr_lnk+'" target="_blank">Click to go to activity site</a></span><br><br>');
							$('#sum-cont').append('<span id="txt-subhd">'+$curr_subhd+'</span><br>');
							$('#sum-cont').append('<span id="txt-altloc">'+$curr_altloc+'</span>');
						};
						
						//MD: Load currently "selected" summary details
						loadCurr();
					} else {
						loadSum();
					};
				};
			});
		});
	};
});

function loadBanner(){
	//MD: Set banner graphics
	$('.dyn_banner').animate({backgroundColor:'#0000'}, 200);
	$('.dyn_banner').animate({backgroundColor:'#011f55'}, 500, function(){$('#header_txt').animate({opacity: 1}, 400);});
	$factr=.4;
	if($(window).width<640){
		$factr=$factor*.65;
	} else if ($(window).width>640){
		$factr=.4;
	}
	$(window).resize(function(){
		$qwidth=$('#quilt_window').width();
		$offset=$('#activities').width()+6,
		$infowin=$('#information').width(),
		$sum=$infowin-$offset-3;
		$('#summary').width($sum);
		$('#details').width($sum);
		$('.dyn_banner').css("max-width", $qwidth);
		$('#information').css("max-width", $qwidth);
	});
};

//MD:MOBILE: Initialize mobile page
function mobileInit(){
	//MD:MOBILE: Subject list settings
	$wh=$(window).innerHeight(),
	$ww=$(window).innerWidth(),
	$btn_subjMenu=$('#quilt-selector'),
	$btn_subjMenuH=$('#quilt-selector').height(),
	$midPage=($wh/2)-90,
	$btn_subjWin=$('#quilt-selector>div.ui-collapsible-content'),
	
	 //MD:MOBILE: Position Subject list
	$($btn_subjMenu).css("top", "170px");
}

//MD:MOBILE: Update page when the orientation is changed
$( window ).on( "orientationchange", function( event ) {
	switch ( window.orientation ) {
		case 0:
			mobileInit()
		break;

		case 90:
			setDimensions();
		break;

		case -90:
			setDimensions();
		break;
	}
});

//MD:MOBILE: Initialize mobile page
$(document).on('pageinit', '#m-page', function(){
	mobileInit();
	
	$('#quilt-selector').css("top", "170px");
	
	//MD:MOBILE: Animate Subject list
	$('#quilt-selector').bind('collapsibleexpand', function () {
		$('#quilt-selector').removeClass("anim_btnDown");
		$('#quilt-selector').addClass("anim_btnUp");
		
	})
	
	//MD:MOBILE: Standards list link settings
	$('#standards-list').delegate('a', 'click', function (e) {
		$str = $(this).text();
		
		if(e.type == 'click'){
			$('#quilt-selector').removeClass("anim_btnDown");
			$('#quilt-selector').collapsible('collapse');
			$('#quilt-selector>h3>a').empty();
			$('#quilt-selector>h3>a').text($str);
			$('#quilt-selector>h3>a').addClass("anim_shrinkBtn");
			$('#grade-selector').addClass("anim_fadeBtnUp");
		};
	});
	
});

function load_mobileData(e){
	$.ajax({
		type: "GET",
		url: "feeds/qid_"+e+".xml",
		dataType: "xml",
		success: function(xml){
			$myxml=xml;
			
			loadGrades();
		}
	})
}

//MD:MOBILE: Build the quilt for mobile interfaces
function loadGrades(){
	
	//MD:MOBILE: Clear grades lists and add header
	$('#grades-list').empty();
	
	//MD_MOBILE: Add grades to list
	$($myxml).find('grades > grade').each(function(){
		$grade_title = $(this).attr("gname"),
		$grade_id = $(this).attr("gid");
		$('<li id="'+$grade_id+'"><a href="javascript:loadTopics('+$grade_id+');" data-theme="b" class="ui-nodisc-icon ui-btn ui-btn-icon-right ui-icon-carat-r" data-rel="close"><p>'+$grade_title+'</p></a></li>').appendTo('#grades-list');
	});
}

function loadTopics(id){
	$topic_id = id;
	
	$('#topics-list').empty();
	$('<h3 id="grades-hdr" data-theme="b" data-content-theme="c">Select a topic...</h3>').appendTo('#topics-list');
	
	$($myxml).find('topics > topic').each(function(){
		$title=$(this).text(),
		$id=$(this).attr("tid");
		
		//MD:MOBILE: Build topics list
		$('<li id="'+$id+'" data-role="collapsible" data-collapsed-icon="carat-r" data-expanded-icon="carat-d" data-iconpos="right" data-inset="false" class="topics_li"><h2><span class="li_hdr">'+$title+'</span></h2><ul data-role="listview" data-theme="b" id="topics_li"></ul></li>').appendTo('#topics-list');	
	});
}

