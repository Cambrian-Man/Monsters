package com.cambrianman.monsters.environment 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	import com.cambrianman.monsters.Level;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class WaterPlant extends Entity 
	{
		[Embed(source = "../gfx/environment/fire_plant.png")] private const IMGPLANT:Class;
		
		public function WaterPlant(x:Number=0, y:Number=0) 
		{
			layer = 4;
			type = "spawner";
			super(x, y, new Image(IMGPLANT));
		}
		
	}

}