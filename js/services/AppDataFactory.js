'use strict';

angular.module('appDataFactory',['ngResource'])
.factory('appDataFactory', ['$q','$http','_',function($q, $http, _) {
  var data_local = null;
  var itemDefer = $q.defer();
  var navDefer = $q.defer();
  var api_url = {};
  var request_prefix = '';

  var factory = {
    queryData: function(prefix,stateparams) {
      api_url.page = 'json/page-json.cfm?URLPath=';
      switch(prefix) {
        case 'educ':
          api_url.page = api_url.page + 'educ/' + stateparams.page_id;
        break;

        case 'people':
          api_url.page = api_url.page + 'people/' + stateparams.person_name;
        break;

        case 'news':
          api_url.page = api_url.page + 'news/' + stateparams.news_year + '/' + stateparams.news_month + '/' + stateparams.news_day + '/' + stateparams.news_title;
        break;

        case 'planets':
          api_url.page = api_url.page + 'planets/' + stateparams.planet_id;
          if(_.has(stateparams,'sub_id')) {
            api_url.page = api_url.page + 'planets/' + stateparams.planet_id + '/' + stateparams.sub_id;
          }
        break;

        case 'missions':
          api_url.page = api_url.page + 'missions/' + stateparams.mission_id;
        break;
      }

      request_prefix = prefix;

      var promise = $http({method:'GET',url: api_url.page})
        .success(function (data, status, headers, config) {
          return data;
        })
        .error(function (data, status, headers, config) {
            console.error('Error fetching page feed:', data);
        });

      return promise;

      /*console.log(api_url.page);

      var data = $http({method:'GET',url: api_url.page})
        .then(
          function(response) {
            console.log('response.data');
            console.log(response.data);
            data_local = response.data;
            data_local.path_prefix = prefix;

            if(prefix == 'educ') {
              data_local.section = 'education';
              data_local.sidebar = {};
            }

            if(_.has(data_local,'missions')) {
              var missions_local = [];
              _.forEach(data_local.missions, function(mission) {
                var mission_types = mission.type.split(',');
                if(mission_types.length > 1) {
                  _.forEach(mission_types, function(mtype) {
                    mission.type = mtype;
                    missions_local.push({
                      content: mission.content,
                      title: mission.title,
                      type: mtype.replace(/\s+/g, '-').toLowerCase(),
                      url: mission.url
                    });
                  });
                } else {
                  missions_local.push(mission);
                }
              });
              data_local.missions = missions_local;
            }

            // temp placeholder data
            if(_.has(data_local.sidebar,'learn') && data_local.sidebar.learn.length > 0) {
              _(data_local.sidebar.learn).forEach(function(learning_focus) {
                if(learning_focus.image == '') { learning_focus.image = 'images/example/learning-focus-example.jpg'; }
              });
            }

            if(prefix == 'people') {

              if(_.has(data_local.sidebar,'learn') && data_local.sidebar.learn.length > 0) {
                _(data_local.sidebar.learn).forEach(function(learning_focus) {
                  if(learning_focus.related_missions[0].missions.length < 1) {
                    learning_focus.related_missions = [
      {
      "title": "",
      "url": "missions/target/saturn",
      "missions": [

        {
        "title": "Cassini",
        "url": "missions/cassini"
        },

        {
        "title": "Huygens",
        "url": "missions/huygens"
        },

        {
        "title": "Pioneer 11",
        "url": "missions/pioneer_11"
        }

      ]
      }
    ];
                  }
                });
              }

            }

            if(prefix == 'missions' || prefix == 'planets') {
              data_local.main.carousel = [];
              if(prefix == 'planets') {
                var webgl_caption = 'Aenean quis sollicitudin elit. Sed vel arcu sit amet turpis posuere cursus vel in elit.';
                if(stateparams.planet_id == 'jupiter') webgl_caption = 'Explore Jupiter and learn more about the Solar System\'s largest planet.';
                data_local.main.carousel.push({
                  type: 'embed',
                  url: 'webgl/planets/threex/examples/' + stateparams.planet_id.toLowerCase() + '_1200x1200.html',
                  content: webgl_caption
                });
              }
              var param_name = 'mission_id';
              if(prefix == 'planets') {
                param_name = 'planet_id';
              }
              if(stateparams[param_name].toLowerCase() != 'juno' && stateparams[param_name].toLowerCase() != 'dawn' && stateparams[param_name].toLowerCase() != 'jupiter') {
                data_local.main.carousel.push({
                  type: 'image',
                  image: 'images/example/rotator_'+ stateparams[param_name].toLowerCase() +'.jpg',
                  alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                  content: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.'
                });
              }
              if(stateparams[param_name].toLowerCase() == 'juno') {
                var juno_content = '';
                _.forEach(_.range(3),function(index) {
                  if(index == 0) juno_content = 'Track Juno\'s journey as it prepares for a 2016 arrival at Jupiter.';
                  if(index == 1) juno_content = 'Find out more about Juno\'s science targets at Jupiter.';
                  if(index == 2) juno_content = 'News:  NASA\'s Jupiter-Bound Juno Changes its Orbit';
                  data_local.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ stateparams[param_name].toLowerCase() + (index+1) +'.jpg',
                    alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                    content: juno_content
                  });
                });
              }
              if(stateparams[param_name].toLowerCase() == 'dawn') {
                _.forEach(_.range(3),function(index) {
                  data_local.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ stateparams[param_name].toLowerCase() + (index+1) +'.jpg',
                    alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                    content: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.'
                  });
                });
              }
              if(stateparams[param_name].toLowerCase() == 'jupiter') {
                _.forEach(_.range(4),function(index) {
                  var jupiter_content = '';
                  if(index == 0) jupiter_content = 'Explore Jupiter\'s Moons, from Io to Europa to beyond.'
                  if(index == 1) jupiter_content = 'See more about Galileo\'s visit to Jupiter.';
                  if(index == 2) jupiter_content = 'Get an insight into Jupiter Aurora\'s, as seen from the Hubble telescope.';
                  if(index == 3) jupiter_content = 'News:  Jupiter\'s Red Spot is Likely a Sunburn, Not a Blush';
                  data_local.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ stateparams[param_name].toLowerCase() + (index+1) +'.jpg',
                    alt: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.',
                    content: jupiter_content
                  });
                });
              }

              if(!_.has(data_local,'moonsblurb')) {
                data_local.moonsblurb = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sodales neque non ligula hendrerit, et venenatis sapien varius. Nullam tempor maximus leo, eu pellentesque lorem placerat at. Etiam eget dolor posuere, ornare leo a, pulvinar risus. Nulla efficitur lorem non leo ultrices sodales. Curabitur ac pretium magna, ac pulvinar tortor.';
              }

              if(_.has(data_local, 'related_stories')) {
                _.forEach(data_local.related_stories, function(story) {
                  if(!_.has(story,'image')) {
                    story.image = 'images/example/news-1.jpg';
                  }
                });
              }

              if(!_.has(data_local,'quick_links')) {
                data_local.quick_links = [];
                data_local.quick_links.push({
                  title: "50 Years of Robotic Planetary Exploration: Claudia Alexander, Project Scientist at the Jet Propulsion Laboratory",
                  url: "news/2012/11/30/50-years-of-robotic-planetary-exploration-claudia-alexander-project-scientist-at-the-jet-"
                });
                data_local.quick_links.push({
                  title: "Swirling Storms on Saturn",
                  url: "news/2012/11/28/swirling-storms-on-saturn"
                });
                data_local.quick_links.push({
                  title: "50 Years of Robotic Planetary Exploration: Ashley Stroupe (Robotics Software Engineer / Mars Rover Driver at the Jet Propulsion Laboratory)",
                  url: "news/2012/10/30/50-years-of-robotic-planetary-exploration-ashley-stroupe-robotics-software-engineer-mars-"
                });
              }

              if(!_.has(data_local,'timeline') || (_.has(data_local,'timeline') && data_local.timeline.length < 1)) {
                data_local.timeline = [];
                data_local.timeline.push({
    "title": "Calculations of the Planets By Copernicus"
    ,"content": "Polish astronomer and church canon Nicolaus Copernicus begins his observations of the planets. He deduces that the changing brightness of the planets is caused by the movement of all the planets -- including Earth -- around the sun. Copernicus calculates the planets' positions, and publishes his findings in \"On the Revolutions of the Celestial Orbs\" shortly before his death in 1543."
    ,"date": "1512"
    ,"image": "images/slideshow/Nikolaus_Kopernikus200X200.jpg"
    ,"url": "scitech/display.cfm?ST_ID=225"
    });
                data_local.timeline.push({
    "title": "Galileo is the First to View Saturn's Rings"
    ,"content": "Galileo Galilei is the first person to view Saturn, and Saturn's rings with a telescope. However, Galileo does not know what these \"appendages\" could be -- moons perhaps? Galileo sends a coded message to Johannes Kepler, but Kepler misreads the message thinking Galileo has discovered two moons of Mars -- over 200 year before Asaph Hall discovers Mars' two moons."
    ,"date": "15 Jul 1610"
    ,"image": "images/slideshow/Portrait_of_Galileo_Galilei200X200.jpg"
    ,"url": "news/whatsup-view.cfm?WUID=510"
    });

                data_local.timeline.push({
    "title": "Ring Deduction"
    ,"content": "Christiaan Huygens solves the mystery regarding what Galileo saw through his telescope surrounding Saturn 49 years earlier: The appendages Galileo saw on each side of Saturn were not moons, but in fact a ring system."
    ,"date": "1659"
    ,"image": "images/slideshow/Christiaans_huigens_by_Caspar_Netscher200X200.jpg"
    ,"url": "planets/profile.cfm?Object=Saturn&Display=Rings"
    });

                data_local.timeline.push({
    "title": "Saturn Pioneer"
    ,"content": "Pioneer 11 (the first spacecraft to reach Saturn) flies within 22,000 km (13,700 miles) of the cloud tops of the second largest planet in our solar system. Among Pioneer 11's discoveries at Saturn were conclusive evidence of the existence of a Saturnian magnetic field, and the ring titled \"F.\""
    ,"date": "1 Sep 1979"
    ,"image": "images/slideshow/Saturn Pioneer200X200_2.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=P&Alias=Pioneer%2011"
    });

                data_local.timeline.push({
    "title": "Voyager 1 Discoveries"
    ,"content": "Voyager 1 flies by the ringed planet: Saturn. In its flyby of Saturn, Voyager 1 discovers three moons: Prometheus and Pandora, the shepherding moons of the F ring, and Atlas, which similarly shepherds the A ring. Voyager 1 also discovers a new ring and reveals the intricate structure of the ring system, consisting of thousands of bands."
    ,"date": "Nov 1979"
    ,"image": "images/slideshow/Prometheus200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%201"
    });

                data_local.timeline.push({
    "title": "Close Approach"
    ,"content": "Voyager 1 comes its closest to the planet Saturn at 23:45 UT from a range of 124,000 km. Voyager 1 found that about 7 percent of the volume of Saturn's upper atmosphere is helium (compared with 11 percent of Jupiter's atmosphere), while almost all the rest is hydrogen."
    ,"date": "12 Nov 1980"
    ,"image": "images/slideshow/Voyager Image of Saturn200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%201"
    });

                data_local.timeline.push({
    "title": "Voyager 2"
    ,"content": "Voyager 2 repeats the photographic mission of its predecessor, although it flies 23,000 km closer to Saturn. The closest encounter was at 01:21 UT at a range of 101,000 km. Voyager 2 provided more detailed images of the ring spokes and kinks, as well as the F-ring and its shepherding moons. Voyager 2's data suggested that Saturn's A-ring was perhaps only 300 m thick."
    ,"date": "26 Aug 1981"
    ,"image": "images/slideshow/Voyager 2 Ring Spokes200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%202"
    });

                data_local.timeline.push({
    "title": "First Spacecraft to Orbit Saturn"
    ,"content": "Cassini is the first spacecraft to orbit Saturn. Cassini's 12 instruments have returned a daily stream of data from Saturn's system since arriving at Saturn, including many high-resolution images of the Saturn system."
    ,"date": "1 Jul 2004"
    ,"image": "images/slideshow/Cassini_Saturn200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=C&Alias=Cassini"
    });
              }

              data_local.sidebar.related_events = [];
              data_local.sidebar.related_events.push({
                pubdate: '03 Sep 2014',
                url: '#',
                title: 'Lorem ipsum dolor sit amet'
              });
              data_local.sidebar.related_events.push({
                pubdate: '03 Aug 2014',
                url: '#',
                title: 'Pellentesque finibus velit id lorem consequat, efficitur venenatis felis luctus.'
              });
              data_local.sidebar.related_events.push({
                pubdate: '03 Jul 2014',
                url: '#',
                title: 'Sed et gravida tortor. Curabitur id ultrices enim.'
              });
              data_local.sidebar.related_events.push({
                pubdate: '03 Jun 2014',
                url: '#',
                title: 'Donec lobortis leo lacinia molestie tristique.'
              });

              if(_.has(data_local.sidebar,'learn') && data_local.sidebar.learn.length > 0) {
                _(data_local.sidebar.learn).forEach(function(learning_focus) {
                  if(learning_focus.related_missions[0].missions.length < 1) {
                    learning_focus.related_missions = [
      {
      "title": "",
      "url": "missions/target/saturn",
      "missions": [

        {
        "title": "Cassini",
        "url": "missions/cassini"
        },

        {
        "title": "Huygens",
        "url": "missions/huygens"
        },

        {
        "title": "Pioneer 11",
        "url": "missions/pioneer_11"
        }

      ]
      }
    ];
                  }
                  if(!_.has(learning_focus,'related_people')) {
                    learning_focus.related_people = [];
                    learning_focus.related_people.push(
                      {
                      "name": "Al Hibbs",
                      "title": "Scientist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/HibbsA",
                      "image": "images/people/HibbsA-main.jpg"
                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Julie Castillo-Rogez",
                      "title": "Planetary Geophysicist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/Castillo-RogezJ"

                        , "image": "images/people/Castillo-RogezJ-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Fran Bagenal",
                      "title": "Professor of Astrophysical and Planetary Sciences",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/BagenalF"

                        , "image": "images/people/BagenalF-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Amy Simon-Miller",
                      "title": "Astrophysicist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/Simon-MillerA"

                        , "image": "images/people/Simon-MillerA-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Robert Mitchell",
                      "title": "Program Manager",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/MitchellR"

                        , "image": "images/people/MitchellR-main.jpg"
                      }
                    );

                  }
                });
              }

            } //end planets & missions check
            // end temp placeholder data

            itemDefer.resolve(data_local);
          },
          function(response) { console.log('ERROR!!'); console.log(response); }
        );
      return itemDefer.promise;*/
    },
    getPathPrefix: function() { return request_prefix; },
    queryNav: function(path) {
      api_url.nav = 'json/nav-json.cfm?URLPath=';
      api_url.nav = api_url.nav + path;
      var promise = $http({method:'GET',url: api_url.nav})
        .success(function (data, status, headers, config) {
          return data;
        })
        .error(function (data, status, headers, config) {
          console.error('Error fetching nav feed:', data);
        });

      return promise;
/*      var data = $http({method:'GET',url: api_url.nav})
      .then(
        function(response) {
          var nav = _.find(response.data.section, function(nav) { return nav.sectionName.toLowerCase() == path.toLowerCase() });
          nav.state_refs = [];
          _.forEach(nav.sub, function(sub) {
            nav.state_refs.push({
              state: nav.sectionTitle.toLowerCase() + 'detail',
              prefix: nav.sectionTitle.toLowerCase(),
              id: sub.pageName.toLowerCase(),
              title: sub.pageTitle
            });
          });
          navDefer.resolve(nav);
        },
        function(response) { console.log('NAV ERROR!!'); console.log(response); }
      );
      return navDefer.promise;*/
    },
    processData: function(data) {
      var prefix = this.getPathPrefix();
      if(prefix == 'educ') {
        data.section = 'education';
        data.sidebar = {};
      }

      if(_.has(data,'missions')) {
              var missions_local = [];
              _.forEach(data.missions, function(mission) {
                var mission_types = mission.type.split(',');
                if(mission_types.length > 1) {
                  _.forEach(mission_types, function(mtype) {
                    mission.type = mtype;
                    missions_local.push({
                      content: mission.content,
                      title: mission.title,
                      type: mtype.replace(/\s+/g, '-').toLowerCase(),
                      url: mission.url
                    });
                  });
                } else {
                  missions_local.push(mission);
                }
              });
              data.missions = missions_local;
            }

            // temp placeholder data
            if(_.has(data.sidebar,'learn') && data.sidebar.learn.length > 0) {
              _(data.sidebar.learn).forEach(function(learning_focus) {
                if(learning_focus.image == '') { learning_focus.image = 'images/example/learning-focus-example.jpg'; }
              });
            }

            if(prefix == 'people') {

              if(_.has(data.sidebar,'learn') && data.sidebar.learn.length > 0) {
                _(data.sidebar.learn).forEach(function(learning_focus) {
                  if(learning_focus.related_missions[0].missions.length < 1) {
                    learning_focus.related_missions = [
      {
      "title": "",
      "url": "missions/target/saturn",
      "missions": [

        {
        "title": "Cassini",
        "url": "missions/cassini"
        },

        {
        "title": "Huygens",
        "url": "missions/huygens"
        },

        {
        "title": "Pioneer 11",
        "url": "missions/pioneer_11"
        }

      ]
      }
    ];
                  }
                });
              }

            }

            if(prefix == 'missions' || prefix == 'planets') {
              var target = data.title.toLowerCase();
              data.main.carousel = [];
              if(prefix == 'planets') {
                var webgl_caption = 'Aenean quis sollicitudin elit. Sed vel arcu sit amet turpis posuere cursus vel in elit.';
                if(target == 'jupiter') webgl_caption = 'Explore Jupiter and learn more about the Solar System\'s largest planet.';
                data.main.carousel.push({
                  type: 'embed',
                  url: 'webgl/planets/threex/examples/' + target + '_1200x1200.html',
                  content: webgl_caption
                });
              }
              var param_name = 'mission_id';
              if(prefix == 'planets') {
                param_name = 'planet_id';
              }
              if(target != 'juno' && target != 'dawn' && target != 'jupiter') {
                data.main.carousel.push({
                  type: 'image',
                  image: 'images/example/rotator_'+ target +'.jpg',
                  alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                  content: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.'
                });
              }
              if(target == 'juno') {
                var juno_content = '';
                _.forEach(_.range(3),function(index) {
                  if(index == 0) juno_content = 'Track Juno\'s journey as it prepares for a 2016 arrival at Jupiter.';
                  if(index == 1) juno_content = 'Find out more about Juno\'s science targets at Jupiter.';
                  if(index == 2) juno_content = 'News:  NASA\'s Jupiter-Bound Juno Changes its Orbit';
                  data.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ target + (index+1) +'.jpg',
                    alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                    content: juno_content
                  });
                });
              }
              if(target == 'dawn') {
                _.forEach(_.range(3),function(index) {
                  data.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ target + (index+1) +'.jpg',
                    alt: 'Ut feugiat leo risus, at elementum augue rutrum sed',
                    content: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.'
                  });
                });
              }
              if(target == 'jupiter') {
                _.forEach(_.range(4),function(index) {
                  var jupiter_content = '';
                  if(index == 0) jupiter_content = 'Explore Jupiter\'s Moons, from Io to Europa to beyond.'
                  if(index == 1) jupiter_content = 'See more about Galileo\'s visit to Jupiter.';
                  if(index == 2) jupiter_content = 'Get an insight into Jupiter Aurora\'s, as seen from the Hubble telescope.';
                  if(index == 3) jupiter_content = 'News:  Jupiter\'s Red Spot is Likely a Sunburn, Not a Blush';
                  data.main.carousel.push({
                    type: 'image',
                    image: 'images/example/rotator_'+ target + (index+1) +'.jpg',
                    alt: 'Aliquam non vulputate sem, non sagittis metus. Vivamus et dictum ex. Integer efficitur nibh sem, vitae bibendum metus lacinia eget.',
                    content: jupiter_content
                  });
                });
              }

              if(_.has(data, 'related_stories')) {
                _.forEach(data.related_stories, function(story) {
                  if(!_.has(story,'image')) {
                    story.image = 'images/example/news-1.jpg';
                  }
                });
              }

              if(!_.has(data,'quick_links')) {
                data.quick_links = [];
                data.quick_links.push({
                  title: "50 Years of Robotic Planetary Exploration: Claudia Alexander, Project Scientist at the Jet Propulsion Laboratory",
                  url: "news/2012/11/30/50-years-of-robotic-planetary-exploration-claudia-alexander-project-scientist-at-the-jet-"
                });
                data.quick_links.push({
                  title: "Swirling Storms on Saturn",
                  url: "news/2012/11/28/swirling-storms-on-saturn"
                });
                data.quick_links.push({
                  title: "50 Years of Robotic Planetary Exploration: Ashley Stroupe (Robotics Software Engineer / Mars Rover Driver at the Jet Propulsion Laboratory)",
                  url: "news/2012/10/30/50-years-of-robotic-planetary-exploration-ashley-stroupe-robotics-software-engineer-mars-"
                });
              }

              if(!_.has(data,'timeline') || (_.has(data,'timeline') && data.timeline.length < 1)) {
                data.timeline = [];
                data.timeline.push({
    "title": "Calculations of the Planets By Copernicus"
    ,"content": "Polish astronomer and church canon Nicolaus Copernicus begins his observations of the planets. He deduces that the changing brightness of the planets is caused by the movement of all the planets -- including Earth -- around the sun. Copernicus calculates the planets' positions, and publishes his findings in \"On the Revolutions of the Celestial Orbs\" shortly before his death in 1543."
    ,"date": "1512"
    ,"image": "images/slideshow/Nikolaus_Kopernikus200X200.jpg"
    ,"url": "scitech/display.cfm?ST_ID=225"
    });
                data.timeline.push({
    "title": "Galileo is the First to View Saturn's Rings"
    ,"content": "Galileo Galilei is the first person to view Saturn, and Saturn's rings with a telescope. However, Galileo does not know what these \"appendages\" could be -- moons perhaps? Galileo sends a coded message to Johannes Kepler, but Kepler misreads the message thinking Galileo has discovered two moons of Mars -- over 200 year before Asaph Hall discovers Mars' two moons."
    ,"date": "15 Jul 1610"
    ,"image": "images/slideshow/Portrait_of_Galileo_Galilei200X200.jpg"
    ,"url": "news/whatsup-view.cfm?WUID=510"
    });

                data.timeline.push({
    "title": "Ring Deduction"
    ,"content": "Christiaan Huygens solves the mystery regarding what Galileo saw through his telescope surrounding Saturn 49 years earlier: The appendages Galileo saw on each side of Saturn were not moons, but in fact a ring system."
    ,"date": "1659"
    ,"image": "images/slideshow/Christiaans_huigens_by_Caspar_Netscher200X200.jpg"
    ,"url": "planets/profile.cfm?Object=Saturn&Display=Rings"
    });

                data.timeline.push({
    "title": "Saturn Pioneer"
    ,"content": "Pioneer 11 (the first spacecraft to reach Saturn) flies within 22,000 km (13,700 miles) of the cloud tops of the second largest planet in our solar system. Among Pioneer 11's discoveries at Saturn were conclusive evidence of the existence of a Saturnian magnetic field, and the ring titled \"F.\""
    ,"date": "1 Sep 1979"
    ,"image": "images/slideshow/Saturn Pioneer200X200_2.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=P&Alias=Pioneer%2011"
    });

                data.timeline.push({
    "title": "Voyager 1 Discoveries"
    ,"content": "Voyager 1 flies by the ringed planet: Saturn. In its flyby of Saturn, Voyager 1 discovers three moons: Prometheus and Pandora, the shepherding moons of the F ring, and Atlas, which similarly shepherds the A ring. Voyager 1 also discovers a new ring and reveals the intricate structure of the ring system, consisting of thousands of bands."
    ,"date": "Nov 1979"
    ,"image": "images/slideshow/Prometheus200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%201"
    });

                data.timeline.push({
    "title": "Close Approach"
    ,"content": "Voyager 1 comes its closest to the planet Saturn at 23:45 UT from a range of 124,000 km. Voyager 1 found that about 7 percent of the volume of Saturn's upper atmosphere is helium (compared with 11 percent of Jupiter's atmosphere), while almost all the rest is hydrogen."
    ,"date": "12 Nov 1980"
    ,"image": "images/slideshow/Voyager Image of Saturn200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%201"
    });

                data.timeline.push({
    "title": "Voyager 2"
    ,"content": "Voyager 2 repeats the photographic mission of its predecessor, although it flies 23,000 km closer to Saturn. The closest encounter was at 01:21 UT at a range of 101,000 km. Voyager 2 provided more detailed images of the ring spokes and kinks, as well as the F-ring and its shepherding moons. Voyager 2's data suggested that Saturn's A-ring was perhaps only 300 m thick."
    ,"date": "26 Aug 1981"
    ,"image": "images/slideshow/Voyager 2 Ring Spokes200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=V&Alias=Voyager%202"
    });

                data.timeline.push({
    "title": "First Spacecraft to Orbit Saturn"
    ,"content": "Cassini is the first spacecraft to orbit Saturn. Cassini's 12 instruments have returned a daily stream of data from Saturn's system since arriving at Saturn, including many high-resolution images of the Saturn system."
    ,"date": "1 Jul 2004"
    ,"image": "images/slideshow/Cassini_Saturn200X200.jpg"
    ,"url": "missions/profile.cfm?Sort=Alpha&Letter=C&Alias=Cassini"
    });
              }

              data.sidebar.related_events = [];
              data.sidebar.related_events.push({
                pubdate: '03 Sep 2014',
                url: '#',
                title: 'Lorem ipsum dolor sit amet'
              });
              data.sidebar.related_events.push({
                pubdate: '03 Aug 2014',
                url: '#',
                title: 'Pellentesque finibus velit id lorem consequat, efficitur venenatis felis luctus.'
              });
              data.sidebar.related_events.push({
                pubdate: '03 Jul 2014',
                url: '#',
                title: 'Sed et gravida tortor. Curabitur id ultrices enim.'
              });
              data.sidebar.related_events.push({
                pubdate: '03 Jun 2014',
                url: '#',
                title: 'Donec lobortis leo lacinia molestie tristique.'
              });

              if(_.has(data.sidebar,'learn') && data.sidebar.learn.length > 0) {
                _(data.sidebar.learn).forEach(function(learning_focus) {
                  if(learning_focus.related_missions[0].missions.length < 1) {
                    learning_focus.related_missions = [
      {
      "title": "",
      "url": "missions/target/saturn",
      "missions": [

        {
        "title": "Cassini",
        "url": "missions/cassini"
        },

        {
        "title": "Huygens",
        "url": "missions/huygens"
        },

        {
        "title": "Pioneer 11",
        "url": "missions/pioneer_11"
        }

      ]
      }
    ];
                  }
                  if(!_.has(learning_focus,'related_people')) {
                    learning_focus.related_people = [];
                    learning_focus.related_people.push(
                      {
                      "name": "Al Hibbs",
                      "title": "Scientist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/HibbsA",
                      "image": "images/people/HibbsA-main.jpg"
                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Julie Castillo-Rogez",
                      "title": "Planetary Geophysicist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/Castillo-RogezJ"

                        , "image": "images/people/Castillo-RogezJ-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Fran Bagenal",
                      "title": "Professor of Astrophysical and Planetary Sciences",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/BagenalF"

                        , "image": "images/people/BagenalF-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Amy Simon-Miller",
                      "title": "Astrophysicist",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/Simon-MillerA"

                        , "image": "images/people/Simon-MillerA-main.jpg"

                      }
                    );
                    learning_focus.related_people.push(
                      {
                      "name": "Robert Mitchell",
                      "title": "Program Manager",
                      "content": "Interdum et malesuada fames ac ante ipsum primis in faucibus. Quisque sapien purus, hendrerit ac fermentum vitae, commodo id risus.",
                      "url": "people/MitchellR"

                        , "image": "images/people/MitchellR-main.jpg"
                      }
                    );

                  }
                });
              }

            } //end planets & missions check
            // end temp placeholder data


      return data;
    }
  }

  return factory;
}])
.factory('sidePopFactory', function($resource){
  return  $resource('data/sidebarPop.json');
})
.factory('planetsGalFactory', function($resource){
	return  $resource('data/planetsGal.json');
})
.factory('missionsGalFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions');
})
.factory('missionsTypeFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions/type');
})
.factory('missionsTargetFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions/target');
})
.factory('navFactory', function($resource){
	return $resource('json/nav-json.cfm?urlpath=all');
})
.factory('peopleGalFactory', function($q, $http) {
	return {
		getPeople: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=people")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
})
.factory('newsGalFactory', function($q, $http) {
	return {
		getNews: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=news")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
})
.factory('sbFactory', function($resource){
	return $resource('json/home-sidebar-json.cfm');
})
.factory('galleriesGalFactory', function($q, $http){
	return {
		getBest: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=galleries")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
});
