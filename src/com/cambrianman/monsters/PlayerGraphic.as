package com.cambrianman.monsters 
{
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class PlayerGraphic extends Graphiclist 
	{
		[Embed(source = "gfx/player_base.png")] private const IMGBASE:Class;
		[Embed(source = "gfx/player_arms_normal.png")] private const IMGNORMALARMS:Class;
		[Embed(source = "gfx/player_arms_hold.png")] private const IMGHOLDARMS:Class;
		
		private var base:Spritemap;
		private var normalArms:Spritemap;
		private var holdArms:Spritemap;
		
		private var _flipped:Boolean;
		private var _holding:Boolean;
		
		
		public function PlayerGraphic() 
		{
			super();
			
			base = new Spritemap(IMGBASE, 32, 32);
			add(base);
			
			normalArms = new Spritemap(IMGNORMALARMS, 32, 32);
			add(normalArms);
			
			holdArms = new Spritemap(IMGHOLDARMS, 32, 32);
			holdArms.visible = false;
			add(normalArms);
			
			
			setupAnims();
		}
		
		private function setupAnims():void
		{
			for each (var _g:Spritemap in [base, holdArms, normalArms])
			{
				_g.add("idle", [0]);
				_g.add("hop", [1, 2, 3, 4, 5], 12);
				_g.add("rise", [6]);
				_g.add("fall", [7]);
				_g.add("cling", [8]);
			}
			
		}
		
		public function set holding(value:Boolean):void
		{
			_holding = value;
			
			if (_holding)
			{
				holdArms.visible = true;
				normalArms.visible = false;
			}
			else
			{
				holdArms.visible = false;
				normalArms.visible = true;
			}
		}
		
		public function get holding():Boolean
		{
			return _holding;
		}
		
		public function play(anim:String):void
		{
			for each (var _g:Spritemap in children)
			{
				_g.play(anim);
			}
		}
		
		public function set flipped(value:Boolean):void
		{
			for each (var _g:Spritemap in children)
			{
				_g.flipped = value;
			}
		}
	}

}