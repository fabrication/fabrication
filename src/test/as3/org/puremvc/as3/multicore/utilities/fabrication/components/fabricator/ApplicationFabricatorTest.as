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
	import flexunit.framework.SimpleTestCase;
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IMockable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock1;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
	
	import flash.events.Event;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class ApplicationFabricatorTest extends SimpleTestCase {

		/* *
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(new ApplicationFabricatorTest("testApplicationFabricatorHasValidClassNameAndInstanceName"));
			return suite;
		}
		/* */
		
		public var fabricator:ApplicationFabricator;
		public var fabrication:IFabrication;
		public var fabricatorMock:Mock;
		public var fabricationMock:Mock;
		public var facadeMock:Mock;
		
		public function ApplicationFabricatorTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			initializeFabrication();
			initializeFabricationMock();
			
			initializeFabricator();			
			initializeFabricatorMock();
		}
		
		public function initializeFabrication():void {
			fabrication = new FabricationMock();
			fabricationMock = fabrication["mock"];
		}
		
		public function initializeFabricationMock():void {
			fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock);
			fabricationMock.method("addEventListener").withArgs("mockReady", Function);
			fabricationMock.method("removeEventListener").withArgs("mockReady", Function);
			fabricationMock.method("notifyFabricationCreated").withNoArgs.once;
			fabricationMock.method("notifyFabricationRemoved").withNoArgs.once;
			fabricationMock.method("dispatchEvent").withArgs(Event);
		}
		
		public function initializeFabricator():void {
			fabricator = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			if (fabricator is IMockable) {
				fabricatorMock = (fabricator as IMockable).mock;
			}		
		}
		
		public function initializeFabricatorMock():void {
			facadeMock = (fabricator.facade as FabricationFacadeMock).mock;
		}
		
		public function usingMockFabrication():Boolean {
			return fabrication is IMockable;
		}
		
		public function usingMockFabricator():Boolean {
			return fabricator is IMockable;
		}
		
		override public function tearDown():void {
			/* *
			fabricatorMock.ignoreMissing = true;
			
			fabricationMock.ignoreMissing = true;
			facadeMock.ignoreMissing = true;
			
			fabricator = null;
			
			fabrication = null;
			/* */
		}
		
		public function testApplicationFabricatorHasValidType():void {
			assertType(ApplicationFabricator, fabricator);
			assertType(IRouterAwareModule, fabricator);
			assertType(IDisposable, fabricator);
		}
		
		public function testApplicationFabricatorInitializesInCorrectSequence():void {
			addInitSequenceMocks();
			
			fabrication.dispatchEvent(new Event("mockReady"));
			
			verifyMock(fabricatorMock);
		}
		
		public function testApplicationFabricatorForwardsCreatedEventWhenApplicationIsReady():void {
			addInitSequenceMocks();
			
			fabricationMock.method("notifyFabricationCreated").withNoArgs.once;
			fabrication.dispatchEvent(new Event("mockReady"));
			
			verifyMock(fabricatorMock);
			verifyMock(facadeMock);
		}

		public function testApplicationFabricatorForwardsRemovedEventWhenApplicationIsDisposed():void {
			var fabrication:FabricationMock = new FabricationMock();
			var fabricationMock:Mock = fabrication.mock;
			fabricationMock.ignoreMissing = true;
			
			var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			var fabricatorMock:Mock = fabricator.mock;		
			fabricatorMock.ignoreMissing = true;
			fabricatorMock.method("notifyFabricationRemoved").withNoArgs.once;
			
			var facadeMock:Mock = (fabricator.facade as FabricationFacadeMock).mock;
			facadeMock.ignoreMissing = true;
			
			fabrication.dispatchEvent(new Event("mockReady"));
			fabricator.dispose();
			
			verifyMock(fabricatorMock);
		}

		public function addInitSequenceMocks():void {
			fabricatorMock.method("initializeModuleAddress").withNoArgs.once.ordered();
			fabricatorMock.method("initializeFacade").withNoArgs.once.ordered();
			fabricatorMock.method("initializeEnvironment").withNoArgs.once.ordered();
			fabricatorMock.method("startApplication").withNoArgs.once.ordered();
			fabricatorMock.method("notifyFabricationCreated").withNoArgs.once.ordered();
			
			facadeMock.method("startup").withArgs(fabrication.getStartupCommand(), fabrication);
		}
		
		public function testApplicationFabricatorGetsStartupCommandFromItsFabrication():void {
			var fabrication:FabricationMock = new FabricationMock();
			var fabricationMock:Mock = fabrication.mock;
			fabricationMock.ignoreMissing = true;
			fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock);
			
			var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			var fabricatorMock:Mock = fabricator.mock;		
			fabricatorMock.ignoreMissing = true;
			
			var facadeMock:Mock = (fabricator.facade as FabricationFacadeMock).mock;
			facadeMock.ignoreMissing = true;
			
			assertNotNull(fabricator.startupCommand);
			assertEquals(SimpleFabricationCommandMock, fabricator.startupCommand);
			assertEquals(fabrication.getStartupCommand(), fabricator.startupCommand);
		}
		
		public function testApplicationFabricatorStoresCorrectFabrication():void {
			var fabrication:FabricationMock = new FabricationMock();
			var fabricationMock:Mock = fabrication.mock;
			fabricationMock.ignoreMissing = true;
			
			var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			var fabricatorMock:Mock = fabricator.mock;		
			fabricatorMock.ignoreMissing = true;
			
			var facadeMock:Mock = (fabricator.facade as FabricationFacadeMock).mock;
			facadeMock.ignoreMissing = true;
			
			assertNotNull(fabricator.fabrication);
			assertEquals(fabrication, fabricator.fabrication);
		}
		
		public function testApplicationFabricatorStoresModuleAddress():void {
			assertProperty(fabricator, "moduleAddress", IModuleAddress, null, new ModuleAddress("A", "A0"));
		}
		
		public function testApplicationFabricatorGetsIdFromItsFabrication():void {
			fabricationMock.property("id").returns(methodName);
			assertNotNull(fabricator.id);
			assertEquals(methodName, fabrication.id);
		}
		
		public function testApplicationFabricatorStoresDefaultRoute():void {
			assertProperty(fabricator, "defaultRoute", String, null, "*");
		}
		
		public function testApplicationFabricatorHasValidClassNameAndInstanceName():void {
			var fabrication:FabricationMock = new FabricationMock();
			var fabricationMock:Mock = fabrication.mock;
			fabricationMock.ignoreMissing = true;
			fabricationMock.method("getStartupCommand").withNoArgs.returns(SimpleFabricationCommandMock1);
			
			var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			var fabricatorMock:Mock = fabricator.mock;		
			fabricatorMock.ignoreMissing = true;
			
			var facadeMock:Mock = (fabricator.facade as FabricationFacadeMock).mock;
			facadeMock.ignoreMissing = true;
			
			assertEquals(SimpleFabricationCommandMock1, fabricator.startupCommand);
			assertNotNull(fabricator.applicationClassName);
			assertEquals("SimpleFabricationMock1", fabricator.applicationClassName);
			
			assertContained("SimpleFabricationMock1", fabricator.applicationInstanceName);
			assertMatch(new RegExp("SimpleFabricationMock1[0-9]+", ""), fabricator.applicationInstanceName);
		}
		
		public function testApplicationFabricatorStoresRouter():void {
			assertProperty(fabricator, "router", IRouter, null, new Router());
		}
		
		public function testApplicationFabricatorResetsAfterDisposal():void {
			var fabrication:FabricationMock = new FabricationMock();
			var fabricationMock:Mock = fabrication.mock;
			fabricationMock.ignoreMissing = true;
			
			var fabricator:ApplicationFabricatorMock = new ApplicationFabricatorMock(fabrication, {readyEventName:"mockReady"});
			var fabricatorMock:Mock = fabricator.mock;		
			fabricatorMock.ignoreMissing = true;
			
			var facadeMock:Mock = (fabricator.facade as FabricationFacadeMock).mock;
			facadeMock.ignoreMissing = true;
			
			fabricator.dispose();
			
			assertNull(fabricator.facade);
			assertNull(fabricator.router);
		}
	}
}
