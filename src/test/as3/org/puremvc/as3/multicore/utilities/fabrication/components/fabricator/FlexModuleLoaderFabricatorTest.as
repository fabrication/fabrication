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
 
package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator {
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoaderMock;
	
	import mx.events.ModuleEvent;	

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
			
			verifyMock(fabricationMock);
			assertTrue(fabrication.hasEventListener(ModuleEvent.READY));
		}
		
	}
}
