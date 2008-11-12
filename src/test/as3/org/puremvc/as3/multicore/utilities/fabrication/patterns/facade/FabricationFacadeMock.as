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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.facade {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationFacadeMock extends FabricationFacade implements IMockable {

		static public function getInstance(key:String):FabricationFacadeMock {
			if (instanceMap[key] == null) {
				instanceMap[key] = new FabricationFacadeMock(key);
			}
			
			return instanceMap[key] as FabricationFacadeMock;
		}
		 
		private var _mock:Mock;
		
		public function FabricationFacadeMock(key:String) {
			super(key);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);	
			}
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
		override protected function initializeController():void {
			mock.initializeController();
		}
		
		override public function startup(startupCommand:Class, application:Object):void {
			mock.startup(startupCommand, application);
		}
		
		override public function get fabricationController():FabricationController {
			return mock.fabricationController;
		}
		
		override public function undo(steps:int = 1):void {
			mock.undo(steps);
		}
		
		override public function redo(steps:int = 1):void {
			mock.redo(steps);
		}
		
		override public function getFabrication():IFabrication {
			return mock.getFabrication();
		}
		
		override public function getApplicationName():String {
			return mock.getApplicationName();
		}
		
		override public function routeNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			mock.routeNotification(noteName, noteBody, noteType, to);
		}
		
		// IFacade mocks
		override protected function initializeFacade():void {
			mock.initializeFacade();
		}
		
		override protected function initializeModel():void {
			mock.initializeModel();
		}
		
		override protected function initializeView():void {
			mock.initializeView();
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
		
		override public function registerProxy(proxy:IProxy):void {
			mock.registerProxy(proxy);
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
		
		override public function registerMediator(mediator:IMediator):void {
			mock.registerMediator(mediator);
		}
		
		override public function retrieveMediator(mediatorName:String):IMediator {
			return mock.retrieveMediator(mediatorName);
		}
		
		override public function removeMediator(mediatorName:String):IMediator {
			return mock.removeMediator(mediatorName);
		} 
		
		override public function hasMediator(mediatorName:String):Boolean {
			return mock.hasMediator(mediatorName);
		}
		
		override public function sendNotification(noteName:String, body:Object = null, type:String = null):void {
			mock.sendNotification(noteName, body, type);
		}
		
		override public function notifyObservers(notification:INotification):void {
			mock.notifyObservers(notification);
		}
		
		override public function initializeNotifier(key:String):void {
			mock.initializeNotifier(key);
		}
		
		override public function saveInstance(key:String, instance:Object):Object {
			return mock.saveInstance(key, instance);
		}
		
		override public function findInstance(key:String):Object {
			return mock.findInstance(key);
		}
		
		override public function hasInstance(key:String):Object {
			return mock.hasInstance(key);
		}
		
		override public function removeInstance(key:String):Object {
			return mock.removeInstance(key);
		}
		
		override public function executeCommandClass(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			return mock.executeCommandClass(clazz, body, note);
		}
		
	}
}
