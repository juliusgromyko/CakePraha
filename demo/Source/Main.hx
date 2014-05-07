package;


import flash.display.Sprite;


class Main extends Sprite {
	
	
	public function new () {		
		super ();

		trace("System locale: "+CakePraha.locale);
		trace("Available locales: "+CakePraha.getLocales());
		CakePraha.locale="Eng";
		trace("Now switched to locale: "+CakePraha.locale);
		trace("Sample string 1: "+CakePraha.getLine("test",["world!","Yep!"]));
		trace("Sample string 2: "+CakePraha.getLine("good",["Dorif","Nice!"]));
		trace("Is right to left locale: "+CakePraha.isRightToLeft);
		trace("Specific font for this locale: "+CakePraha.localeFont);
	}
	
}