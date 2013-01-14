package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * Mobile class, basically replicates the Flixel Sprite class, giving us
	 * speed, acceleration, drag, etc.
	 * @author Evan Furchtgott
	 */
	public class Mobile extends Entity 
	{
		// The speed of the sprite, a vector meaning the number of pixels to move per frame.
		public var speed:Point = new Point();
		
		// The maximum speed that we can move per frame.
		public var maxSpeed:Point = new Point();
		
		// An increase to the speed per frame.
		public var acceleration:Point = new Point();
		
		// Basic drag, a reduction in speed per frame.
		public var drag:Point = new Point();
		
		// Reference to the current level, for convenience.
		protected var level:Level;
		
		// Constants referring to various facing directions.
		public static const LEFT:int = 0;
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		
		// An array of strings relating to types that
		// the mobile should collide with.
		public var collidables:Array;
		
		/**
		 * Constructor
		 * @param	level		A reference to the current level.
		 * @param	x
		 * @param	y
		 * @param	graphic
		 * @param	mask
		 */
		public function Mobile(level:Level, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			this.level = level;
			collidables = ["ground"];
			super(x, y, graphic, mask);
		}
		
		override public function update():void
		{
			var absX:Number = Math.abs(speed.x);
			var absY:Number = Math.abs(speed.y);

			speed.x = speed.x + acceleration.x;
			speed.x = FP.clamp(speed.x, (maxSpeed.x * -1), maxSpeed.x);
			
			speed.y = speed.y + acceleration.y;
			speed.y = FP.clamp(speed.y, (maxSpeed.y * -1), maxSpeed.y);
			
			if (absX > 0)
			{
				if (absX < drag.x)
					speed.x = 0;
				else
					speed.x = speed.x - (drag.x * FP.sign(speed.x));
			}
			
			if (absY > 0)
			{
				if (absY < drag.y)
					speed.y = 0;
				else
					speed.y = speed.y + (drag.y * FP.sign(speed.y));
			}
			
			moveBy(speed.x, speed.y, collidables, false);
			
			super.update();
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			speed.x = 0;
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			speed.y = 0;
			return true;
		}
		
		/**
		 * Called when the mobile takes damage.
		 * @param	entity		The entity that damaged it.
		 * @param	direction	The direction that it took damage from.
		 */
		public function damage(entity:Entity, direction:int = 0):void
		{
			
		}
	}

}