package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * Base Monster Class
	 * @author Evan Furchtgott
	 */
	public class Monster extends Mobile 
	{
		public static const NORMAL:int = 0;
		public static const FIRE:int = 1;
		public static const WATER:int = 2;
		
		public var state:int;
		
		public function Monster(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(level, x, y, graphic, mask);
			
			type = "monster";
			layer = 4;
			state = NORMAL;
		}
		
		public function onFire():void
		{
			
		}
		
		public function onWater():void
		{
			
		}
		
	}

}