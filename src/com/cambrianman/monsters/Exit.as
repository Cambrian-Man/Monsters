package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	
	/**
	 * Exit entity which triggers a board change.
	 * @author Evan Furchtgott
	 */
	public class Exit extends Entity 
	{
		// The board that this exit leads to.
		public var to:Class;
		
		// Which entrance on the next board the player should arrive at.
		public var entrance:String;
		
		// Which side we can approach the exit from. If the player is
		// facing the opposite direction, we can enter.
		public var from:int;
		
		public function Exit(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) 
		{
			type = "exit";
			visible = true;
			this.width = width;
			this.height = height;
			super(x, y);
		}
		
	}

}