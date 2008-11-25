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
 
package org.puremvc.as3.multicore.utilities.fabrication.components {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationMock extends EventDispatcher implements IFabrication, IMockable {

		public var _mock:Mock;

		public function FabricationMock() {
			super();
		}

		public function dispose():void {
			
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			}
			
			return _mock;
		}

		public function get fabricator():ApplicationFabricator {
			return mock.fabricator;
		}

		public function get moduleAddress():IModuleAddress {
			return mock.moduleAddress;
		}

		public function get defaultRoute():String {
			return mock.defaultRoute;
		}

		public function set defaultRoute(_defaultRoute:String):void {
			mock.defaultRoute = _defaultRoute;
		}

		public function get defaultRouteAddress():IModuleAddress {
			return mock.defaultRouteAddress;
		}

		public function set router(router:IRouter):void {
			mock.router = router;
		}

		public function get router():IRouter {
			return mock.router;
		}

		public function initializeFabricator():void {
			mock.initializeFabricator();
		}

		public function getStartupCommand():Class {
			return mock.getStartupCommand();
		}

		public function getClassByName(classpath:String):Class {
			mock.getClassByName(classpath);
			return getDefinitionByName(classpath) as Class;
		}

		public function get id():String {
			return mock.id;
		}

		public function notifyFabricationCreated():void {
			mock.notifyFabricationCreated();
		}

		public function notifyFabricationRemoved():void {
			mock.notifyFabricationRemoved();
		}

		// EventDispatcher mocks
		override public function dispatchEvent(event:Event):Boolean {
			mock.dispatchEvent(event);
			return super.dispatchEvent(event);
		}

		override public function willTrigger(type:String):Boolean {
			return mock.willTrigger(type);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (!useCapture) {
				mock.removeEventListener(type, listener);
			} else {
				mock.removeEventListener(type, listener, useCapture);
			}
			
			super.removeEventListener(type, listener);
		}

		override public function hasEventListener(type:String):Boolean {
			mock.hasEventListener(type);
			return super.hasEventListener(type);
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			if (!useCapture && priority == 0 && !useWeakReference) {
				mock.addEventListener(type, listener);
			} else {
				mock.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function get config():Object {
			return mock.config;
		}
		
		public function set config($config:Object):void {
			mock.config = $config;
		}
		
	}
}
