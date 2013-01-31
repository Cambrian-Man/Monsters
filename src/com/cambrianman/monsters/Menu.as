package com.cambrianman.monsters 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	/**
	 * Class for Main Menu
	 * This class is pretty quick-and-dirty, done for time.
	 * @author Evan Furchtgott
	 */
	public class Menu extends World
	{
		// Used for the cursor.
		[Embed(source = "gfx/items/fire_seed.png")] private const IMGFIRE:Class;
		
		[Embed(source = "gfx/title.png")] private const IMGTITLE:Class;
		[Embed(source = "gfx/credits.png")] private const IMGCREDITS:Class;

		// Sounds
		[Embed(source = "audio/up_down.mp3")] private const SNDUPDOWN:Class;
		[Embed(source = "audio/select.mp3")] private const SNDSELECT:Class;
		
		private var upDown:Sfx;
		private var select:Sfx;
		
		// Entities for the main menu
		private var newGameItem:Entity;
		private var continueGameItem:Entity;
		private var controlsItem:Entity;
		private var soundItem:Entity;
		private var creditsItem:Entity;
		
		private var mainMenuItems:Vector.<Entity>;
		private var controlsMenuItems:Vector.<Entity>;
		private var keyItems:Vector.<Entity>;
		
		private var selectedItem:int = 0;
		
		private var credits:Entity;
		private var creditsSelected:Boolean = false;
		
		// -1 means 'no key'. 
		private var keyToSet:int = -1;
		
		private var cursor:Entity;
		private var title:Entity;
		
		private var menu:Vector.<Entity>;
		
		public function Menu() 
		{			
			Text.font = "Mini-Serif";
			
			title = new Entity(0, 0, new Image(IMGTITLE));
			title.layer = 9;
			add(title);
			
			cursor = new Entity(64, 0);
			cursor.graphic = new Spritemap(IMGFIRE, 16, 16);
			(cursor.graphic as Spritemap).add("anim", [0, 1, 2, 3], 8, true);
			(cursor.graphic as Spritemap).play("anim");
			(cursor.graphic as Spritemap).originY = 4;
			add(cursor);
			
			upDown = new Sfx(SNDUPDOWN);
			upDown.type = "effects";
			select = new Sfx(SNDSELECT);
			select.type = "effects";
			
			createMainMenu();
			createControls();
			
			credits = new Entity(0, 0, new Image(IMGCREDITS));
			credits.visible = false;
			credits.layer = 0;
			add(credits);
			
			showMainMenu();
		}
		
		private function createMainMenu():void
		{
			continueGameItem = new Entity(80, 100, new Text("Continue Game"));
			if (Data.readString("level") == "")
				(continueGameItem.graphic as Text).alpha = 0.3;
			
			newGameItem = new Entity(80, 120, new Text("New Game"));
				
			add(continueGameItem);
			
			controlsItem = new Entity(80, 140, new Text("Controls"));
			add(controlsItem);
			
			var soundStatus:String;
			if (Data.readBool("sound"))
				soundStatus = "Disable Sound";
			else
				soundStatus = "Enable Sound";
				
			soundItem = new Entity(80, 160, new Text(soundStatus));
			add(soundItem);
			
			creditsItem = new Entity(80, 180, new Text("Credits"));
			add(creditsItem);
			
			mainMenuItems = new Vector.<Entity>();

			mainMenuItems.push(continueGameItem);
			mainMenuItems.push(newGameItem);
			mainMenuItems.push(controlsItem);
			mainMenuItems.push(soundItem);
			mainMenuItems.push(creditsItem);
			
			for each (var _e:Entity in mainMenuItems)
			{
				_e.layer = 3;
			}
		}
		
		/**
		 * Builds our control menu
		 * Actually two lists, the control and the key used
		 * The font doesn't handle every key, but it does alphanumerics so whatever.
		 */
		private function createControls():void
		{
			controlsMenuItems = new Vector.<Entity>();
			keyItems = new Vector.<Entity>();
			
			var left:Entity = new Entity(32, 32, new Text("Move Left"));
			controlsMenuItems.push(left);
			
			var leftKey:Entity = new Entity(160, 32, new Text(Key.name(Main.controlKeys.left)));
			keyItems.push(leftKey);
			
			var right:Entity = new Entity(32, 52, new Text("Move Right"));
			controlsMenuItems.push(right);
			
			var rightKey:Entity = new Entity(160, 52, new Text(Key.name(Main.controlKeys.right)));
			keyItems.push(rightKey);

			var up:Entity = new Entity(32, 72, new Text("Look Up"));
			controlsMenuItems.push(up);
			
			var upKey:Entity = new Entity(160, 72, new Text(Key.name(Main.controlKeys.up)));
			keyItems.push(upKey);

			var down:Entity = new Entity(32, 92, new Text("Look Down"));
			controlsMenuItems.push(down);
			
			var downKey:Entity = new Entity(160, 92, new Text(Key.name(Main.controlKeys.down)));
			keyItems.push(downKey);

			var jump:Entity = new Entity(32, 112, new Text("Jump"));
			controlsMenuItems.push(jump);
			
			var jumpKey:Entity = new Entity(160, 112, new Text(Key.name(Main.controlKeys.jump)));
			keyItems.push(jumpKey);
			
			var interact:Entity = new Entity(32, 132, new Text("Grab and Throw"));
			controlsMenuItems.push(interact);
			
			var interactKey:Entity = new Entity(160, 132, new Text(Key.name(Main.controlKeys.interact)));
			keyItems.push(interactKey);
			
			var reset:Entity = new Entity(32, 152, new Text("Return to Checkpoint"));
			controlsMenuItems.push(reset);
			
			var resetKey:Entity = new Entity(160, 152, new Text(Key.name(Main.controlKeys.reset)));
			keyItems.push(resetKey);
			
			var defaults:Entity = new Entity(32, 172, new Text("Use Defaults"));
			controlsMenuItems.push(defaults);
			
			var back:Entity = new Entity(32, 192, new Text("Back to Main Menu"));
			controlsMenuItems.push(back);
		}
		
		override public function update():void
		{
			super.update();
			
			// If we've got a key to set, just wait for a key to be pressed.
			if (keyToSet >= 0)
			{
				if (Input.pressed(Key.ANY))
					setKey(keyToSet, Input.lastKey);
				
				return;
			}
			else if (creditsSelected)
			{
				if (Input.pressed(Key.ANY))
				{
					credits.visible = false;
					creditsSelected = false;
				}
				
				return;
			}
			
			// Cycles through menu items
			if (Input.pressed(Key.DOWN))
			{
				upDown.play();
				selectedItem++;
				if (selectedItem == menu.length)
					selectedItem = 0;
				setCursor(selectedItem);
			}
			else if (Input.pressed(Key.UP))
			{
				upDown.play();
				selectedItem--;
				if (selectedItem < 0)
					selectedItem = menu.length - 1;
				setCursor(selectedItem);
			}
			else if (Input.pressed(Key.ANY))
			{
				select.play();
				selectItem(selectedItem);
			}
		}
		
		/**
		 * Set the cursor's position to a menu item.
		 * @param	loc
		 */
		private function setCursor(loc:int):void
		{
			var item:Entity = menu[loc];
			cursor.x = item.x - 20;
			cursor.y = item.y;
		}
		
		/**
		 * Actually handle menu item selection.
		 * @param	item
		 */
		private function selectItem(item:int):void
		{
			if (menu == mainMenuItems) 
			{
				if (item == 1)
				{
					FP.world = new Level(true);
				}
				else if (item == 0)
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
					if (Data.readBool("sound"))
					{
						(soundItem.graphic as Text).text = "Enable Sound";
						Data.writeBool("sound", false);
						Sfx.setVolume("music", 1.0);
						Sfx.setVolume("effects", 1.0);
					}
					else
					{
						(soundItem.graphic as Text).text = "Disable Sound";
						Data.writeBool("sound", true);
						Sfx.setVolume("music", 0);
						Sfx.setVolume("effects", 0);
					}
				}
				else if (item == 4)
				{
					creditsSelected = true;
					credits.visible = true;
				}
			}
			else if (menu == controlsMenuItems)
			{
				if (item == 7)
				{
					Main.setDefaultKeys();
					(keyItems[0].graphic as Text).text = Key.name(Main.controlKeys.left);
					(keyItems[1].graphic as Text).text = Key.name(Main.controlKeys.right);
					(keyItems[2].graphic as Text).text = Key.name(Main.controlKeys.up);
					(keyItems[3].graphic as Text).text = Key.name(Main.controlKeys.down);
					(keyItems[4].graphic as Text).text = Key.name(Main.controlKeys.jump);
					(keyItems[5].graphic as Text).text = Key.name(Main.controlKeys.interact);
					(keyItems[6].graphic as Text).text = Key.name(Main.controlKeys.reset);
				}
				else if (item == 8)
				{
					Main.saveKeys();
					showMainMenu();
				}
				else
				{
					keyToSet = item;
					cursor.x = 140;
				}
			}
		}
		
		/**
		 * Actually sets the key in our state variables.
		 * @param	key
		 * @param	code
		 */
		private function setKey(key:int, code:int):void
		{
			switch (key) 
			{
				case 0:
					Main.controlKeys.left = code;
				break;
				case 1:
					Main.controlKeys.right = code;
				break;
				case 2:
					Main.controlKeys.up = code;
				break;
				case 3:
					Main.controlKeys.down = code;
				break;
				case 4:
					Main.controlKeys.jump = code;
				break;
				case 5:
					Main.controlKeys.interact = code;
				break;
				case 6:
					Main.controlKeys.reset = code;
				break;
			}
			
			setCursor(key);
			
			(keyItems[key].graphic as Text).text = Key.name(code);
			
			keyToSet = -1;
		}
		
		private function showMainMenu():void
		{
			removeList(controlsMenuItems);
			removeList(keyItems);
			menu = mainMenuItems;
			selectedItem = 0;
			setCursor(selectedItem);
			addList(mainMenuItems);
			title.visible = true;
		}
		
		private function showControlsMenu():void
		{
			removeList(mainMenuItems);
			menu = controlsMenuItems;
			selectedItem = 0;
			setCursor(selectedItem);
			addList(controlsMenuItems);
			addList(keyItems);
			title.visible = false;
		}
	}

}