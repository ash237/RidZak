package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;

import flixel.util.FlxColor;
import flixel.math.FlxMath;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuItemsSelected:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var blueCorner:FlxSprite;
	var redCorner:FlxSprite;
	var bgcubes:FlxBackdrop;


	var tweenArray:Array<FlxTween> = [];

	override function create()
	{
		FlxG.camera.zoom = 5;
		FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.3, {
			ease: FlxEase.quadInOut,
			startDelay: 0.2,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1, {
				});
			}
		});
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('back', 'ridzak'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.y -= 50;
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menubgdesat', 'ridzak'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.15;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		bgcubes = new FlxBackdrop(Paths.image('mainGrid', 'ridzak'), 0.3, 0.3, true, true);
		add(bgcubes);

		var linesbg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainLines', 'ridzak'));
		linesbg.scrollFactor.set();
		linesbg.updateHitbox();
		linesbg.screenCenter();
		add(linesbg);
		
		

		blueCorner = new FlxSprite(0).loadGraphic(Paths.image('blueCorner', 'ridzak'));
		blueCorner.scrollFactor.x = 0;
		blueCorner.scrollFactor.y = 0;
		blueCorner.updateHitbox();
		blueCorner.screenCenter();
		blueCorner.visible = true;
		blueCorner.antialiasing = true;	
		add(blueCorner);

		redCorner = new FlxSprite(0).loadGraphic(Paths.image('redCorner', 'ridzak'));
		redCorner.scrollFactor.x = 0;
		redCorner.scrollFactor.y = 0;
		redCorner.updateHitbox();
		redCorner.screenCenter();
		redCorner.visible = true;
		redCorner.antialiasing = true;	
		add(redCorner);
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		menuItemsSelected = new FlxTypedGroup<FlxSprite>();
		add(menuItemsSelected);
		
		for (i in 0...optionShit.length)
		{
			/*var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');*/
			var menuItem:FlxSprite = new FlxSprite(0, 10 + (i * 180)).loadGraphic(Paths.image('bars/Bar' + i, 'ridzak'));
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			//menuItem.scale.set(1, 0.65);
			menuItem.scrollFactor.set();
			menuItem.updateHitbox();
			menuItem.antialiasing = true;
			var menuItemSelected:FlxSprite = new FlxSprite(0, 10 + (i * 180)).loadGraphic(Paths.image('bars/BarSelected' + i, 'ridzak'));
			menuItemSelected.ID = i;
			menuItemSelected.screenCenter(X);
			menuItemsSelected.add(menuItemSelected);
			//menuItemSelected.scale.set(1, 0.65);
			menuItemSelected.scrollFactor.set();
			menuItemSelected.updateHitbox();
			menuItemSelected.antialiasing = true;
			menuItemSelected.visible = false;
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					/*new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxTween.tween(blueCorner, {x: blueCorner.x += 200, y: blueCorner.y -= 200}, 3, {
							ease: FlxEase.quadOut,
						});
						FlxTween.tween(redCorner, {x: redCorner.x -= 200, y: redCorner.y += 200}, 3, {
							ease: FlxEase.quadOut,
						});
					});*/

					menuItemsSelected.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItemsSelected.forEach(function(spr:FlxSprite)
		{
			spr.setPosition(menuItems.members[spr.ID].x, menuItems.members[spr.ID].y);
		});
		bgcubes.x -= 0.50;
		bgcubes.y -= 0.20;
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected) {
				tweenArray[menuItems.members.indexOf(spr)] = FlxTween.tween(spr, {x: (FlxG.width / 2) + 80}, 0.2, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						if (spr.ID != curSelected)
						{
							spr.x = FlxG.width - 40;
						}
					} 
				});
				
			} else {
				if (tweenArray[menuItems.members.indexOf(spr)] != null) {
					tweenArray[menuItems.members.indexOf(spr)].cancel();
				}
				spr.x = FlxG.width - 40;
			}
			/*spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
			*/
			spr.updateHitbox();
		});
	}
}
