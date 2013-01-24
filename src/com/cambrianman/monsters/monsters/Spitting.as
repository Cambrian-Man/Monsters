package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Spitting extends Monster 
	{
		[Embed(source = "../gfx/enemies/spitting_monster.png")] private const IMGSPITTING:Class;
		
		public function Spitting(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(level, x, y, new Image(IMGSPITTING), mask);
			type = "monster";
			width = 128;
			
			height = 32;
		}
		
		override public function update():void
		{
			if (facing == LEFT)
			{
				originX = 96;
				(graphic as Image).flipped = true;
			}
			else
			{
				originX = 0;
				(graphic as Image).flipped = false;
			}
			
			super.update();
		}
	}

}