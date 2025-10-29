package backend;

import haxe.macro.Compiler.getDefine;

class SystemStuff {
	public static var haxeVersion(get, never):Null<String>;
	public static function get_haxeVersion():Null<String> {
		return cast(getDefine("haxe"), Null<String>);
	}

	public static var openflVersion(get, never):Null<String>;
	public static function get_openflVersion():Null<String> {
		return cast(getDefine("openfl"), Null<String>);
	}

	public static var limeVersion(get, never):Null<String>;
	public static function get_limeVersion():Null<String> {
		return cast(getDefine("lime"), Null<String>);
	}

	public static var flixelVersion(get, never):Null<String>;
	public static function get_flixelVersion():Null<String> {
		return Std.string(FlxG.VERSION);
	}
}