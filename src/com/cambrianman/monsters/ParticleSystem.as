package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.FP;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class ParticleSystem extends Entity 
	{
		[Embed(source = "gfx/effects/fire_spark.png")] private var IMGSPARK:Class;
		[Embed(source = "gfx/effects/water_splash.png")] private var IMGSPLASH:Class;
		[Embed(source = "gfx/effects/fire_smoke.png")] private var IMGSMOKE:Class;
		[Embed(source = "gfx/effects/water_mist.png")] private var IMGMIST:Class;
		
		private var emitter:Emitter;
		
		public function ParticleSystem() 
		{
			emitter = new Emitter(IMGSPARK, 8, 8);
			emitter.newType("burstFire", [0, 1, 2, 3]).setGravity(-0.5, -1).setMotion(0, 20, 0.1, 360, 5, 0.2);
			emitter.setSource(IMGSPLASH, 8, 8);
			emitter.newType("splashWater", [0, 1, 2, 3]).setGravity(0.5, 1).setMotion(0, 20, 0.1, 180, 5, 0.2);
			emitter.setSource(IMGSMOKE, 8, 8);
			emitter.newType("smokeFire", [0, 1, 2, 3]).setMotion(0, 48, 0.5, 360, 16, 0.5);
			emitter.setSource(IMGMIST, 8, 8);
			emitter.newType("waterMist", [0, 1, 2, 3]).setMotion(0, 48, 0.5, 360, 16, 0.5);
			
			super(0, 0, emitter);
		}
		
		public function burstAt(x:Number, y:Number, type:int):void
		{		
			for (var i:int = 0; i < 5; i++) 
			{
				if (type == Item.FIRE)
					emitter.emit("burstFire", x, y);
				else if (type == Item.WATER)
					emitter.emit("splashWater", x, y);
			}	
		}
		
		public function smokeAt(x:Number, y:Number, type:int):void
		{
			for (var i:int = 0; i < 20; i++) 
			{
				if (type == Item.FIRE)
					emitter.emit("smokeFire", x, y);
				else if (type == Item.WATER)
					emitter.emit("waterMist", x, y);
			}
		}
		
	}

}