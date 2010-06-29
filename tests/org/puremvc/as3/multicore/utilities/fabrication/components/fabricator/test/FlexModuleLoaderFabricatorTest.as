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
 
package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.test {
    import mx.events.ModuleEvent;

    import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoader;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.*;
    import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;

    /**
	 * @author Darshan Sawardekar
	 */
	public class FlexModuleLoaderFabricatorTest extends AbstractApplicationFabricatorTest {

		/* *
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(new FlexModuleLoaderFabricatorTest("testFlexModuleLoaderFabricatorHasValidType"));
			return suite;
		}
		/* */
		
		public var moduleLoader:FlexModuleLoader;
		public var timeoutMS:int = 25000;
		public var emptyModuleUrl:String = "modules/empty_flex_module.swf";
		
		public function FlexModuleLoaderFabricatorTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			super.setUp();
		}

		override public function tearDown():void {
			super.tearDown();
		}

		override public function initializeFabrication():void {
			fabrication = new FlexModuleLoaderMock();
			initializeFabricationMock();
		}

		override public function initializeFabricator():void {
			fabricator = new FlexModuleLoaderFabricator(fabrication as FlexModuleLoader);
		}

		override public function initializeFabricationMock():void {
			super.initializeFabricationMock();
		}

		public function testFlexModuleLoaderFabricatorHasValidType():void {
			assertType(FlexModuleLoaderFabricator, fabricator);
		}

		public function testFlexModuleLoaderFabricatorUsesCorrectReadyEventName():void {
			initializeFabrication();
			
			fabricationMock.method("addEventListener").withArgs(ModuleEvent.READY, Function).atLeast(1);
			
			initializeFabricator();
			
			assertTrue(fabrication.hasEventListener(ModuleEvent.READY));
		}
		
		public function testFlexModuleLoaderFabricatorSavesConfigOnModule():void {
			var configObj:Object = new Object();
			
			var verifyConfig:Function = function(event:FabricatorEvent):void {
				assertNotNull(moduleLoader.module.config);
				assertEquals(configObj, moduleLoader.module.config);
			};
			
			moduleLoader = new FlexModuleLoader();
			moduleLoader.url = emptyModuleUrl;
			moduleLoader.addEventListener(FabricatorEvent.FABRICATION_CREATED, addAsync(verifyConfig, timeoutMS));
			moduleLoader.router = new Router();
			moduleLoader.config = configObj;
			moduleLoader.loadModule();
		}
		
		public function testFlexModuleLoaderFabricatorSavesModuleGroupOnModule():void {
			var moduleGroup:String = "myGroup";
			
			var verifyModuleGroup:Function = function(event:FabricatorEvent):void {
				assertNotNull(moduleLoader.module.moduleGroup);
				assertEquals(moduleGroup, moduleLoader.module.moduleGroup);
			};
			
			moduleLoader = new FlexModuleLoader();
			moduleLoader.url = emptyModuleUrl;
			moduleLoader.addEventListener(FabricatorEvent.FABRICATION_CREATED, addAsync(verifyModuleGroup, timeoutMS));
			moduleLoader.router = new Router();
			moduleLoader.moduleGroup = moduleGroup;
			moduleLoader.loadModule();
		}
		
	}
}
