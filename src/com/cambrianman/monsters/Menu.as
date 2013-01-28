package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Evan Furchtgott
	 */
	public class Menu extends World
	{
		private var newGameItem:Entity;
		private var continueGameItem:Entity;
		private var controlsItem:Entity;
		private var creditsItem:Entity;
		
		private var selectedItem:int = 0;
		
		private var cursor:Entity;
		
		public function Menu() 
		{
			Data.load("monstersSaveData");
			
			Text.font = "Mini-Serif";

			newGameItem = new Entity(80, 100, new Text("New Game"));
			add(newGameItem);
			
			continueGameItem = new Entity(80, 120, new Text("Continue Game"));
			if (Data.readString("level") == "")
				(continueGameItem.graphic as Text).alpha = 0.3;
			add(continueGameItem);
			
			controlsItem = new Entity(80, 140, new Text("Controls"));
			add(controlsItem);
			
			creditsItem = new Entity(80, 160, new Text("Credits"));
			add(creditsItem);
			
			cursor = new Entity(64, 0, Image.createRect(16, 16));
			add(cursor);
			setCursor(0);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.DOWN))
			{
				selectedItem++;
				if (selectedItem > 3)
					selectedItem = 0;
				setCursor(selectedItem);
			}
			else if (Input.pressed(Key.UP))
			{
				selectedItem--;
				if (selectedItem < 0)
					selectedItem = 3;
				setCursor(selectedItem);
			}
			else if (Input.pressed(Key.ANY))
			{
				selectItem(selectedItem);
			}
			
		}
		
		private function setCursor(loc:int):void
		{
			cursor.y = (loc * 20) + 100;
		}
		
		private function selectItem(item:int):void
		{
			if (item == 0)
			{
				FP.world = new Level(true);
			}
			else if (item == 1)
			{
				if (!(Data.readString("level") == ""))
					FP.world = new Level(false);
			}
		}
	}

}