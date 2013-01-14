package com.cambrianman.monsters 
{
	/**
	 * A list of embedded classes containing our levels.
	 * We need to do this because it's the only way to embed files into a .swf.
	 * The names should correspond to the string used when you exit a board.
	 * @author Evan Furchtgott
	 */
	public class Levels 
	{
		public static const list:Object = new Object();
		[Embed(source = "levels/test.tmx", mimeType = "application/octet-stream")] public static const test:Class;
		[Embed(source = "levels/test2.tmx", mimeType = "application/octet-stream")] public static const test2:Class;
		public function Levels() 
		{
			
		}
		
	}

}