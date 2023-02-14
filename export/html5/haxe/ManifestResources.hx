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

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR2i4947800R3y5:MUSICR5y47:assets%2Fmusic%2Fsuspense_dark_ambient_8413.mp3y9:pathGroupaR8hR6tgoR0y34:assets%2Fmusic%2Fmusic_website.txtR2i26R3R4R5R10R6tgoR0y33:assets%2Fimages%2Forange_tile.pngR2i429R3y5:IMAGER5R11R6tgoR0y35:assets%2Fimages%2Fquestion_mark.pngR2i210R3R12R5R13R6tgoR0y23:assets%2Fimages%2Fx.pngR2i300R3R12R5R14R6tgoR0y38:assets%2Fimages%2Flight_brown_tile.pngR2i377R3R12R5R15R6tgoR0y31:assets%2Fimages%2Fpink_tile.pngR2i404R3R12R5R16R6tgoR0y37:assets%2Fimages%2Fmenu_background.pngR2i26269R3R12R5R17R6tgoR0y32:assets%2Fimages%2Fbackground.pngR2i30528R3R12R5R18R6tgoR0y37:assets%2Fimages%2Fflooring_tile_1.pngR2i484R3R12R5R19R6tgoR0y32:assets%2Fimages%2Fbrown_tile.pngR2i434R3R12R5R20R6tgoR0y37:assets%2Fimages%2Fflooring_tile_2.pngR2i409R3R12R5R21R6tgoR0y37:assets%2Fimages%2Fflooring_tile_3.pngR2i478R3R12R5R22R6tgoR0y35:assets%2Fimages%2Fdark_red_tile.pngR2i424R3R12R5R23R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R24R6tgoR0y31:assets%2Fimages%2Flightbulb.pngR2i281R3R12R5R25R6tgoR2i250230R3y5:SOUNDR5y37:assets%2Fsounds%2Flightswitch_off.wavR9aR27hR6tgoR0y43:assets%2Fsounds%2FNew%20Text%20Document.txtR2i39R3R4R5R28R6tgoR2i537842R3R26R5y33:assets%2Fsounds%2Fmatch_light.wavR9aR29hR6tgoR2i198730R3R26R5y36:assets%2Fsounds%2Flightswitch_on.wavR9aR30hR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R31R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R32R6tgoR2i39706R3R7R5y28:flixel%2Fsounds%2Fflixel.mp3R9aR33y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R7R5y26:flixel%2Fsounds%2Fbeep.mp3R9aR35y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i5794R3R26R5R36R9aR35R36hgoR2i33629R3R26R5R34R9aR33R34hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R37R38y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R12R5R43R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R12R5R44R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_suspense_dark_ambient_8413_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_website_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_orange_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_question_mark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_x_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_light_brown_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_pink_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menu_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_background_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_brown_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_dark_red_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_lightbulb_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_off_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_new_text_document_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_match_light_wav extends null { }
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

@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/suspense_dark_ambient_8413.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_suspense_dark_ambient_8413_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/music_website.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_website_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/orange_tile.png") @:noCompletion #if display private #end class __ASSET__assets_images_orange_tile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/question_mark.png") @:noCompletion #if display private #end class __ASSET__assets_images_question_mark_png extends lime.graphics.Image {}
@:keep @:image("assets/images/x.png") @:noCompletion #if display private #end class __ASSET__assets_images_x_png extends lime.graphics.Image {}
@:keep @:image("assets/images/light_brown_tile.png") @:noCompletion #if display private #end class __ASSET__assets_images_light_brown_tile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/pink_tile.png") @:noCompletion #if display private #end class __ASSET__assets_images_pink_tile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/menu_background.png") @:noCompletion #if display private #end class __ASSET__assets_images_menu_background_png extends lime.graphics.Image {}
@:keep @:image("assets/images/background.png") @:noCompletion #if display private #end class __ASSET__assets_images_background_png extends lime.graphics.Image {}
@:keep @:image("assets/images/flooring_tile_1.png") @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_1_png extends lime.graphics.Image {}
@:keep @:image("assets/images/brown_tile.png") @:noCompletion #if display private #end class __ASSET__assets_images_brown_tile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/flooring_tile_2.png") @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_2_png extends lime.graphics.Image {}
@:keep @:image("assets/images/flooring_tile_3.png") @:noCompletion #if display private #end class __ASSET__assets_images_flooring_tile_3_png extends lime.graphics.Image {}
@:keep @:image("assets/images/dark_red_tile.png") @:noCompletion #if display private #end class __ASSET__assets_images_dark_red_tile_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/lightbulb.png") @:noCompletion #if display private #end class __ASSET__assets_images_lightbulb_png extends lime.graphics.Image {}
@:keep @:file("assets/sounds/lightswitch_off.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_lightswitch_off_wav extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/New Text Document.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_new_text_document_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/match_light.wav") @:noCompletion #if display private #end class __ASSET__assets_sounds_match_light_wav extends haxe.io.Bytes {}
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