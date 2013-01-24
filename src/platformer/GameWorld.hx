package platformer;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.masks.Grid;
import com.haxepunk.utils.Input;
import com.haxepunk.World;
import nme.Lib;
import platformer.entities.Bunny;

class GameWorld extends World
{
	public var minX:Int;
	public var minY:Int;
	public var maxX:Int;
	public var maxY:Int;
	
	private var backdrop:Backdrop;
	private var pirate:Image;
	private var gravity:Float;
	private var incBunnies:Int;
	private var atlas:TextureAtlas;
	private var numBunnies:Int;
	
	private var bunnies:Array<BunnyImage>;
	private var bunnyImage:BunnyImage;
	private var bunny:Entity;
	private var bunnyList:Graphiclist;
	
	private var tapTime:Float;
	private var overlayText:Text;

	public function new()
	{
		super();
		
		gravity = 5;
		#if flash
		incBunnies = 50;
		#else
		incBunnies = 1000;
		#end
		
		numBunnies = incBunnies;
		
		minX = minY = 0;
		maxX = HXP.width;
		maxY = HXP.height;
		
		tapTime = 0;

#if !flash
		atlas = TextureAtlas.loadTexturePacker("atlas/assets.xml");
#end
	}

	public override function begin()
	{
		// background
		backdrop = new Backdrop(#if flash "gfx/grass.png" #else atlas.getRegion("grass.png") #end, true, true);
		addGraphic(backdrop);
		
		// bunnies
		bunnies = [];
		bunny = new Entity();
		bunnyList = new Graphiclist([]);
		bunny.graphic = bunnyList;
		addBunnies(numBunnies);
		add(bunny);
		
		// and some big pirate
		pirate = new Image(#if flash "gfx/pirate.png" #else atlas.getRegion("pirate.png") #end);
		addGraphic(pirate);
		
		overlayText = new Text("numBunnies = " + numBunnies, 0, 0, 0, 0, { color:0x000000, size:30 } );
		overlayText.resizable = true;
		var overlay:Entity = new Entity(0, HXP.screen.height - 40, overlayText);
		//overlay.layer = 0;
		add(overlay);
	}
	
	private function addBunnies(numToAdd:Int):Void
	{
		for (i in 0...(numToAdd))
		{
			bunnyImage = new BunnyImage(#if flash "gfx/wabbit_alpha.png" #else atlas.getRegion("bunny.png") #end);
			bunnyImage.x = HXP.width * Math.random();
			bunnyImage.y = HXP.height * Math.random();
			bunnyImage.velocity.x = 50 * (Math.random() * 5) * (Math.random() < 0.5 ? 1 : -1);
			bunnyImage.velocity.y = 50 * ((Math.random() * 5) - 2.5) * (Math.random() < 0.5 ? 1 : -1);
			bunnyImage.angle = 15 - Math.random() * 30;
			bunnyImage.angularVelocity = 30 * (Math.random() * 5) * (Math.random() < 0.5 ? 1 : -1);
			bunnyImage.scale = bunnyImage.scaleX = bunnyImage.scaleY = 0.3 + Math.random();
			bunnyList.add(bunnyImage);
			bunnies.push(bunnyImage);
		}
		
		numBunnies = bunnies.length;
	}

	public override function update()
	{
		var t = Lib.getTimer();
		pirate.x = Std.int((HXP.width - pirate.width) * (0.5 + 0.5 * Math.sin(t / 3000)));
		pirate.y = Std.int(HXP.height - 1.3 * pirate.height + 70 - 30 * Math.sin(t / 100));
		
		var elapsed:Float = HXP.elapsed;
		
		for (i in 0...(numBunnies))
		{
			bunnyImage = bunnies[i];
			bunnyImage.x += bunnyImage.velocity.x * elapsed;
			bunnyImage.velocity.y = gravity * elapsed;
			bunnyImage.y += bunnyImage.velocity.y * elapsed;
			bunnyImage.angle += bunnyImage.angularVelocity * elapsed;
			bunnyImage.alpha = 0.3 + 0.7 * bunnyImage.y / maxY;
			
			if (bunnyImage.x > maxX)
			{
				bunnyImage.velocity.x *= -1;
				bunnyImage.x = maxX;
			}
			else if (bunnyImage.x < minX)
			{
				bunnyImage.velocity.x *= -1;
				bunnyImage.x = minX;
			}
			if (bunnyImage.y > maxY)
			{
				bunnyImage.velocity.y *= -0.8;
				bunnyImage.y = maxY;
				if (Math.random() > 0.5) bunnyImage.velocity.y -= 3 + Math.random() * 4;
			}
			else if (bunnyImage.y < minY)
			{
				bunnyImage.velocity.y *= -0.8;
				bunnyImage.y = minY;
			}
		}
		
		tapTime -= HXP.elapsed;
		if (Input.mousePressed)
		{
			if (tapTime > 0)
			{
				addSomeBunnies();
			}
			tapTime = 0.6;
		}
		
		super.update();
	}

	private function addSomeBunnies():Void
	{
		if (numBunnies >= 1500) 
		{
			incBunnies = 250;
		}
		var more:Int = numBunnies + incBunnies;
		addBunnies(more - numBunnies);
		overlayText.text = "numBunnies = " + numBunnies;
	}
}