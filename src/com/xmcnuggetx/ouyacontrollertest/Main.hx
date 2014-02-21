package com.xmcnuggetx.ouyacontrollertest;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import openfl.events.JoystickEvent;

#if android
import openfl.utils.JNI;
import tv.ouya.console.api.OuyaController;
#end

/**
 * ...
 * @author Mike McMullin
 */

class Main extends Sprite 
{
	var controllers:Array<ControllerSprite>;
	
	var deviceIds:Array<Int>;
	
	public function new ()
	{
		super();
		deviceIds = [];
		trace("== OUYA CONTROLLER TEST (" + Date.now() + ") ==");
		
		// init controllers
		#if android
		var getContext = JNI.createStaticMethod ("org.haxe.lime.GameActivity", "getContext", "()Landroid/content/Context;", true);
		OuyaController.init (getContext());
		#end
		
		// init controller graphics
		controllers = [];
		for (i in 0...4)
		{
			controllers.push(createController(i));
			addChild(controllers[i]);
		}
		
		// add listeners
		stage.addEventListener(JoystickEvent.BALL_MOVE, onJoystickAxisMove);
		stage.addEventListener(JoystickEvent.AXIS_MOVE, onJoystickAxisMove);
		stage.addEventListener(JoystickEvent.BUTTON_DOWN, onJoystickButtonDown);
		stage.addEventListener(JoystickEvent.BUTTON_UP, onJoystickButtonUp);
		stage.addEventListener(JoystickEvent.HAT_MOVE, onJoystickHatMove);
		
		//stage.addEventListener(Event.ENTER_FRAME, update);
		
	}
	
	private function update(e:Event):Void
	{
		for (i in 0...deviceIds.length)
		{
			var controller:OuyaController = OuyaController.getControllerByDeviceId(deviceIds[i]);
			var player = OuyaController.getPlayerNumByDeviceId(deviceIds[i]);
			
			if (controller != null)
			{
				trace(deviceIds[i] + " " + controller.getName() + " " + controller.getAxisValue(OuyaController.AXIS_LS_Y));
				controllers[player].updateJoysticks(controller.getAxisValue(OuyaController.AXIS_LS_X), 
					controller.getAxisValue(OuyaController.AXIS_LS_Y), 
					controller.getAxisValue(OuyaController.AXIS_RS_X), 
					controller.getAxisValue(OuyaController.AXIS_RS_Y));
			}
		}
	}
	
	private function createController(id:Int):ControllerSprite
	{
		var controller:ControllerSprite = new ControllerSprite();
		controller.y = 300;
		controller.x = id  * 400 + 160;
		return controller;
	}
	
	
	// EVENT HANDLERS
	
	private function onJoystickAxisMove(e:JoystickEvent):Void 
	{
		var player = OuyaController.getPlayerNumByDeviceId(e.device);
		var controller:OuyaController  = OuyaController.getControllerByDeviceId(e.device);
		
		var leftX:Float = e.axis[OuyaController.AXIS_LS_X];
		var leftY:Float = e.axis[OuyaController.AXIS_LS_Y];
		var rightX:Float = e.axis[OuyaController.AXIS_RS_X]; 
		var rightY:Float = e.axis[OuyaController.AXIS_RS_Y]; 
		
		controllers[player].updateJoysticks(leftX, leftY, rightX, rightY);
		controllers[player].debug(controller.getName() + '\n' +
			"LS X: " + e.axis[OuyaController.AXIS_LS_X] + '\n' +
			"LS Y: " + e.axis[OuyaController.AXIS_LS_Y] + '\n' +
			"RS X: " + e.axis[OuyaController.AXIS_RS_X] + '\n' +
			"RS Y: " + e.axis[OuyaController.AXIS_RS_Y] + '\n' +
			"L2: " + e.axis[OuyaController.AXIS_L2] + '\n' +
			"R2: " + e.axis[OuyaController.AXIS_R2]); 
	}
	
	private function onJoystickHatMove(e:JoystickEvent):Void 
	{
		var player = OuyaController.getPlayerNumByDeviceId(e.device);
		var controller = OuyaController.getControllerByDeviceId(e.device);
		controllers[player].updateDpad(e.x, e.y);
	}
	
	private function onJoystickButtonUp(e:JoystickEvent):Void 
	{
		if (Lambda.indexOf(deviceIds, e.device) < 0)
		{
			deviceIds.push(e.device);
		}
		
		
		var player = OuyaController.getPlayerNumByDeviceId(e.device);
		var controller = OuyaController.getControllerByDeviceId(e.device);
		controllers[player].updateButton(e.id, false);

	}
	
	private function onJoystickButtonDown(e:JoystickEvent):Void 
	{
		var player = OuyaController.getPlayerNumByDeviceId(e.device);
		var controller = OuyaController.getControllerByDeviceId(e.device);
		
		controllers[player].updateButton(e.id, true);

	}
}