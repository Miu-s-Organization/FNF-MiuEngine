package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'face', isPlayer:Bool = false, allowGPU:Bool = true)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			if(!Paths.fileExists('images/icons/icon-face.png', IMAGE)) trace("Warning: could not find the placeholder icon, expect crashes!");
			
			final graphic = Paths.image(name, allowGPU);
			final iSize:Int = Math.floor(graphic.width / graphic.height); // Instead of using Math.round(), i using Math.floor() for prevent icon that width > 300 but width < 450 and not 3 frame icon, it give look like shit that we see.
			loadGraphic(graphic, true, Math.floor(graphic.width / iSize), Math.floor(graphic.height));
			iconOffsets[0] = (width - height) / iSize;
			iconOffsets[1] = (height - height) / iSize;
			updateHitbox();

			animation.add(char, [for(i in 0...iSize /*frames.frames.length*/) i], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.data.antialiasing;
			if(char.endsWith('-pixel')) antialiasing = false;
		}
	}

	public var autoAdjustOffset:Bool = true;
	override function updateHitbox()
	{
		super.updateHitbox();
		if(autoAdjustOffset || width % (animation.numFrames == 3 ? 900 : 600) == 0)
		{
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
		}
	}

	public function getCharacter():String {
		return char;
	}
}
