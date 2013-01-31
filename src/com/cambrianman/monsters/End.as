package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Data;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class End extends World 
	{
		[Embed(source = "gfx/end_screen.png")] private const IMGEND1:Class;
		[Embed(source = "gfx/end_screen2.png")]private const IMGEND2:Class;
		[Embed(source = "gfx/end_player.png")] private const IMGPLAYEREND:Class;
		
		private var background:Entity;
		private var player:Entity;
		private var text:Entity;
		
		private var alarm1:Alarm;
		private var alarm2:Alarm;
		private var alarm3:Alarm;
		
		private var resettable:Boolean = false;
		
		public function End() 
		{	
			background = new Entity(0, 0, new Image(IMGEND1));
			add(background);
			
			player = new Entity(112, 160, new Spritemap(IMGPLAYEREND, 32, 32));
			add(player);
			
			text = new Entity(80, 64, new Text("The End"));
			text.visible = false;
			add(text);
			
			alarm1 = new Alarm(3, sunrise);
			addTween(alarm1, true);
		}
		
		override public function update():void
		{
			if (resettable)
			{
				if (Input.pressed(Key.ANY))
				{
					FP.world = new Menu();
				}
			}
		}
		
		private function sunrise():void
		{
			background.graphic = new Image(IMGEND2);
			alarm2 = new Alarm(0.5, turn);
			addTween(alarm2, true);
		}
		
		private function turn():void
		{
			(player.graphic as Spritemap).frame = 1;
			alarm3 = new Alarm(3, theend);
			addTween(alarm3, true);
		}
		
		private function theend():void
		{
			text.visible = true;
			resettable = true;
		}
	}

}