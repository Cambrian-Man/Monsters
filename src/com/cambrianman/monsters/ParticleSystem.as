package com.cambrianman.monsters 
{
	import com.cambrianman.monsters.monsters.Monster;
	import com.cambrianman.monsters.monsters.Spray;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.FP;
	import com.cambrianman.monsters.items.Item;
	import net.flashpunk.utils.Ease;
	
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
		private var sprays:Vector.<Spray>;
		private var sprayDelay:Number = 0.1;
		private var sprayTimer:Number = 0;
		
		public var level:Level;
		
		public function ParticleSystem() 
		{
			emitter = new Emitter(IMGSPARK, 8, 8);
			emitter.newType("burstFire", [0, 1, 2, 3]).setGravity(-0.5, -1).setMotion(0, 20, 0.1, 360, 5, 0.2);
			emitter.setSource(IMGSPLASH, 8, 8);
			emitter.newType("splashWater", [0, 1, 2, 3]).setGravity(0.5, 1).setMotion(0, 20, 0.1, 180, 5, 0.2);
			emitter.setSource(IMGSMOKE, 8, 8);
			emitter.newType("smokeFire", [0, 1, 2, 3]).setMotion(0, 48, 0.5, 360, 16, 0.5);
			emitter.newType("smokeLeft", [0, 1, 2, 3]).setMotion(170, 96, 0.5, 20, 8, 0, Ease.quadOut);
			emitter.newType("smokeRight", [0, 1, 2, 3]).setMotion(350, 96, 0.5, 20, 8, 0, Ease.quadOut);
			emitter.setSource(IMGMIST, 8, 8);
			emitter.newType("waterMist", [0, 1, 2, 3]).setMotion(0, 48, 0.5, 360, 16, 0.5);
			emitter.newType("mistLeft", [0, 1, 2, 3]).setMotion(170, 96, 0.5, 20, 8, 0, Ease.quadOut);
			emitter.newType("mistRight", [0, 1, 2, 3]).setMotion(350, 96, 0.5, 20, 8, 0, Ease.quadOut);
			
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
		
		public function clearSprays():void
		{
			if (sprays)
				level.removeList(sprays);
				
			sprays = new Vector.<Spray>();
		}
		
		public function startSpray(m:Monster, type:int):void
		{
			var _s:Spray = new Spray(m, type)
			sprays.push(_s);
			level.add(_s);
		}
		
		public function stopSpray(m:Monster):void
		{
			for (var i:int = 0; i < sprays.length; i++) 
			{
				if (sprays[i].monster == m)
				{
					level.remove(sprays[i]);
					sprays.splice(i, 1);
				}
			}
		}
		
		override public function update():void
		{
			if (sprayTimer < sprayDelay) {
				sprayTimer += FP.elapsed;
				return;
			}
			
			for (var i:int = 0; i < sprays.length; i++) 
			{
				if (sprays[i].sprayType == Item.FIRE)
				{
					if (sprays[i].monster.facing == Mobile.RIGHT)
						emitter.emit("smokeRight", sprays[i].monster.x + 32, sprays[i].monster.centerY);
					else
						emitter.emit("smokeLeft", sprays[i].monster.x, sprays[i].monster.centerY);
				}
				else if (sprays[i].sprayType == Item.WATER)
				{
					if (sprays[i].monster.facing == Mobile.RIGHT)
						emitter.emit("mistRight", sprays[i].monster.x + 32, sprays[i].monster.centerY);
					else
						emitter.emit("mistLeft", sprays[i].monster.x, sprays[i].monster.centerY);
				}
			}
			
			sprayTimer = 0;
		}
	}

}