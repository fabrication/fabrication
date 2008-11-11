/**
 * Copyright (C) 2008 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mock {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;	
	
	import flexunit.framework.Assert;	
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class SimpleFabricationCommandMock extends SimpleFabricationCommand implements IMockable {

		private var _mock:Mock = null;
		public var executed:Boolean = false;		
		public var executedNote:INotification;
		
		public function SimpleFabricationCommandMock() {
			super();
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			};
			
			return _mock;
		}
		
		override public function executeCommand(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			return mock.executeCommand(clazz, body, note);
		}
		
		override public function get fabFacade():FabricationFacade {
			return mock.fabFacade;
		}
		
		override public function get fabrication():IFabrication {
			return mock.fabrication;
		}
		
		override public function get applicationRouter():IRouter {
			return mock.applicationRouter;
		}
		
		override public function registerCommand(notificationName:String, commandClassRef:Class):void {
			mock.registerCommand(notificationName, commandClassRef);
		}
		
		override public function removeCommand(notificationName:String):void {
			mock.removeCommand(notificationName);
		}
		
		override public function hasCommand(notificationName:String):Boolean {
			return mock.hasCommand(notificationName);
		}
		
		override public function registerProxy(proxy:IProxy):IProxy {
			return mock.registerProxy(proxy);
		}
		
		override public function retrieveProxy(proxyName:String):IProxy {
			return mock.retrieveProxy(proxyName);
		}
		
		override public function removeProxy(proxyName:String):IProxy {
			return mock.removeProxy(proxyName);
		}
		
		override public function hasProxy(proxyName:String):Boolean {
			return mock.hasProxy(proxyName);
		}
		
		override public function registerMediator(mediator:IMediator):IMediator {
			return mock.registerMediator(mediator);
		}
		
		override public function retrieveMediator(mediatorName:String):IMediator {
			return mock.retrieveMediator(mediatorName);
		}
		
		override public function hasMediator(mediatorName:String):Boolean {
			return mock.hasMediator(mediatorName);
		}
		
		override public function routeNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			mock.routeNotification(noteName, noteBody, noteType, to);
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		// SimpleCommand mocks
		override public function execute(note:INotification):void {
			executed = true;
			executedNote = note;
			
			var body:Function = note.getBody() as Function;
			if (body is Function) {
				var injectFunc:Function = body;
				var result:Boolean = injectFunc(mock);
				
				mock.execute(note);
				
				if (result) {
					Assert.oneAssertionHasBeenMade();
					mock.verify();
				}				
			}
			
			super.execute(note);
		}
		
		// Notifier mocks
		override public function initializeNotifier(key:String):void {
			mock.initializeNotifier(key);
		}
		
		override public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
			mock.sendNotification(notificationName, body, type);
		}
		
	}
}
