package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Block extends Monster 
	{
		
		public function Block(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(level, x, y, graphic, mask);
			beNormal();
		}
		
		override public function onFire():void
		{
			
		}
		
		override public function onWater():void
		{
			if (state == FIRE)
			{
				onFire();
				return;
			}
			else if (state == WATER)
				return;
				
			width = 32;
			height = 48;
			pushable = true;
		}
		
		private function beNormal():void
		{
			width = 16;
			height = 16;
			state = NORMAL;
			pushable = true;
		}
	}

}