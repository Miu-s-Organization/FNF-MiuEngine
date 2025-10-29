package options;

import objects.Note;
import objects.StrumNote;
import objects.NoteSplash;
import objects.Alphabet;

class VisualsSettingsSubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var splashes:FlxTypedGroup<NoteSplash>;
	var noteY:Float = 90;
	public function new()
	{
		title = Language.getPhrase('visuals_menu', 'Visuals Settings');
		rpcTitle = 'Visuals Settings Menu'; //for Discord Rich Presence

		// for note skins and splash skins
		notes = new FlxTypedGroup<StrumNote>();
		splashes = new FlxTypedGroup<NoteSplash>();
		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = new StrumNote(370 + (560 / Note.colArray.length) * i, -200, i, 0);
			note.centerOffsets();
			note.centerOrigin();
			note.playAnim('static');
			notes.add(note);
			
			var splash:NoteSplash = new NoteSplash();
			splash.noteData = i;
			splash.setPosition(note.x, noteY);
			splash.loadSplash();
			splash.visible = false;
			splash.alpha = ClientPrefs.data.splashAlpha;
			splash.animation.finishCallback = function(name:String) splash.visible = false;
			splashes.add(splash);
			
			Note.initializeGlobalRGBShader(i % Note.colArray.length);
			splash.rgbShader.copyValues(Note.globalRgbShaders[i % Note.colArray.length]);
		}

		// options
		var noteSkins:Array<String> = Mods.mergeAllTextsNamed('images/noteSkins/list.txt');
		if(noteSkins.length > 0)
		{
			if(!noteSkins.contains(ClientPrefs.data.noteSkin))
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found

			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin); //Default skin always comes first
			var option:Option = new Option('Note Skins:',
				"Select your prefered Note skin.",
				'noteSkin',
				STRING,
				noteSkins);
			addOption(option);
			option.onChange = onChangeNoteSkin;
			noteOptionID = optionsArray.length - 1;
		}
		
		var noteSplashes:Array<String> = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt');
		if(noteSplashes.length > 0)
		{
			if(!noteSplashes.contains(ClientPrefs.data.splashSkin))
				ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin; //Reset to default if saved splashskin couldnt be found

			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin); //Default skin always comes first
			var option:Option = new Option('Note Splashes:',
				"Select your prefered Note Splash variation.",
				'splashSkin',
				STRING,
				noteSplashes);
			addOption(option);
			option.onChange = onChangeSplashSkin;
		}

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		option.onChange = playNoteSplashes;

		var option:Option = new Option('Note Splash',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			BOOL);
		addOption(option);

		var option:Option = new Option('Opponent Note Splash',
			"If checked, opponent note hits will show particles.",
			'oppNoteSplashes',
			BOOL);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			STRING,
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			BOOL);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			BOOL);
		addOption(option);

		var option:Option = new Option('Score Text Grow on Hit',
			"If unchecked, disables the Score text growing\neverytime you hit a note.",
			'scoreZoom',
			BOOL);
		addOption(option);

		var option:Option = new Option('Health Bar Opacity',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		//#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			BOOL);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		
		var option:Option = new Option('Show Memory Usage',
			'If unchecked, hides Memory usage.',
			'showMem',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Show Peak Memory Usage',
			'If unchecked, hides Peak Memory usage.',
			'showMemMax',
			BOOL);
		addOption(option);

		var option:Option = new Option('Show Debug Info',
			'',
			'showDebugInfo',
			BOOL);
		addOption(option);

		var option:Option = new Option('Enable Rainbow For FPS Counter',
			'',
			'rgbFPSCounter',
			BOOL);
		addOption(option);
		//#end
		
		var option:Option = new Option('Pause Music:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			STRING,
			['None', 'Tea Time', 'Breakfast', 'Breakfast (Pico)']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			BOOL);
		addOption(option);
		#end

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			BOOL);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Icon Bounce:',
			"Select your prefered Icon Bounce variation.",
			'iconBounce',
			STRING,
			['Default', 'New Psych', 'Old Psych', 'Dave and Bambi', 'Golden Apple', 'OS Engine', 'Strident Crisis', 'None']);
		addOption(option);
		
		var option:Option = new Option('Note Splash Limit',
			'How much transparent should the Note Splashes be.',
			'maxSplashLimit',
			INT);
		option.minValue = 0;
		option.maxValue = 10000;
		option.changeValue = 1;
		addOption(option);

		var option:Option = new Option('OPTIMIZATION SETTING (UNFINISHED, W.I.P)',
			"",
			'blank',
			STRING,
			['', ' ']);
		addOption(option);

		var option:Option = new Option('Recycle Note',
			"(W.I.P) If checked, game run faster because game using FlxTypedGroup's recycle function.\nShoutout to SomeGuyWhoLikesCoding.",
			'recycleNote',
			BOOL);
		addOption(option);

		var option:Option = new Option('Fast Note Spawn',
			"(W.I.P) If checked, game using NoteGroup's recycle function instead of FlxTypedGroup.\nShoutout to Codename Engine Team and Jordan Santiago (for port to JS Engine and a place that i borrow).",
			'fastNoteSpawn',
			BOOL);
		addOption(option);

		var option:Option = new Option('Enable GC',
			"If checked, then the game will be allowed to garbage collect,\n" + // the desc is borrow from JS Engine!!!
			"reducing RAM usage I suppose.\n" +
			"If you experience memory leaks, turn this on, and\n" +
			"if you experience lag with it on then turn it off.",
			'enableGC',
			BOOL);
		addOption(option);

		var option:Option = new Option('Recycle Rating Popup', // based on HRK EXEX Engine but i write.
			"(W.I.P) If checked, rating popup doesn't make game slower.",
			'recycleRating',
			BOOL);
		addOption(option);

		var option:Option = new Option('Don\'t Rating Popup If Botplay',
			"If unchecked, the rating with be popup even you enable Botplay.",
			'dontRatingPopupIfBotplay',
			BOOL);
		addOption(option);

		var option:Option = new Option('Show Combo Popup',
			"If checked, the unused combo popup will be appear.",
			'showCombo',
			BOOL);
		addOption(option);

		super();
		add(notes);
		add(splashes);
	}

	var notesShown:Bool = false;
	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		
		switch(curOption.variable)
		{
			case 'noteSkin', 'splashSkin', 'splashAlpha':
				if(!notesShown)
				{
					for (note in notes.members)
					{
						FlxTween.cancelTweensOf(note);
						FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
					}
				}
				notesShown = true;
				if(curOption.variable.startsWith('splash') && Math.abs(notes.members[0].y - noteY) < 25) playNoteSplashes();

			default:
				if(notesShown) 
				{
					for (note in notes.members)
					{
						FlxTween.cancelTweensOf(note);
						FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
					}
				}
				notesShown = false;
		}
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	function onChangeNoteSkin()
	{
		notes.forEachAlive(function(note:StrumNote) {
			changeNoteSkin(note);
			note.centerOffsets();
			note.centerOrigin();
		});
	}

	function changeNoteSkin(note:StrumNote)
	{
		var skin:String = Note.defaultNoteSkin;
		var customSkin:String = skin + Note.getNoteSkinPostfix();
		if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;

		note.texture = skin; //Load texture and anims
		note.reloadNote();
		note.playAnim('static');
	}

	function onChangeSplashSkin()
	{
		for (splash in splashes)
			splash.loadSplash();

		playNoteSplashes();
	}

	function playNoteSplashes()
	{
		for (splash in splashes)
		{
			var anim:String = splash.playDefaultAnim();
			splash.visible = true;
			splash.alpha = ClientPrefs.data.splashAlpha;
			
			var conf = splash.config.animations.get(anim);
			var offsets:Array<Float> = [0, 0];

			if (conf != null)
				offsets = conf.offsets;

			if (offsets != null)
			{
				splash.centerOffsets();
				splash.offset.set(offsets[0], offsets[1]);
			}
		}
	}

	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}