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
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock;
	
	import mx.events.FlexEvent;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FlexModuleFabricatorTest extends AbstractApplicationFabricatorTest {

		public function FlexModuleFabricatorTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			super.setUp();
		}

		override public function tearDown():void {
			super.tearDown();
		}

		override public function initializeFabrication():void {
			fabrication = new FlexModuleMock();
			initializeFabricationMock();
		}

		override public function initializeFabricator():void {
			fabricator = new FlexModuleFabricator(fabrication as FlexModule);
		}

		override public function initializeFabricationMock():void {
			super.initializeFabricationMock();
		}

		public function testFlexModuleFabricatorHasValidType():void {
			assertType(FlexModuleFabricator, fabricator);
		}

		public function testFlexModuleFabricatorUsesCorrectReadyEventName():void {
			initializeFabrication();
			
			fabricationMock.method("addEventListener").withArgs(FlexEvent.INITIALIZE, Function).atLeast(1);
			
			initializeFabricator();
			
			verifyMock(fabricationMock);
			assertTrue(fabrication.hasEventListener(FlexEvent.INITIALIZE));
		}
		
		public function testFlexModuleFabricatorGetsCorrectStartupCommand():void {
			initializeFabrication();
			fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock);
			initializeFabricator();
			
			verifyMock(fabricationMock);
			assertEquals(SimpleFabricationCommandMock, fabricator.startupCommand);
		}
		
		public function testFlexModuleFabricatorDoesNotHaveDefaultStartupCommand():void {
			assertNull(fabricator.startupCommand);
		}
		
	}
}
