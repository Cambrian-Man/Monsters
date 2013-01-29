package com.cambrianman.monsters.environment 
{
	import com.cambrianman.monsters.Level;
	import com.cambrianman.monsters.RepeatTimer;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import com.cambrianman.monsters.items.Item;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Root extends Entity 
	{
		private var timer:RepeatTimer;
		
		public var level:Level;
		
		public function Root(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			timer = new RepeatTimer(3, drip);
			layer = 5;
		}
		
		override public function update():void
		{
			super.update();
			timer.update();
		}
		
		protected function drip():void
		{
			
		}
		
	}

}