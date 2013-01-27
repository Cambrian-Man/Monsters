package com.cambrianman.monsters.monsters 
{
	import adobe.utils.CustomActions;
	import com.cambrianman.monsters.monsters.Monster;
	import com.cambrianman.monsters.Mobile;
	import com.cambrianman.monsters.items.Item;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Spray extends Entity
	{
		public var monster:Monster;
		public var sprayType:int;
		
		private var collidables:Array = ["monster", "backgroundMonster"];
		
		private var collided:Array;
		
		public function Spray(monster:Monster, sprayType:int)
		{
			this.monster = monster;
			this.sprayType = sprayType;
			
			super();
			
			type = "spray";
			width = 96;
			height = 32;
			
			y = monster.y;
			
			if (monster.facing == Mobile.RIGHT)
				x = monster.right;
			else if (monster.facing == Mobile.LEFT)
				x = monster.x - width;
				
			collided = new Array();
		}
		
		override public function update():void
		{
			super.update();
			
			collideTypesInto(collidables, x, y, collided);
			
			for (var i:int = 0; i < collided.length; i++) 
			{
				if (sprayType == Item.FIRE)
					(collided[i] as Monster).onFire();
				else if (sprayType == Item.WATER)
					(collided[i] as Monster).onWater();
					
				if (collided[i] is Balloon)
				{
					var _b:Balloon = collided[i] as Balloon;
					_b.speed.x = 1;
					
					if (monster.facing == Mobile.LEFT)
						_b.speed.x *= -1;
				}
				else if (collided[i] is Block)
				{
					(collided[i] as Block).push(monster.facing, 1);
				}
			}
			
			collided.length = 0;
		}
		
	}

}