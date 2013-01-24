package com.cambrianman.monsters.monsters 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.Player;
	import com.cambrianman.monsters.items.Item;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * Base Monster Class
	 * @author Evan Furchtgott
	 */
	public class Monster extends Mobile 
	{
		public static const FIRE:int = 0;
		public static const NORMAL:int = 1;
		public static const WATER:int = 2;
		
		public var facing:int;
		
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
			level.particles.smokeAt(centerX, centerY, Item.FIRE);
			if (state != FIRE)
				state -= 1;
		}
		
		public function onWater():void
		{
			level.particles.smokeAt(centerX, centerY, Item.WATER);
			
			if (state != WATER)
				state += 1;
		}
		
		public function setState(state:String):void
		{
			if (state == "water") 
				this.state = Monster.WATER;
			else if (state == "fire") 
				this.state = Monster.FIRE;
			else 
				this.state = Monster.NORMAL;
		}
	}

}