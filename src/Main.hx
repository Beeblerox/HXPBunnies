import com.haxepunk.Engine;
import com.haxepunk.HXP;
import nme.display.FPS;
import nme.Lib;

class Main extends Engine
{

	override public function init()
	{
#if debug
	#if flash
		if (flash.system.Capabilities.isDebugger)
	#end
		{
			HXP.console.enable();
		}
#end
		HXP.world = new platformer.GameWorld();
		
		var fps:FPS = new FPS(10, 10, 0);
		var format = fps.defaultTextFormat;
		format.size = 20;
		fps.defaultTextFormat = format;
		Lib.current.stage.addChild(fps);
	}

	public static function main() { new Main(); }

}