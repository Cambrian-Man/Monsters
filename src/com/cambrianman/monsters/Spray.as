package com.cambrianman.monsters 
{
	import adobe.utils.CustomActions;
	import com.cambrianman.monsters.monsters.Monster;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Spray 
	{
		public var monster:Monster;
		public var sprayType:int;
		
		public function Spray(monster:Monster, type:int)
		{
			this.monster = monster;
			this.sprayType = type;
		}
		
	}

}