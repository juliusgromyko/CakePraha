package ;

import openfl.Assets;

class CakePraha {

	// CURRENT LOCALE
	public static var locale(get,set):String;

	// IS RIGHT-TO-LEFT LOCALE
	public static var isRightToLeft(get,null):Bool;

	// FONT FAMILY
	public static var localeFont(get,null):String;

	// DEFAULT SEARCH PATHES TO LOCALIZATION FILES
	public static var paths:Array<String> = ["i18n","i18","localization","locales","lang","langs"];

	// LIST OF AVAILABLE LOCALES
	public static inline function getLocales():Array<String> { return  _locales; }

	// RETURN LOCALIZED STRING
	public static inline function getLine(name:String, ?keys:Array<String>):String
	{
		if(!_init) _loadLocale(locale);
		if(!_lines.exists(name)) return name;
		var line:String = _lines.get(name);

		if(keys!=null){
			var i:Int = 0;
			while (i < keys.length) {
				line=StringTools.replace(line,"%"+Std.string(i+1)+"%",keys[i]);
				i++;
			}
		}

		return line;
	}

	// Getters and setters for locale
	private static var _locale:String=_unifyLocaleName(flash.system.Capabilities.language);
	private static inline function set_locale(value:String):String
	{
		value = _unifyLocaleName(value);
		if(_localeAvailable(value)) if(_loadLocale(value)) _locale = value;
		return _locale;
	}
	private static inline function get_locale():String { return _locale; }

	private static var _isRightToLeft:Bool = false;
	private static inline function get_isRightToLeft():Bool { return _isRightToLeft; }
	
	private static var _localeFont:String = "";
	private static inline function get_localeFont():String { return _localeFont; }

	// Available locales
	private static var _locales:Array<String>=[];

	// Check if locale are available
	private static function _localeAvailable(locale:String):Bool
	{
		if(_locales.indexOf(locale)>=0) return true;

		for(s in paths){
			if(Assets.exists("assets/"+s+"/"+locale+".csv") || Assets.exists("assets/"+s+"/"+locale+".txt") || Assets.exists("assets/"+s+"/"+locale))
			{
				_locales.push(locale);
				return true;
			}
		}

		return false;
	}

	// Loading localization strings
	private static function _loadLocale(locale:String):Bool
	{
		var localePath:String = "";

		for(s in paths){
			if(Assets.exists("assets/"+s+"/"+locale+".csv")) localePath = "assets/"+s+"/"+locale+".csv";
			if(Assets.exists("assets/"+s+"/"+locale+".txt")) localePath = "assets/"+s+"/"+locale+".txt";
			if(Assets.exists("assets/"+s+"/"+locale)) localePath = "assets/"+s+"/"+locale;
		}

		if(localePath=="") return false;

		// Reset locale settings
		_isRightToLeft = false;
		_localeFont = "";

		for(line in openfl.Assets.getText(localePath).split("\n"))
		{
			line=StringTools.replace(line,"\" , \"","\n");
			line=StringTools.replace(line,"\" ,\"","\n");
			line=StringTools.replace(line,"\", \"","\n");
			line=StringTools.replace(line,"\",\"","\n");
			var subline:Array<String> = line.split("\n");
			if(subline.length==2)
			{
				var key:String = subline[0].toLowerCase().substring(subline[0].indexOf("\"")+1);
				var value:String = subline[1].substring(0,subline[1].lastIndexOf("\""));

				value = StringTools.replace(value,"\\n","\n");
				value = StringTools.replace(value,"\\\"","\"");
				value = StringTools.replace(value,"\\\\","\\");

				// Check if there is locale settings
				var lValue = StringTools.trim(value.toLowerCase());
				if(key=="%righttoleft" && (lValue=="yes" || lValue=="true")){
					_isRightToLeft = true;
				}else if(key=="%font" && (lValue!="no" && lValue!="nil" && lValue!="null" && lValue!="false" && lValue!="")){
					_localeFont = lValue;
				}else{
					_lines.set(key,value);
				}
			}
		}

		_init = true;
		return true;
	};

	// Localization strings
	private static var _lines:haxe.ds.StringMap<String> = new haxe.ds.StringMap<String>();

	// Unify locale name
	private static function _unifyLocaleName(locale:String):String { return locale.toLowerCase().substring(0,2); }

	// Is default locale initialized?
	private static var _init:Bool=false;

}