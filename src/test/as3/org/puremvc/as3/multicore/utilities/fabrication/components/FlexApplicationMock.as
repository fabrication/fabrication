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
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	
	import com.anywebcam.mock.Mock;
	import com.hexagonstar.util.debug.Debug;

	/**
	 * @author Darshan Sawardekar
	 */
	public class FlexApplicationMock extends FlexApplication implements IMockable {

		public var _mock:Mock;
		
		public function FlexApplicationMock() {
			super();
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
		
		override public function get fabricator():ApplicationFabricator {
			return mock.fabricator;
		}
		
		override public function get moduleAddress():IModuleAddress {
			return mock.moduleAddress;
		}
		
		override public function get defaultRoute():String {
			return mock.defaultRoute;
		}
		
		override public function set defaultRoute(_defaultRoute:String):void {
			mock.defaultRoute = _defaultRoute;
		}
		
		override public function initializeFabricator():void {
			mock.initializeFabricator();
		}
		
		override public function getStartupCommand():Class {
			return mock.getStartupCommand();
		}
		
		override public function getClassByName(classpath:String):Class {
			return mock.getClassByName(classpath);
		}
		
		override public function get id():String {
			return mock.id;
		}
		
		override public function notifyFabricationCreated():void {
			mock.notifyFabricationCreated();
		}
		
		override public function notifyFabricationRemoved():void {
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
		
	}
}
