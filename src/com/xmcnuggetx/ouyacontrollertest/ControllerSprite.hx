package com.xmcnuggetx.ouyacontrollertest;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;

import tv.ouya.console.api.OuyaController;

/**
 * Graphic representation of Ouya Controller
 * @author Mike McMullin
 */
class ControllerSprite extends Sprite
{
	var dpads:Array<Bitmap>;
	var joysticks:Array<Bitmap>;
	var buttons:Map<Int, Bitmap>;
	var debugText:TextField;
	
	public function new() 
	{
		super();
		create();
	}
	
	public function create():Void
	{
		dpads = [
			createButton("img/dpad_up.png"),
			createButton("img/dpad_down.png"),
			createButton("img/dpad_left.png"),
			createButton("img/dpad_right.png")
		];
		
		joysticks = [
			new Bitmap(Assets.getBitmapData("img/l_stick.png")),
			new Bitmap(Assets.getBitmapData("img/r_stick.png"))
		];
		
		buttons = [
			OuyaController.BUTTON_O => createButton("img/o.png"),
			OuyaController.BUTTON_U => createButton("img/u.png"),
			OuyaController.BUTTON_Y => createButton("img/y.png"),
			OuyaController.BUTTON_A => createButton("img/a.png"),
			OuyaController.BUTTON_L1 => createButton("img/lb.png"),
			OuyaController.BUTTON_R1 => createButton("img/rb.png"),
			OuyaController.BUTTON_L2 => createButton("img/lt.png"),
			OuyaController.BUTTON_R2 => createButton("img/rt.png"),
			OuyaController.BUTTON_L3 => createButton("img/thumbl.png"),
			OuyaController.BUTTON_R3 => createButton("img/thumbr.png"),
			
		];
		
		// add controller gfx
		addChild(new Bitmap(Assets.getBitmapData("img/cutter.png")));
		
		// add dpad
		for (dpad in dpads)
		{
			addChild(dpad);
		}
		
		// add joysticks
		for (joystick in joysticks)
		{
			addChild(joystick);
		}
		
		// add button gfx
		for (button in buttons)
		{
			addChild(button);
		}
		
		// add text
		debugText = new TextField();
		addChild(debugText);
		debugText.y += 350;		
		debugText.width = 1000;
		debugText.height= 1000;
		var tf:TextFormat = new TextFormat("_serif", 30, 0xffffff);	
		debugText.defaultTextFormat = tf;
	
		
	}
	
	public function debug(text:String):Void
	{
		debugText.text = text;
		
	}
	
	
	
	private function createButton(id:String):Bitmap
	{
		var buttonBmp = new Bitmap(Assets.getBitmapData(id));
		buttonBmp.visible = false;
		return buttonBmp;
	}
	
	public function updateButton(buttonID:Int, visible:Bool)
	{
		if (!buttons.exists(buttonID))
		{
			trace('Uknown button id: $buttonID');
			return;
		}

		buttons[buttonID].visible = visible;
	}
	
	public function updateDpad(x:Float, y:Float)
	{
		dpads[0].visible = y < 0;
		dpads[1].visible = y > 0;
		dpads[2].visible = x < 0;
		dpads[3].visible = x > 0;
	}
	
	public function updateJoysticks(leftStickX:Float, leftStickY:Float, rightStickX:Float, rightStickY:Float)
	{
		joysticks[0].x = leftStickX * 10;
		joysticks[0].y = leftStickY * 10;
		joysticks[1].x = rightStickX * 10;
		joysticks[1].y = rightStickY * 10;
	}

	
}