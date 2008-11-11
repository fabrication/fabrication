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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediatorMock extends FabricationMediator implements IMockable {
		
		static public const NAME:String = "FabricationMockMediator";
		public var _mock:Mock;

		public function FabricationMediatorMock(name:String = null, viewComponent:Object = null) {
			super(name, viewComponent);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this);				
			}
			
			return _mock;
		}		
		
		override public function dispose():void {
			mock.dispose();
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
		
		override public function get applicationAddress():IModuleAddress {
			return mock.applicationAddress;
		}
		
		override public function retrieveProxy(proxyName:String):IProxy {
			return mock.retrieveProxy(proxyName);
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
		
		override public function initializeNotifier(key:String):void {
			mock.initializeNotifier(key);
		}
		
		override public function listNotificationInterests():Array {
			return mock.listNotificationInterests();
		}
		
		override public function handleNotification(note:INotification):void {
			mock.handleNotification(note);
		}
		
		override public function qualifyNotificationInterests():Object {
			return mock.qualifyNotificationInterests;
		}
		
		override public function isNotificationQualified(noteName:String):Boolean {
			return mock.isNotificationQualified(noteName);
		}
		
		override public function getNotificationQualification(noteName:String):String {
			return mock.getNotificationQualification(noteName);
		}
		
		override protected function invokeNotificationHandler(name:String, note:INotification):void {
			mock.invokeNotificationHandler(name, note);
		}
		
	}
}
