package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	/**
	 * Class for Main Menu
	 * @author Evan Furchtgott
	 */
	public class Menu extends World
	{
		[Embed(source = "gfx/items/fire_seed.png")] private const IMGFIRE:Class;
		
		private var newGameItem:Entity;
		private var continueGameItem:Entity;
		private var controlsItem:Entity;
		private var creditsItem:Entity;
		
		private var mainMenuItems:Vector.<Entity>;
		private var controlsMenuItems:Vector.<Entity>;
		
		private var selectedItem:int = 0;
		
		private var cursor:Entity;
		
		public function Menu() 
		{
			Data.load("monstersSaveData");
			
			Text.font = "Mini-Serif";

			createMainMenu();
			showMainMenu();
			
			createControls();
			
			cursor = new Entity(64, 0);
			cursor.graphic = new Spritemap(IMGFIRE, 16, 16);
			(cursor.graphic as Spritemap).add("anim", [0, 1, 2, 3], 8, true);
			(cursor.graphic as Spritemap).play("anim");
			(cursor.graphic as Spritemap).originY = 4;
			add(cursor);
			setCursor(0);
		}
		
		private function createMainMenu():void
		{
			newGameItem = new Entity(80, 100, new Text("New Game"));
			
			continueGameItem = new Entity(80, 120, new Text("Continue Game"));
			if (Data.readString("level") == "")
				(continueGameItem.graphic as Text).alpha = 0.3;
				
			add(continueGameItem);
			
			controlsItem = new Entity(80, 140, new Text("Controls"));
			add(controlsItem);
			
			creditsItem = new Entity(80, 160, new Text("Credits"));
			add(creditsItem);
			
			mainMenuItems = new Vector.<Entity>();
			mainMenuItems.push(newGameItem);
			mainMenuItems.push(continueGameItem);
			mainMenuItems.push(controlsItem);
			mainMenuItems.push(creditsItem);
		}
		
		private function createControls():void
		{
			controlsMenuItems = new Vector.<Entity>();
			var left:Entity = new Entity(32, 40, new Text("Move Left"));
			controlsMenuItems.push(left);
			
			var leftKey:Entity = new Entity(160, 40, new Text("Left Arrow"));
			controlsMenuItems.push(leftKey);
			
			var right:Entity = new Entity(32, 60, new Text("Move Right"));
			controlsMenuItems.push(right);
			
			var rightKey:Entity = new Entity(160, 60, new Text("Right Arrow"));
			controlsMenuItems.push(rightKey);

			var up:Entity = new Entity(32, 80, new Text("Look Up"));
			controlsMenuItems.push(up);
			
			var upKey:Entity = new Entity(160, 80, new Text("Up Arrow"));
			controlsMenuItems.push(upKey);

			var down:Entity = new Entity(32, 100, new Text("Look Down"));
			controlsMenuItems.push(down);
			
			var downKey:Entity = new Entity(160, 100, new Text("Down Arrow"));
			controlsMenuItems.push(downKey);

			var jump:Entity = new Entity(32, 120, new Text("Jump"));
			controlsMenuItems.push(jump);
			
			var jumpKey:Entity = new Entity(160, 120, new Text("X"));
			controlsMenuItems.push(jumpKey);
			
			var interact:Entity = new Entity(32, 140, new Text("Grab and Throw"));
			controlsMenuItems.push(interact);
			
			var interactKey:Entity = new Entity(160, 140, new Text("C"));
			controlsMenuItems.push(interactKey);
			
			var reset:Entity = new Entity(32, 160, new Text("Return to Checkpoint"));
			controlsMenuItems.push(reset);
			
			var resetKey:Entity = new Entity(160, 160, new Text("R"));
			controlsMenuItems.push(resetKey);
			
			var back:Entity = new Entity(32, 200, new Text("Back to Main Menu"));
			controlsMenuItems.push(back);
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
			else if (item == 2)
			{
				showControlsMenu();
			}
			else if (item == 3)
			{
				
			}
		}
		
		private function showMainMenu():void
		{
			addList(mainMenuItems);
		}
		
		private function showControlsMenu():void
		{
			removeList(mainMenuItems);
			addList(controlsMenuItems);
		}
	}

}