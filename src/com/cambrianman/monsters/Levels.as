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
		// Testbed levels
		[Embed(source = "levels/test.tmx", mimeType = "application/octet-stream")] public static const test:Class;
		[Embed(source = "levels/test2.tmx", mimeType = "application/octet-stream")] public static const test2:Class;
		
		// Levels
		[Embed(source = "levels/start.tmx", mimeType = "application/octet-stream")] public static const start:Class;
		[Embed(source = "levels/balloonIntro.tmx", mimeType = "application/octet-stream")] public static const balloonIntro:Class;
		[Embed(source = "levels/descent.tmx", mimeType = "application/octet-stream")] public static const descent:Class;
		[Embed(source = "levels/blockCorridor.tmx", mimeType = "application/octet-stream")] public static const blockCorridor:Class;
		[Embed(source = "levels/gatekeeper.tmx", mimeType = "application/octet-stream")] public static const gatekeeper:Class;
		[Embed(source = "levels/looper.tmx", mimeType = "application/octet-stream")] public static const looper:Class;
		[Embed(source = "levels/portcullis.tmx", mimeType = "application/octet-stream")] public static const portcullis:Class;
		[Embed(source = "levels/pushPop.tmx", mimeType = "application/octet-stream")] public static const pushPop:Class;
		
		public function Levels() 
		{
			
		}
		
	}

}