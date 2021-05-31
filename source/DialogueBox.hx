package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var fulldialogueList:Array<String> = [];
	var characterList:Array<String> = [];
	var rawDialogue:Array<String> = [];
	var curDialogue:Int = 0;
	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var coolDialogue:FlxTypeText;
	var cutscene:FlxSprite;
	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var switchingScene:Bool = false;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var specialblack:FlxSprite;

	var folderPrefix:String = '';

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		specialblack = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		specialblack.scrollFactor.set();
		switch (PlayState.SONG.song.toLowerCase()) {
			default:
				new FlxTimer().start(0.83, function(tmr:FlxTimer)
				{
					bgFade.alpha += (1 / 5) * 0.7;
					if (bgFade.alpha > 0.7)
						bgFade.alpha = 0.7;
				}, 5);
			case 'challenger' | 'vibe':
				add(specialblack);
				cutscene = new FlxSprite(-200, -100).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + '1', 'ridzak'));
				cutscene.scale.set(0.8, 0.8);
				cutscene.scrollFactor.set();
				add(cutscene);
				cutscene.alpha = 0;
				FlxTween.tween(cutscene, {alpha: 1}, 0.2, {
					startDelay: 0.1
				});
				
		}

		switch (PlayState.SONG.song.toLowerCase()) {
		}

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'challenger' | 'ouch' | 'ego':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.y += 320;
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
			
		}

		rawDialogue = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'challenger' | 'ouch' | 'ego':
				portraitRight = new FlxSprite(0, 40);
				portraitLeft = new FlxSprite(-60, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
			default:
				portraitRight = new FlxSprite(0, 40);
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		
		
		
		add(portraitLeft);
		portraitLeft.visible = false;
		
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'wicked-fate' | 'libera-me' | 'lune':
				portraitLeft.x -= 160;
				portraitLeft.y -= 30;
		}

		add(handSelect);


		if (!talkingRight)
		{
			box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		
		coolDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		coolDialogue.font = 'Pixel Arial 11 Bold';
		coolDialogue.color = 0xFF3F2021;
		coolDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
		cleanDialog();
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);
			if (!switchingScene)
				addDialogue();
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.alpha = 1;
		swagDialogue.resetText(fulldialogueList[curDialogue]);
		swagDialogue.start(0.04, true);

		switch (characterList[curDialogue])
		{
			case 'nothing':
				portraitRight.visible = false;
				portraitLeft.visible = false;
			case 'mint':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				box.flipX = true;
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/Mint', 'fakes');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
				portraitLeft.animation.play('enter');
			case 'mintsmile':
				portraitRight.visible = false;
				box.flipX = true;
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/Mintsmile', 'fakes');
				portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance 1', 24, false);
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'aloe':
				portraitLeft.visible = false;
				box.flipX = false;
				portraitRight.frames = Paths.getSparrowAtlas('portraits/Aloe', 'fakes');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'aloecry':
				portraitLeft.visible = false;
				box.flipX = false;
				portraitRight.frames = Paths.getSparrowAtlas('portraits/Aloecry', 'fakes');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'aloeembarrassed':
				portraitLeft.visible = false;
				box.flipX = false;
				portraitRight.frames = Paths.getSparrowAtlas('portraits/Aloeembarrassed', 'fakes');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'aloeworry':
				portraitLeft.visible = false;
				box.flipX = false;
				portraitRight.frames = Paths.getSparrowAtlas('portraits/Aloeworry', 'fakes');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
		}
	}

	function cleanDialog():Void
	{
		for (i in 0...rawDialogue.length) {
			var splitName:Array<String> = rawDialogue[i].split(":");
			characterList.push(splitName[0]);
			fulldialogueList.push(splitName[1]);
		}
	}
	function addDialogue():Void {
		if (curDialogue == fulldialogueList.length - 1)
		{
			if (!isEnding)
			{
				isEnding = true;
				

				if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
					FlxG.sound.music.fadeOut(2.2, 0);

				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 5;
					if (bgFade.alpha < 0)
						bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					swagDialogue.alpha -= 1 / 5;
					dropText.alpha = swagDialogue.alpha;
					switch (PlayState.SONG.song.toLowerCase()) {
						case 'lune':
							FlxTween.tween(cutscene, {alpha: 0}, 0.3, {
								startDelay: 0.1
							});
							FlxTween.tween(specialblack, {alpha: 0}, 0.3, {
								startDelay: 0.1
							});
					}
				}, 5);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
		}
		else
		{
			curDialogue++;	
			if (characterList[curDialogue] != 'switch') {
				startDialogue();
				trace(curCharacter);
			} else {
				switchCutscene(Std.parseInt(fulldialogueList[curDialogue]));
				trace(curCharacter);
			}
		}
	}

	function switchCutscene(scene:Int):Void {
		switchingScene = true;
		remove(portraitLeft);
		remove(portraitRight);
		remove(box);
		remove(swagDialogue);
		remove(dialogue);
		remove(dropText);
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			FlxTween.tween(cutscene, {alpha: 0}, 0.5, {
				onComplete: function(tween:FlxTween)
				{
					cutscene = new FlxSprite(-200, -100).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + Std.string(scene), 'ridzak'));
					cutscene.scale.set(0.8, 0.8);
					cutscene.scrollFactor.set();
					cutscene.alpha = 0;	
					swagDialogue.resetText(fulldialogueList[curDialogue]);
					portraitLeft.visible = false;
					portraitRight.visible = false;
					add(cutscene);
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxTween.tween(cutscene, {alpha: 1}, 0.5, {
							onComplete: function(tween:FlxTween)
							{
								new FlxTimer().start(0.05, function(tmr:FlxTimer)
								{
									addDialogue();
								});
								switchingScene = false;
								box.alpha = 1;
								swagDialogue.alpha = 1;
								swagDialogue.visible = true;
								swagDialogue.font = 'Pixel Arial 11 Bold';
								swagDialogue.color = 0xFF3F2021;
								dropText.alpha = 1;
								dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
								dropText.font = 'Pixel Arial 11 Bold';
								dropText.color = 0xFFD89494;
								dropText.alpha = 1;
								dialogue.alpha = 1;
								add(dialogue);
								add(portraitLeft);
								add(portraitRight);
								add(box);
								add(dropText);
								add(swagDialogue);	
							}
						});
					});
				}
			});
		});
	}
}
