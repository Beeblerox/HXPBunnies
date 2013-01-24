package platformer.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.Image;
import nme.geom.Point;

/**
 * ...
 * @author Zaphod
 */

class BunnyImage extends Image
{
	public var velocity:Point;
	public var angularVelocity:Float;
	
	public function new(graphic:Dynamic) 
	{
		super(graphic);
		
		velocity = new Point();
		angularVelocity = 0;
	}
	
}