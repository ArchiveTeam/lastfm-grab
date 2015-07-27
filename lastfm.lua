dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}
local addedtolist = {}

-- Do not download the following list of urls:
downloaded["ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"] = true
downloaded["ajax.googleapis.com/ajax/libs/prototype/1.7.1.0/prototype.js"] = true
downloaded["ajax.googleapis.com/ajax/libs/scriptaculous/1.9.0/scriptaculous.js"] = true
downloaded["cdn.last.fm/css/css/231990/events/view.css"] = true
downloaded["cdn.last.fm/css/css/231990/journal/overview.css"] = true
downloaded["cdn.last.fm/css/css/231990/listen/overview-buggles.css"] = true
downloaded["cdn.last.fm/css/css/231990/listen/player-buggles.css"] = true
downloaded["cdn.last.fm/css/css/231990/listen/webclient-buggles.css"] = true
downloaded["cdn.last.fm/css/css/231990/listen/youtube.css"] = true
downloaded["cdn.last.fm/css/css/231990/master.css"] = true
downloaded["cdn.last.fm/css/css/231990/playlist/overview.css"] = true
downloaded["cdn.last.fm/css/css/231990/shoutbox/overview.css"] = true
downloaded["cdn.last.fm/css/css/231990/themes/whittle.css"] = true
downloaded["cdn.last.fm/css/css/231990/user/library.css"] = true
downloaded["cdn.last.fm/css/css/231990/user/neighbours.css"] = true
downloaded["cdn.last.fm/css/css/231990/user/now.css"] = true
downloaded["cdn.last.fm/css/css/231990/user/overview.css"] = true
downloaded["cdn.last.fm/css/css/231990/user/tracks.css"] = true
downloaded["cdn.last.fm/css/css/231990/wiki/overview.css"] = true
downloaded["cdn.last.fm/depth/charts/arrow_left.gif"] = true
downloaded["cdn.last.fm/depth/global/page_next.gif"] = true
downloaded["cdn.last.fm/depth/global/page_previous.gif"] = true
downloaded["cdn.last.fm/favicons/cal/google_10px.gif"] = true
downloaded["cdn.last.fm/favicons/cal/ical.gif"] = true
downloaded["cdn.last.fm/flatness/clear.gif"] = true
downloaded["cdn.last.fm/flatness/favicon.2.ico"] = true
downloaded["cdn.last.fm/flatness/library/navigation/banned_tracks.png"] = true
downloaded["cdn.last.fm/flatness/library/navigation/loved_tracks.png"] = true
downloaded["cdn.last.fm/flatness/library/navigation/music.png"] = true
downloaded["cdn.last.fm/flatness/library/navigation/playlists.png"] = true
downloaded["cdn.last.fm/flatness/listen_v2/dismiss_x_15x15.png"] = true
downloaded["cdn.last.fm/flatness/messageboxes/error.png"] = true
downloaded["cdn.last.fm/flatness/responsive/2/noimage/default_user_140_g2.png"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/ads.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/components.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/dialog.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/form/typeahead.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/LFM.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/jwplayer/v5/jwplayer.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/modernizr.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/mustache-min.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/requirejs/require-min.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/sm2-min.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/ufo.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/lib/uuid.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/radio.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/user/library.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/user/libraryexport.js"] = true
downloaded["cdn.last.fm/javascript/javascript/232025/user/overview.js"] = true
downloaded["cdn.last.fm/opensearch.xml"] = true
downloaded["cdn.last.fm/pngbehavior2.htc"] = true
downloaded["cdn.lst.fm/depth/buttons/journal_button_01.gif"] = true
downloaded["cdn.lst.fm/depth/buttons/journal_button_02.gif"] = true
downloaded["cdn.lst.fm/depth/charts/barchart_end.gif"] = true
downloaded["cdn.lst.fm/depth/charts/barchart_fakeborder.gif"] = true
downloaded["cdn.lst.fm/depth/charts/half-width_bg.gif"] = true
downloaded["cdn.lst.fm/depth/charts/half-width_bg_hover.gif"] = true
downloaded["cdn.lst.fm/depth/charts/inlinechart_fixed_bg.gif"] = true
downloaded["cdn.lst.fm/depth/charts/inlinechart_fixed_bg_hover.gif"] = true
downloaded["cdn.lst.fm/depth/charts/tagchart_end2.gif"] = true
downloaded["cdn.lst.fm/depth/charts/tagchart_fakeborder.gif"] = true
downloaded["cdn.lst.fm/depth/forms/incorrect_new.gif"] = true
downloaded["cdn.lst.fm/depth/global/arrow_l.png"] = true
downloaded["cdn.lst.fm/depth/global/arrow_l_anim.gif"] = true
downloaded["cdn.lst.fm/depth/global/arrow_l_hover.png"] = true
downloaded["cdn.lst.fm/depth/global/arrow_r.png"] = true
downloaded["cdn.lst.fm/depth/global/arrow_r_anim.gif"] = true
downloaded["cdn.lst.fm/depth/global/arrow_r_hover.png"] = true
downloaded["cdn.lst.fm/depth/global/page_next.gif"] = true
downloaded["cdn.lst.fm/depth/global/page_previous.gif"] = true
downloaded["cdn.lst.fm/depth/global/progress.gif"] = true
downloaded["cdn.lst.fm/depth/global/progress_large.gif"] = true
downloaded["cdn.lst.fm/depth/homepage_960/signupbutton.gif"] = true
downloaded["cdn.lst.fm/depth/icons/addtoplaylist.gif"] = true
downloaded["cdn.lst.fm/depth/icons/track_added.gif"] = true
downloaded["cdn.lst.fm/flatness/buttons/3/is_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/4/is_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/4/is_left_loved.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/4/small_multi_white.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/5/button.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/5/confirm_button.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/5/confirm_button_blue.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/add_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/add_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/buy_dl_drp_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/buy_dl_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/buy_drp_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/buy_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/dl_drp_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/dl_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/rt_drp_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/6/small_multi.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/7/freedownload_large_bottom.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/7/freedownload_large_top.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/7/freedownload_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/7/freedownload_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/add.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/add_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_left_small.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_right_nodropdown.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_right_small.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/buy_right_small_nodropdown.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/grey_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/join_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/lightgrey_dropdown_right.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/more_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/share_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/8/tag_left.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/9/flex-arrows.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/9/multibuttonicons.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/delete.2.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/stationbutton/2/stationbutton-extended.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/stationbutton/7/stationbutton-large.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/stationbutton/8/stationbutton-large.png"] = true
downloaded["cdn.lst.fm/flatness/buttons/stationbutton/8/stationbutton-medium.png"] = true
downloaded["cdn.lst.fm/flatness/calendar_icon_32.png"] = true
downloaded["cdn.lst.fm/flatness/catalogue/album/jewelcase_large.png"] = true
downloaded["cdn.lst.fm/flatness/catalogue/album/jewelcase_medium.png"] = true
downloaded["cdn.lst.fm/flatness/catalogue/album/jewelcase_mega.png"] = true
downloaded["cdn.lst.fm/flatness/catalogue/album/jewelcase_small.png"] = true
downloaded["cdn.lst.fm/flatness/charts/2/openclose.png"] = true
downloaded["cdn.lst.fm/flatness/charts/chartbar.png"] = true
downloaded["cdn.lst.fm/flatness/charts/collapsiblebox-tab.gif"] = true
downloaded["cdn.lst.fm/flatness/components/eventometer/bg.3.png"] = true
downloaded["cdn.lst.fm/flatness/components/message/error.png"] = true
downloaded["cdn.lst.fm/flatness/components/message/ok.png"] = true
downloaded["cdn.lst.fm/flatness/components/tertiaryNavigation/medium_tab_left.png"] = true
downloaded["cdn.lst.fm/flatness/components/tertiaryNavigation/medium_tab_left_inactive.png"] = true
downloaded["cdn.lst.fm/flatness/components/tertiaryNavigation/medium_tab_right.png"] = true
downloaded["cdn.lst.fm/flatness/components/tertiaryNavigation/medium_tab_right_inactive.png"] = true
downloaded["cdn.lst.fm/flatness/controls.3.png"] = true
downloaded["cdn.lst.fm/flatness/controls.4.png"] = true
downloaded["cdn.lst.fm/flatness/giant_success_tick.gif"] = true
downloaded["cdn.lst.fm/flatness/giant_success_tick.png"] = true
downloaded["cdn.lst.fm/flatness/global/icon_add_hover.gif"] = true
downloaded["cdn.lst.fm/flatness/global/icon_eq.gif"] = true
downloaded["cdn.lst.fm/flatness/global/icon_eq_paused.gif"] = true
downloaded["cdn.lst.fm/flatness/global/user/icon_staff_m.png"] = true
downloaded["cdn.lst.fm/flatness/grey-more-btn.gif"] = true
downloaded["cdn.lst.fm/flatness/grids/fiflufi_right.5.png"] = true
downloaded["cdn.lst.fm/flatness/grids/grid_48.15.png"] = true
downloaded["cdn.lst.fm/flatness/header/lastfm_logo_black.png"] = true
downloaded["cdn.lst.fm/flatness/header/lastfm_logo_black@2x.png"] = true
downloaded["cdn.lst.fm/flatness/header/lastfm_logo_red.png"] = true
downloaded["cdn.lst.fm/flatness/header/lastfm_logo_red@2x.png"] = true
downloaded["cdn.lst.fm/flatness/headingwithnav/1/crumb-arrow.png"] = true
downloaded["cdn.lst.fm/flatness/home/find_friends.png"] = true
downloaded["cdn.lst.fm/flatness/home/setup_scrobbling.png"] = true
downloaded["cdn.lst.fm/flatness/home/setup_scrobbling_wide.png"] = true
downloaded["cdn.lst.fm/flatness/icons/activity/2/loved.png"] = true
downloaded["cdn.lst.fm/flatness/icons/see_more_arrow_blue_13x13_2.png"] = true
downloaded["cdn.lst.fm/flatness/icons/tag/1/globaltag_left.png"] = true
downloaded["cdn.lst.fm/flatness/icons/tag/1/globaltag_right.png"] = true
downloaded["cdn.lst.fm/flatness/join/captcha/audio.png"] = true
downloaded["cdn.lst.fm/flatness/join/captcha/help.png"] = true
downloaded["cdn.lst.fm/flatness/join/captcha/refresh.png"] = true
downloaded["cdn.lst.fm/flatness/join/captcha/text.png"] = true
downloaded["cdn.lst.fm/flatness/labs/labs_12.png"] = true
downloaded["cdn.lst.fm/flatness/library/album_left_onhover.png"] = true
downloaded["cdn.lst.fm/flatness/library/album_left_onpress.png"] = true
downloaded["cdn.lst.fm/flatness/library/album_right_onhover.png"] = true
downloaded["cdn.lst.fm/flatness/library/album_right_onpress.png"] = true
downloaded["cdn.lst.fm/flatness/library/letter_flag.png"] = true
downloaded["cdn.lst.fm/flatness/library/library_tab_left.png"] = true
downloaded["cdn.lst.fm/flatness/library/library_tab_left_inactive.png"] = true
downloaded["cdn.lst.fm/flatness/library/library_tab_right.png"] = true
downloaded["cdn.lst.fm/flatness/library/library_tab_right_inactive.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/dismiss_x_15x15.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/eq.2.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/error_big.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/error_small.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/header_bkg_rounded_568x50.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/icon_love_throb.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/large_form_field.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/paused.2.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_54x53_onhover.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_54x53_onpress.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_54x53_rest.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_ondark_23x22_onhover.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_ondark_23x22_onpress.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_ondark_23x22_rest.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_onlight_23x22_onhover.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_onlight_23x22_onpress.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/play_onlight_23x22_rest.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/see_more_arrow_blue_13x13.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/see_more_arrow_grey_15x15.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/spinner_cw.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/spinner_small.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/starter_gradient.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/status_info.gif"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/tag_20x20.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/userstationicons4.png"] = true
downloaded["cdn.lst.fm/flatness/listen_v2/yellow_alert_gradient.png"] = true
downloaded["cdn.lst.fm/flatness/messageboxes/error.png"] = true
downloaded["cdn.lst.fm/flatness/messageboxes/success.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/1/tab_mini_left.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/1/tab_mini_right.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/tab_active_left.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/tab_active_right.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/tab_left.png"] = true
downloaded["cdn.lst.fm/flatness/navigation/tab_right.png"] = true
downloaded["cdn.lst.fm/flatness/picture_frame.png"] = true
downloaded["cdn.lst.fm/flatness/picture_frame_medium.2.png"] = true
downloaded["cdn.lst.fm/flatness/playbutton/1/track_play_spotify.png"] = true
downloaded["cdn.lst.fm/flatness/playbutton/1/track_play_stop.png"] = true
downloaded["cdn.lst.fm/flatness/playbutton/loading_bar.gif"] = true
downloaded["cdn.lst.fm/flatness/preview/1/sprite.IE6.png"] = true
downloaded["cdn.lst.fm/flatness/preview/1/sprite.png"] = true
downloaded["cdn.lst.fm/flatness/promo/barbican/barbicanInfoBox2008_10-bg.png"] = true
downloaded["cdn.lst.fm/flatness/promo/motorokr/motorola_infobox-btn.gif"] = true
downloaded["cdn.lst.fm/flatness/promo/motorokr/motorola_infobox-logo.gif"] = true
downloaded["cdn.lst.fm/flatness/red_new_box.2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/11/flag_12.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/icons_12_colour_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/icons_14_sparse_dark_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/icons_14_sparse_light_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/icons_18_sparse_dark_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/icons_18_sparse_light_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_album_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_album_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_album_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_album_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_album_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_artist_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_artist_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_artist_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_artist_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_artist_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_group_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_group_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_group_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_group_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_group_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_label_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_label_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_label_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_label_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_label_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_track_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_track_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_track_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_track_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_track_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_user_140_g2.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_user_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_user_300_g4.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_user_40.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/noimage/default_user_60_g1.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/12/social_16_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/2/quote_sprite.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/arrow_right_30.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/footer/footer_as_light.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/footer/footer_icons_light.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/play_32.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/sparse/1/feedback_icons.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/sparse/1/feedback_icons_12.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/warning_220_g3.png"] = true
downloaded["cdn.lst.fm/flatness/responsive/warning_220_g3@2x.png"] = true
downloaded["cdn.lst.fm/flatness/scrobbleflip.png"] = true
downloaded["cdn.lst.fm/flatness/search/search_bg.png"] = true
downloaded["cdn.lst.fm/flatness/secondary_nav_bg.png"] = true
downloaded["cdn.lst.fm/flatness/shaders/60-vert-f2f2f2-cdcccc.gif"] = true
downloaded["cdn.lst.fm/flatness/sharebar/send.png"] = true
downloaded["cdn.lst.fm/flatness/spinner_16x16_000000_on_eeeeee.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_big.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_big_000000_on_eeeeee.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_big_000000_on_eef5fc.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_big_f2f2f2.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_big_ffffff.gif"] = true
downloaded["cdn.lst.fm/flatness/spinner_small.gif"] = true
downloaded["cdn.lst.fm/flatness/spinners/spinner_333333_aaaaaa.gif"] = true
downloaded["cdn.lst.fm/flatness/spinners/spinner_f2f2f2_000000.gif"] = true
downloaded["cdn.lst.fm/flatness/sprites/21/icons.IE6.png"] = true
downloaded["cdn.lst.fm/flatness/sprites/21/icons.png"] = true
downloaded["cdn.lst.fm/flatness/sprites/21/icons_32.png"] = true
downloaded["cdn.lst.fm/flatness/tag.gif"] = true
downloaded["cdn.lst.fm/flatness/ticket.png"] = true
downloaded["cdn.lst.fm/flatness/tooltip/tooltip-arrow.png"] = true
downloaded["cdn.lst.fm/flatness/track_small.gif"] = true
downloaded["cdn.lst.fm/flatness/video_small.gif"] = true
downloaded["cdn.lst.fm/promotions/close.png"] = true
downloaded["cdn.lst.fm/prototyping/bigplayer/big_tag.png"] = true
downloaded["cdn.lst.fm/prototyping/bigplayer/big_tag_empty.png"] = true
downloaded["cdn.lst.fm/prototyping/bigplayer/buttons_shiny_bkg_small3.png"] = true
downloaded["cdn.lst.fm/prototyping/bigplayer/imagespinner.gif"] = true
downloaded["cdn.lst.fm/prototyping/htmlplayer/player.png"] = true
downloaded["embed.spotify.com/static/css/mediabar/mediabar-lastfm.css"] = true
downloaded["embed.spotify.com/static/img/mediabar/big-throbber.gif"] = true
downloaded["embed.spotify.com/static/img/mediabar/mini-throbber.gif"] = true
downloaded["embed.spotify.com/static/img/mediabar/spotify-sprite.png"] = true
downloaded["embed.spotify.com/static/img/mediabar/sprite-v0.png"] = true
downloaded["ps.ns-cdn.com/dsatserving2/scripts/netseerads.js"] = true
downloaded["static.lst.fm/flatness/clear.gif"] = true
downloaded["www.last.fm/pngbehavior2.htc"] = true
downloaded["www.last.fm/static/css/css/231990/login/overview.secure.css"] = true
downloaded["www.last.fm/static/css/css/231990/master.secure.css"] = true
downloaded["www.last.fm/static/depth/buttons/journal_button_01.gif"] = true
downloaded["www.last.fm/static/depth/buttons/journal_button_02.gif"] = true
downloaded["www.last.fm/static/depth/charts/barchart_end.gif"] = true
downloaded["www.last.fm/static/depth/charts/barchart_fakeborder.gif"] = true
downloaded["www.last.fm/static/depth/charts/half-width_bg.gif"] = true
downloaded["www.last.fm/static/depth/charts/half-width_bg_hover.gif"] = true
downloaded["www.last.fm/static/depth/charts/inlinechart_fixed_bg.gif"] = true
downloaded["www.last.fm/static/depth/charts/inlinechart_fixed_bg_hover.gif"] = true
downloaded["www.last.fm/static/depth/charts/tagchart_end2.gif"] = true
downloaded["www.last.fm/static/depth/charts/tagchart_fakeborder.gif"] = true
downloaded["www.last.fm/static/depth/forms/incorrect_new.gif"] = true
downloaded["www.last.fm/static/depth/global/arrow_l.png"] = true
downloaded["www.last.fm/static/depth/global/arrow_l_anim.gif"] = true
downloaded["www.last.fm/static/depth/global/arrow_l_hover.png"] = true
downloaded["www.last.fm/static/depth/global/arrow_r.png"] = true
downloaded["www.last.fm/static/depth/global/arrow_r_anim.gif"] = true
downloaded["www.last.fm/static/depth/global/arrow_r_hover.png"] = true
downloaded["www.last.fm/static/depth/global/page_next.gif"] = true
downloaded["www.last.fm/static/depth/global/page_previous.gif"] = true
downloaded["www.last.fm/static/depth/global/progress.gif"] = true
downloaded["www.last.fm/static/depth/homepage_960/signupbutton.gif"] = true
downloaded["www.last.fm/static/depth/icons/addtoplaylist.gif"] = true
downloaded["www.last.fm/static/depth/icons/track_added.gif"] = true
downloaded["www.last.fm/static/flatness/buttons/3/is_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/4/is_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/4/is_left_loved.png"] = true
downloaded["www.last.fm/static/flatness/buttons/4/small_multi_white.png"] = true
downloaded["www.last.fm/static/flatness/buttons/5/button.png"] = true
downloaded["www.last.fm/static/flatness/buttons/5/confirm_button.png"] = true
downloaded["www.last.fm/static/flatness/buttons/5/confirm_button_blue.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/add_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/add_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/buy_dl_drp_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/buy_dl_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/buy_drp_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/buy_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/dl_drp_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/dl_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/rt_drp_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/6/small_multi.png"] = true
downloaded["www.last.fm/static/flatness/buttons/7/freedownload_large_bottom.png"] = true
downloaded["www.last.fm/static/flatness/buttons/7/freedownload_large_top.png"] = true
downloaded["www.last.fm/static/flatness/buttons/7/freedownload_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/7/freedownload_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/add.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/add_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_left_small.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_right_nodropdown.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_right_small.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/buy_right_small_nodropdown.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/grey_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/join_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/lightgrey_dropdown_right.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/more_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/share_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/8/tag_left.png"] = true
downloaded["www.last.fm/static/flatness/buttons/9/flex-arrows.png"] = true
downloaded["www.last.fm/static/flatness/buttons/9/multibuttonicons.png"] = true
downloaded["www.last.fm/static/flatness/buttons/delete.2.png"] = true
downloaded["www.last.fm/static/flatness/buttons/stationbutton/2/stationbutton-extended.png"] = true
downloaded["www.last.fm/static/flatness/buttons/stationbutton/7/stationbutton-large.png"] = true
downloaded["www.last.fm/static/flatness/buttons/stationbutton/8/stationbutton-large.png"] = true
downloaded["www.last.fm/static/flatness/buttons/stationbutton/8/stationbutton-medium.png"] = true
downloaded["www.last.fm/static/flatness/catalogue/album/jewelcase_large.png"] = true
downloaded["www.last.fm/static/flatness/catalogue/album/jewelcase_medium.png"] = true
downloaded["www.last.fm/static/flatness/catalogue/album/jewelcase_mega.png"] = true
downloaded["www.last.fm/static/flatness/catalogue/album/jewelcase_small.png"] = true
downloaded["www.last.fm/static/flatness/charts/2/openclose.png"] = true
downloaded["www.last.fm/static/flatness/charts/chartbar.png"] = true
downloaded["www.last.fm/static/flatness/charts/collapsiblebox-tab.gif"] = true
downloaded["www.last.fm/static/flatness/components/eventometer/bg.3.png"] = true
downloaded["www.last.fm/static/flatness/components/message/error.png"] = true
downloaded["www.last.fm/static/flatness/components/message/ok.png"] = true
downloaded["www.last.fm/static/flatness/components/tertiaryNavigation/medium_tab_left.png"] = true
downloaded["www.last.fm/static/flatness/components/tertiaryNavigation/medium_tab_left_inactive.png"] = true
downloaded["www.last.fm/static/flatness/components/tertiaryNavigation/medium_tab_right.png"] = true
downloaded["www.last.fm/static/flatness/components/tertiaryNavigation/medium_tab_right_inactive.png"] = true
downloaded["www.last.fm/static/flatness/favicon.2.ico"] = true
downloaded["www.last.fm/static/flatness/giant_success_tick.gif"] = true
downloaded["www.last.fm/static/flatness/giant_success_tick.png"] = true
downloaded["www.last.fm/static/flatness/global/icon_add_hover.gif"] = true
downloaded["www.last.fm/static/flatness/global/icon_eq.gif"] = true
downloaded["www.last.fm/static/flatness/global/user/icon_staff_m.png"] = true
downloaded["www.last.fm/static/flatness/grey-more-btn.gif"] = true
downloaded["www.last.fm/static/flatness/grids/fiflufi_right.5.png"] = true
downloaded["www.last.fm/static/flatness/grids/grid_48.15.png"] = true
downloaded["www.last.fm/static/flatness/header/lastfm_logo_black.png"] = true
downloaded["www.last.fm/static/flatness/header/lastfm_logo_black@2x.png"] = true
downloaded["www.last.fm/static/flatness/header/lastfm_logo_red.png"] = true
downloaded["www.last.fm/static/flatness/header/lastfm_logo_red@2x.png"] = true
downloaded["www.last.fm/static/flatness/headingwithnav/1/crumb-arrow.png"] = true
downloaded["www.last.fm/static/flatness/home/find_friends.png"] = true
downloaded["www.last.fm/static/flatness/home/setup_scrobbling.png"] = true
downloaded["www.last.fm/static/flatness/home/setup_scrobbling_wide.png"] = true
downloaded["www.last.fm/static/flatness/icons/see_more_arrow_blue_13x13_2.png"] = true
downloaded["www.last.fm/static/flatness/icons/tag/1/globaltag_left.png"] = true
downloaded["www.last.fm/static/flatness/icons/tag/1/globaltag_right.png"] = true
downloaded["www.last.fm/static/flatness/join/captcha/audio.png"] = true
downloaded["www.last.fm/static/flatness/join/captcha/help.png"] = true
downloaded["www.last.fm/static/flatness/join/captcha/refresh.png"] = true
downloaded["www.last.fm/static/flatness/join/captcha/text.png"] = true
downloaded["www.last.fm/static/flatness/labs/labs_12.png"] = true
downloaded["www.last.fm/static/flatness/listen_v2/error_big.png"] = true
downloaded["www.last.fm/static/flatness/listen_v2/play_ondark_23x22_onhover.png"] = true
downloaded["www.last.fm/static/flatness/listen_v2/play_ondark_23x22_rest.png"] = true
downloaded["www.last.fm/static/flatness/listen_v2/userstationicons4.png"] = true
downloaded["www.last.fm/static/flatness/messageboxes/error.png"] = true
downloaded["www.last.fm/static/flatness/messageboxes/success.png"] = true
downloaded["www.last.fm/static/flatness/navigation/1/tab_mini_left.png"] = true
downloaded["www.last.fm/static/flatness/navigation/1/tab_mini_right.png"] = true
downloaded["www.last.fm/static/flatness/navigation/tab_active_left.png"] = true
downloaded["www.last.fm/static/flatness/navigation/tab_active_right.png"] = true
downloaded["www.last.fm/static/flatness/navigation/tab_left.png"] = true
downloaded["www.last.fm/static/flatness/navigation/tab_right.png"] = true
downloaded["www.last.fm/static/flatness/picture_frame.png"] = true
downloaded["www.last.fm/static/flatness/picture_frame_medium.2.png"] = true
downloaded["www.last.fm/static/flatness/preview/1/sprite.IE6.png"] = true
downloaded["www.last.fm/static/flatness/preview/1/sprite.png"] = true
downloaded["www.last.fm/static/flatness/promo/barbican/barbicanInfoBox2008_10-bg.png"] = true
downloaded["www.last.fm/static/flatness/promo/motorokr/motorola_infobox-btn.gif"] = true
downloaded["www.last.fm/static/flatness/promo/motorokr/motorola_infobox-logo.gif"] = true
downloaded["www.last.fm/static/flatness/red_new_box.2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/icons_12_colour_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/icons_14_sparse_dark_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/icons_14_sparse_light_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/icons_18_sparse_dark_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/icons_18_sparse_light_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_album_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_album_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_album_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_album_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_album_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_artist_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_artist_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_artist_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_artist_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_artist_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_group_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_group_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_group_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_group_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_group_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_label_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_label_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_label_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_label_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_label_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_track_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_track_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_track_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_track_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_track_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_user_140_g2.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_user_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_user_300_g4.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_user_40.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/noimage/default_user_60_g1.png"] = true
downloaded["www.last.fm/static/flatness/responsive/12/social_16_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/2/quote_sprite.png"] = true
downloaded["www.last.fm/static/flatness/responsive/footer/footer_as_light.png"] = true
downloaded["www.last.fm/static/flatness/responsive/footer/footer_icons_light.png"] = true
downloaded["www.last.fm/static/flatness/responsive/play_32.png"] = true
downloaded["www.last.fm/static/flatness/responsive/sparse/1/feedback_icons.png"] = true
downloaded["www.last.fm/static/flatness/responsive/sparse/1/feedback_icons_12.png"] = true
downloaded["www.last.fm/static/flatness/responsive/warning_220_g3.png"] = true
downloaded["www.last.fm/static/flatness/responsive/warning_220_g3@2x.png"] = true
downloaded["www.last.fm/static/flatness/search/search_bg.png"] = true
downloaded["www.last.fm/static/flatness/secondary_nav_bg.png"] = true
downloaded["www.last.fm/static/flatness/shaders/60-vert-f2f2f2-cdcccc.gif"] = true
downloaded["www.last.fm/static/flatness/sharebar/send.png"] = true
downloaded["www.last.fm/static/flatness/spinner_16x16_000000_on_eeeeee.gif"] = true
downloaded["www.last.fm/static/flatness/spinner_big.gif"] = true
downloaded["www.last.fm/static/flatness/spinner_big_000000_on_eeeeee.gif"] = true
downloaded["www.last.fm/static/flatness/spinner_big_f2f2f2.gif"] = true
downloaded["www.last.fm/static/flatness/spinner_big_ffffff.gif"] = true
downloaded["www.last.fm/static/flatness/spinner_small.gif"] = true
downloaded["www.last.fm/static/flatness/spinners/spinner_333333_aaaaaa.gif"] = true
downloaded["www.last.fm/static/flatness/spinners/spinner_f2f2f2_000000.gif"] = true
downloaded["www.last.fm/static/flatness/sprites/21/icons.IE6.png"] = true
downloaded["www.last.fm/static/flatness/sprites/21/icons.png"] = true
downloaded["www.last.fm/static/flatness/sprites/21/icons_32.png"] = true
downloaded["www.last.fm/static/flatness/ticket.png"] = true
downloaded["www.last.fm/static/flatness/tooltip/tooltip-arrow.png"] = true
downloaded["www.last.fm/static/flatness/track_small.gif"] = true
downloaded["www.last.fm/static/flatness/video_small.gif"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/components.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/dialog.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/form/typeahead.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/LFM.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/lib/modernizr.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/lib/mustache-min.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/lib/requirejs/require-min.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/lib/sm2-min.js"] = true
downloaded["www.last.fm/static/javascript/javascript/232025/lib/uuid.js"] = true
downloaded["www.last.fm/static/opensearch.xml"] = true
downloaded["www.last.fm/static/promotions/close.png"] = true
downloaded["www.last.fm/static/prototyping/htmlplayer/player.png"] = true
downloaded["cdn.last.fm/flatness/global/icon_eq.gif"] = true
downloaded["cdn.last.fm/flatness/responsive/2/noimage/default_user_60_g1.png"] = true
downloaded["cdn.last.fm/flatness/global/icon_playlist.png"] = true

read_file = function(file)
  if file then
    local f = assert(io.open(file))
    local data = f:read("*all")
    f:close()
    return data
  else
    return ""
  end
end

line_num = function(linenum, filename)
  local num = 0
  for line in io.lines(filename) do
    num = num + 1
    if num == linenum then
      return line
    end
  end
end

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]
  
  if downloaded[string.match(url, "https?://(.+)")] == true or addedtolist[string.match(url, "https?://(.+)")] == true then
    return false
  end
  
  if (item_type == "forum" or item_type == "forumlang") and (downloaded[string.match(url, "https?://(.+)")] ~= true and addedtolist[string.match(url, "https?://(.+)")] ~= true) then
    if string.match(url, "/"..item_value.."[0-9][0-9]") then
      if (string.match(url, "https?://last%.[^/]+/") or string.match(url, "https?://lastfm%.[^/]+/") or string.match(url, "https?://[^%.]+%.lastfm%.[^/]+/") or string.match(url, "https?://[^%.]+%.last%.[^/]+/")) and not (string.match(url, "/"..item_value.."[0-9][0-9][0-9]")) then
        addedtolist[string.match(url, "https?://(.+)")] = true
        return true
      else
        return false
      end
    elseif html == 0 then
      addedtolist[string.match(url, "https?://(.+)")] = true
      return true
    else
      return false
    end
  elseif string.match(item_type, "user") and (downloaded[string.match(url, "https?://(.+)")] ~= true and addedtolist[string.match(url, "https?://(.+)")] ~= true) and not (string.match(url, "setlang=") or string.match(url, "%?from=[0-9]+") or string.match(url, "&from=[0-9]+") or string.match(url, "%%5C") or string.match(url, '"') or string.match(url, "dws%.cbsimg%.net") or string.match(url, "dw%.cbsimg%.net") or string.match(url, "userserve%-ak%.last%.fm/serve/126/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/126s/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/174s/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/174/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/34s/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/34/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/64s/[0-9]+%.") or string.match(url, "userserve%-ak%.last%.fm/serve/64/[0-9]+%.")) then
    if string.match(url, "[^A-Za-z0-9]"..item_value.."[^A-Za-z0-9]") or html == 0 or (string.match(url, "[^A-Za-z0-9]"..item_value) and not string.match(url, "[^A-Za-z0-9]"..item_value..".")) then
      if item_type == "useren" and (string.match(url, "audioscrobbler%.com") or string.match(url, "https?://last%.fm") or html == 0 or string.match(url, "https?://[^%.]+%.last%.fm")) and not string.match(url, "https?://cn%.last%.fm") then
        addedtolist[string.match(url, "https?://(.+)")] = true
        return true
      else
        return false
      end
    else
      return false
    end
  else
    return false
  end
end


wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil
  
  local function secondcheck(url)
    if string.match(url, "&amp;") then
      table.insert(urls, { url=string.gsub(url, "&amp;", "&") })
      addedtolist[string.match(string.gsub(url, "&amp;", "&"), "https?://(.+)")] = true
      addedtolist[string.match(url, "https?://(.+)")] = true
    else
      table.insert(urls, { url=url })
      addedtolist[string.match(url, "https?://(.+)")] = true
    end
  end
    
  
  local function check(url)
    if downloaded[string.match(url, "https?://(.+)")] ~= true and addedtolist[string.match(url, "https?://(.+)")] ~= true and not (string.match(url, "setlang=") or string.match(url, "%?from=[0-9]+") or string.match(url, "&from=[0-9]+") or string.match(url, "%%5C") or string.match(url, '"')) then
      if (string.match(item_type, "user") and (string.match(url, "[^A-Za-z0-9]"..item_value.."[^A-Za-z0-9]") or (string.match(url, "[^A-Za-z0-9]"..item_value) and not string.match(url, "[^A-Za-z0-9]"..item_value..".")))) or not string.match(item_type, "user") then
        if item_type == "useren" and (string.match(url, "audioscrobbler%.com") or string.match(url, "https?://last%.fm") or string.match(url, "https?://[^%.]+%.last%.fm")) and not string.match(url, "https?://cn%.last%.fm") then
          secondcheck(url)
        end
      end
    end
  end

--    if ((string.match(url, "https?://last%.[^/]+/") or string.match(url, "https?://lastfm%.[^/]+/") or string.match(url, "https?://[^%.]+%.lastfm%.[^/]+/") or string.match(url, "https?://[^%.]+%.last%.[^/]+/")) and (item_type == "forum" or )) and (downloaded[url] ~= true and addedtolist[url] ~= true) then
--      if (item_type == "user" and (string.match(url, "[^A-Za-z0-9]"..item_value.."[^A-Za-z0-9]") or (string.match(url, "[^A-Za-z0-9]"..item_value) and not string.match(url, "[^A-Za-z0-9]"..item_value..".")))) or item_type ~= "user" then
--        if string.match(url, "&amp;") then
--          table.insert(urls, { url=string.gsub(url, "&amp;", "&") })
--          addedtolist[string.gsub(url, "&amp;", "&")] = true
--          addedtolist[url] = true
--        else
--          table.insert(urls, { url=url })
--          addedtolist[url] = true
--        end
--      end
--    end
--  end
  
  if item_type == "forum" then
    if string.match(url, "/"..item_value) then
      html = read_file(file)
      for newurl in string.gmatch(html, '"(/[^"]+)"') do
        if string.match(newurl, "/[0-9]+/_/[0-9]+/_/[0-9]+") and string.match(newurl, "/"..item_value.."[0-9][0-9]/") then
          local newurl2 = string.match(newurl, "(/.+[0-9]+/_/[0-9]+)/_/")
          local newurl1 = "http://www.last.fm"..newurl2
          local newurl3 = "http://www.last.fm"..newurl
          local newurl4 = "http://www.last.fm"..newurl2.."/1"
          check(newurl1)
          check(newurl3)
          check(newurl4)
        elseif string.match(newurl, "/"..item_value.."[0-9][0-9]/") then
          local newurl1 = "http://www.last.fm"..newurl
          check(newurl1)
        end
      end
      if string.match(url, "[0-9]+/_/[0-9]+") then
        local newurl = string.match(url, "(https?://.+[0-9]+/_/[0-9]+)")
        check(newurl)
      end
      for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
        if string.match(newurl, "%.jpg") or string.match(newurl, "%.png") or string.match(newurl, "%.gif") or string.match(newurl, "%.js") or string.match(newurl, "%.css") then
          check(newurl)
        end
      end
    end
  elseif item_type == "forumlang" then
    if string.match(url, "/"..item_value) then
      html = read_file(file)
      for newurl in string.gmatch(html, '"(/[^"]+)"') do
        if string.match(newurl, "/[0-9]+/_/[0-9]+/_/[0-9]+") and string.match(newurl, "/"..item_value.."[0-9][0-9]/") then
          local newurl2 = string.match(newurl, "(/.+[0-9]+/_/[0-9]+)/_/")
          check("http://lastfm.de"..newurl2)
          check("http://lastfm.es"..newurl2)
          check("http://www.lastfm.fr"..newurl2)
          check("http://www.lastfm.it"..newurl2)
          check("http://www.lastfm.jp"..newurl2)
          check("http://www.lastfm.pl"..newurl2)
          check("http://www.lastfm.com.br"..newurl2)
          check("http://www.lastfm.ru"..newurl2)
          check("http://www.lastfm.se"..newurl2)
          check("http://www.lastfm.com.tr"..newurl2)
          check("http://cn.last.fm"..newurl2)
          check("http://www.lastfm.de"..newurl)
          check("http://www.lastfm.es"..newurl)
          check("http://www.lastfm.fr"..newurl)
          check("http://www.lastfm.it"..newurl)
          check("http://www.lastfm.jp"..newurl)
          check("http://www.lastfm.pl"..newurl)
          check("http://www.lastfm.com.br"..newurl)
          check("http://www.lastfm.ru"..newurl)
          check("http://www.lastfm.se"..newurl)
          check("http://www.lastfm.com.tr"..newurl)
          check("http://cn.last.fm"..newurl)
          check("http://www.lastfm.de"..newurl2.."/1")
          check("http://www.lastfm.es"..newurl2.."/1")
          check("http://www.lastfm.fr"..newurl2.."/1")
          check("http://www.lastfm.it"..newurl2.."/1")
          check("http://www.lastfm.jp"..newurl2.."/1")
          check("http://www.lastfm.pl"..newurl2.."/1")
          check("http://www.lastfm.com.br"..newurl2.."/1")
          check("http://www.lastfm.ru"..newurl2.."/1")
          check("http://www.lastfm.se"..newurl2.."/1")
          check("http://www.lastfm.com.tr"..newurl2.."/1")
          check("http://cn.last.fm"..newurl2.."/1")
        elseif string.match(newurl, "/"..item_value.."[0-9][0-9]/") then
          check("http://www.lastfm.de"..newurl)
          check("http://www.lastfm.es"..newurl)
          check("http://www.lastfm.fr"..newurl)
          check("http://www.lastfm.it"..newurl)
          check("http://www.lastfm.jp"..newurl)
          check("http://www.lastfm.pl"..newurl)
          check("http://www.lastfm.com.br"..newurl)
          check("http://www.lastfm.ru"..newurl)
          check("http://www.lastfm.se"..newurl)
          check("http://www.lastfm.com.tr"..newurl)
          check("http://cn.last.fm"..newurl)
        end
      end
      if string.match(url, "[0-9]+/_/[0-9]+") then
        local newurl = string.match(url, "(https?://.+[0-9]+/_/[0-9]+)")
        check(newurl)
      end
      for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
        if string.match(newurl, "%.jpg") or string.match(newurl, "%.png") or string.match(newurl, "%.gif") or string.match(newurl, "%.js") or string.match(newurl, "%.css") then
          check(newurl)
        end
      end
    end
  elseif item_type == "useren" then
    if string.match(url, "[^A-Za-z0-9]"..item_value.."[^A-Za-z0-9]") or (string.match(url, "[^A-Za-z0-9]"..item_value) and not string.match(url, "[^A-Za-z0-9]"..item_value..".")) then
      html = read_file(file)
      for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
        check(newurl)
      end
      for newurl in string.gmatch(html, "'(https?://[^']+)'") do
        check(newurl)
      end
      if string.match(url, "%?") then
        check(string.match(url, "(https?://[^%?]+)%?"))
      end
      for newurl in string.gmatch(html, '("/[^"]+)"') do
        if string.match(newurl, '"//') then
          check(string.gsub(newurl, '"//', 'http://'))
        else
          check(string.match(url, "(https?://[^/]+)/")..string.match(newurl, '"(.+)'))
        end
      end
    end
  end
  
  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  local status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()

  if item_type == "forum" or item_type == "forumlang" then
    return wget.actions.ABORT
  end
  
  if (status_code >= 200 and status_code <= 399) or status_code == 403 then
    if string.match(url.url, "https://") then
      local newurl = string.gsub(url.url, "https://", "http://")
      downloaded[string.match(newurl, "https?://(.+)")] = true
    else
      downloaded[string.match(url.url, "https?://(.+)")] = true
    end
  end

  if status_code == 302 or status_code == 301 then
    os.execute("python check302.py '"..url["url"].."'")
    if io.open("302file", "r") == nil then
      if string.match(url["url"], item_value) and (string.match(url["host"], "lastfm%.de") or string.match(url["host"], "lastfm%.es") or string.match(url["host"], "lastfm%.fr") or string.match(url["host"], "lastfm%.it") or string.match(url["host"], "lastfm%.jp") or string.match(url["host"], "lastfm%.pl") or string.match(url["host"], "lastfm%.com%.br") or string.match(url["host"], "lastfm%.ru") or string.match(url["host"], "lastfm%.se") or string.match(url["host"], "lastfm%.com%.tr") or string.match(url["host"], "last%.fm")) then
        io.stdout:write("Something went wrong!! ABORTING  \n")
        io.stdout:flush()
        return wget.actions.ABORT
      end
    end
    local redirfile = io.open("302file", "r")
    local fullfile = redirfile:read("*all")
    local numlinks = 0
    for newurl in string.gmatch(fullfile, "https?://") do
      numlinks = numlinks + 1
    end
    local foundurl = line_num(2, "302file")
    if numlinks > 1 then
      io.stdout:write("Found "..foundurl.." after redirect")
      io.stdout:flush()
      if downloaded[string.match(foundurl, "https?://(.+)")] == true or addedtolist[string.match(foundurl, "https?://(.+)")] == true then
        io.stdout:write(", this url has already been downloaded or added to the list to be downloaded, so it is skipped.  \n")
        io.stdout:flush()
        redirfile:close()
        os.remove("302file")
        return wget.actions.EXIT
      elseif not string.match(foundurl, "https?://") then
        if string.match(url["url"], item_value) and (string.match(url["host"], "lastfm%.de") or string.match(url["host"], "lastfm%.es") or string.match(url["host"], "lastfm%.fr") or string.match(url["host"], "lastfm%.it") or string.match(url["host"], "lastfm%.jp") or string.match(url["host"], "lastfm%.pl") or string.match(url["host"], "lastfm%.com%.br") or string.match(url["host"], "lastfm%.ru") or string.match(url["host"], "lastfm%.se") or string.match(url["host"], "lastfm%.com%.tr") or string.match(url["host"], "last%.fm")) then
          io.stdout:write("Something went wrong!! ABORTING  \n")
          io.stdout:flush()
          return wget.actions.ABORT
        end
      end
      redirfile:close()
      os.remove("302file")
      io.stdout:write(".  \n")
      io.stdout:flush()
    end
  end
  
  if status_code >= 500 or
    (status_code >= 400 and status_code ~= 404 and status_code ~= 403) then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 1")

    tries = tries + 1

    if tries >= 4 and string.match(url["url"], item_value) and (string.match(url["host"], "lastfm%.de") or string.match(url["host"], "lastfm%.es") or string.match(url["host"], "lastfm%.fr") or string.match(url["host"], "lastfm%.it") or string.match(url["host"], "lastfm%.jp") or string.match(url["host"], "lastfm%.pl") or string.match(url["host"], "lastfm%.com%.br") or string.match(url["host"], "lastfm%.ru") or string.match(url["host"], "lastfm%.se") or string.match(url["host"], "lastfm%.com%.tr") or string.match(url["host"], "last%.fm")) then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.ABORT
    elseif tries >= 4 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.EXIT
    else
      return wget.actions.CONTINUE
    end
  elseif status_code == 0 then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 10")
    
    tries = tries + 1

    if tries >= 4 and string.match(url["url"], item_value) and (string.match(url["host"], "lastfm%.de") or string.match(url["host"], "lastfm%.es") or string.match(url["host"], "lastfm%.fr") or string.match(url["host"], "lastfm%.it") or string.match(url["host"], "lastfm%.jp") or string.match(url["host"], "lastfm%.pl") or string.match(url["host"], "lastfm%.com%.br") or string.match(url["host"], "lastfm%.ru") or string.match(url["host"], "lastfm%.se") or string.match(url["host"], "lastfm%.com%.tr") or string.match(url["host"], "last%.fm")) then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.ABORT
    elseif tries >= 4 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.EXIT
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  -- We're okay; sleep a bit (if we have to) and continue
  -- local sleep_time = 0.1 * (math.random(75, 1000) / 100.0)
  local sleep_time = 0

  --  if string.match(url["host"], "cdn") or string.match(url["host"], "media") then
  --    -- We should be able to go fast on images since that's what a web browser does
  --    sleep_time = 0
  --  end

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end
