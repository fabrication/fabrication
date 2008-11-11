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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	
	import mx.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;	

	/**
	 * @author Darshan Sawardekar
	 */
	dynamic public class ComponentResolverMock extends ComponentResolver {
		
		private var _mock:Mock;
		
		public function ComponentResolverMock(baseComponent:UIComponent, facade:FabricationFacade, routeMapper:ComponentRouteMapper):void {
			super(baseComponent, facade, routeMapper);
		}
		
		public function get mock():Mock {
			if (_mock == null) {
				_mock = new Mock(this, true);
			};
			
			return _mock;
		}
		
		override public function dispose():void {
			mock.dispose();
		}
		
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
		
		override public function setBaseExpression(baseExpression:Expression, multimode:Boolean = true):Expression {
			mock.setBaseExpression(baseExpression);
			return super.setBaseExpression(baseExpression);
		}
		
		override public function re(pattern:String, multimode:Boolean = true):Expression {
			return mock.re(pattern, multimode);
		}
		
		override public function rex(pattern:String, multimode:Boolean = true):Expression {
			return mock.rex(pattern, multimode);
		}
		
		override public function descendants(name:String, multimode:Boolean = false):Expression {
			return mock.descendants(name, multimode);
		}
		
		override public function resolve(name:String, multimode:Boolean = false):Expression {
			return mock.resolve(name, multimode);
		}
		
		override public function run():void {
			mock.run();
		}
		
		override public function getBaseComponent():IEventDispatcher {
			return mock.getBaseComponent();
		}
		
		override public function setMultimode(multimode:Boolean):void {
			mock.setMulimode(multimode);
		}
		
		override public function getMultimode():Boolean {
			return mock.getMultimode();
		}
		
		// Interesting, How do you mock the flash_proxy's callProperty... methods?
		// Currently the mock is on the corresponding method so its not so bad
		// because the implementation is an alias method anyway.
		/*
		override flash_proxy function callProperty(name:*, ...args):void {
			//mock.callProperty(name, args[0]);
		}
		*/
		
		
	}
}
