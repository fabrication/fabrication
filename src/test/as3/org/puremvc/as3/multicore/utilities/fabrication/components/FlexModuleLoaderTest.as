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
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.EventListenerMock;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
	
	import mx.events.ModuleEvent;
	
	import flash.events.Event;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FlexModuleLoaderTest extends AbstractFabricationTest {
		
		public var moduleLoader:FlexModuleLoader;
		public var timeoutMS:int = 25000;
		public var emptyModuleUrl:String = "modules/empty_flex_module.swf";
		
		public function FlexModuleLoaderTest(method:String) {
			super(method);
		}
		
		override public function tearDown():void {
			
		}
		
		override public function initializeFabrication():void {
			fabrication = new FlexModuleLoader();
			fabrication.router = new Router();
			
			moduleLoader = fabrication as FlexModuleLoader;
		}
		
		override public function get readyEventName():String {
			return ModuleEvent.READY;
		}
		
		override public function get readyEvent():Event {
			return new ModuleEvent(readyEventName);
		}
		
		public function testFlexModuleLoaderHasValidType():void {
			assertType(FlexModuleLoader, fabrication);
		}
		
		override public function testFabricationSendsCreatedEventOnceFabricatorIsReady():void {
			var verifyCreated:Function = function(event:FabricatorEvent):void {
				assertType(FabricatorEvent, event);
				assertEquals(FabricatorEvent.FABRICATION_CREATED, event.type);
			};
			
			moduleLoader.url = emptyModuleUrl;
			moduleLoader.addEventListener(FabricatorEvent.FABRICATION_CREATED, addAsync(verifyCreated, timeoutMS));
			moduleLoader.loadModule();
		}
		
		override public function testFabricationSendsRemovedEventOnceFabricatorIsDisposed():void {
			var verifyRemoved:Function = function(event:FabricatorEvent):void {
				assertType(FabricatorEvent, event);
				assertEquals(FabricatorEvent.FABRICATION_REMOVED, event.type);
			};
			
			var verifyRemovedAsync:Function = addAsync(verifyRemoved, timeoutMS);
			
			var verifyCreated:Function = function(event:FabricatorEvent):void {
				moduleLoader.addEventListener(FabricatorEvent.FABRICATION_REMOVED, verifyRemovedAsync);
				moduleLoader.dispose();
			};
			
			moduleLoader.url = emptyModuleUrl;
			moduleLoader.addEventListener(FabricatorEvent.FABRICATION_CREATED, verifyCreated);
			moduleLoader.loadModule();
		}
		
	}
}
