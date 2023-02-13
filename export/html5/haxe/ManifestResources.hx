package;

import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:sizei5542138y4:typey5:MUSICy2:idy46:assets%2Fmusic%2Fthe-beat-of-nature-122841.mp3y9:pathGroupaR4hy7:preloadtgoR0i5680065R1R2R3y55:assets%2Fmusic%2Fcinematic-atmosphere-score-2-22136.mp3R5aR7hR6tgoR0i4947800R1R2R3y47:assets%2Fmusic%2Fsuspense-dark-ambient-8413.mp3R5aR8hR6tgoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txtR0zR1y4:TEXTR3R10R6tgoR0i6684839R1R2R3y41:assets%2Fmusic%2Fmountain-path-125573.mp3R5aR12hR6tgoR0i6495921R1R2R3y40:assets%2Fmusic%2Fcaves-of-dawn-10376.mp3R5aR13hR6tgoR9y34:assets%2Fmusic%2Fmusic_website.txtR0i26R1R11R3R14R6tgoR0i4711235R1R2R3y38:assets%2Fmusic%2Flofi-study-112191.mp3R5aR15hR6tgoR9y23:assets%2Fimages%2Fx.pngR0i302R1y5:IMAGER3R16R6tgoR9y37:assets%2Fimages%2Fmenu_background.pngR0i26434R1R17R3R18R6tgoR9y32:assets%2Fimages%2Fbackground.pngR0i30528R1R17R3R19R6tgoR9y36:assets%2Fimages%2Fimages-go-here.txtR0zR1R11R3R20R6tgoR9y31:assets%2Fimages%2Flightbulb.pngR0i320R1R17R3R21R6tgoR0i250230R1y5:SOUNDR3y37:assets%2Fsounds%2Flightswitch_off.wavR5aR23hR6tgoR9y43:assets%2Fsounds%2FNew%20Text%20Document.txtR0i39R1R11R3R24R6tgoR0i198730R1R22R3y36:assets%2Fsounds%2Flightswitch_on.wavR5aR25hR6tgoR9y36:assets%2Fsounds%2Fsounds-go-here.txtR0zR1R11R3R26R6tgoR9y34:assets%2Fdata%2Fdata-goes-here.txtR0zR1R11R3R27R6tgoR0i39706R1R2R3y28:flixel%2Fsounds%2Fflixel.mp3R5aR28y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR0i2114R1R2R3y26:flixel%2Fsounds%2Fbeep.mp3R5aR30y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR0i5794R1R22R3R31R5aR30R31hgoR0i33629R1R22R3R29R5aR28R29hgoR0i15744R1y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR3y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR0i29724R1R32R33y36:__ASSET__flixel_fonts_monsterrat_ttfR3y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR9y33:flixel%2Fimages%2Fui%2Fbutton.pngR0i519R1R17R3R38R6tgoR9y36:flixel%2Fimages%2Flogo%2Fdefault.pngR0i3280R1R17R3R39R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_the_beat_of_nature_122841_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_cinematic_atmosphere_score_2_22136_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_suspense_dark_ambient_8413_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_mountain_path_125573_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_caves_of_dawn_10376_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_website_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_lofi_study_112191_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_x_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menu_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_lightbulb_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_off_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_new_text_document_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_on_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/music/the-beat-of-nature-122841.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_the_beat_of_nature_122841_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/cinematic-atmosphere-score-2-22136.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_cinematic_atmosphere_score_2_22136_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/suspense-dark-ambient-8413.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_suspense_dark_ambient_8413_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/mountain-path-125573.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_mountain_path_125573_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/caves-of-dawn-10376.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_caves_of_dawn_10376_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/music_website.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_website_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/lofi-study-112191.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_lofi_study_112191_mp3 extends haxe.io.Bytes {}
@:keep @:image("assets/images/x.png") @:noCompletion #if display private #end class __ASSET__assets_images_x_png extends lime.graphics.Image {}
@:keep @:image("assets/images/menu_background.png") @:noCompletion #if display private #end class __ASSET__assets_images_menu_background_png extends lime.graphics.Image {}
@:keep @:image("assets/images/background.png") @:noCompletion #if display private #end class __ASSET__assets_images_background_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/lightbulb.png") @:noCompletion #if display private #end class __ASSET__assets_images_lightbulb_png extends lime.graphics.Image {}
@:keep @:file("assets/sounds/lightswitch_off.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_off_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/New Text Document.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_new_text_document_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/lightswitch_on.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_on_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/5,1,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end

#end