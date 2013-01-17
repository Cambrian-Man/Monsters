package com.cambrianman.monsters.environment 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class FireRoot extends Root
	{
		[Embed(source = "../gfx/environment/fire_root.png")] private const IMGFIREROOT:Class;
		
		public function FireRoot(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, new Image(IMGFIREROOT), mask);
			
		}
		
		override protected function drip():void
		{
			level.spawnSeed(this, Item.FIREDROP);
		}
	}

}