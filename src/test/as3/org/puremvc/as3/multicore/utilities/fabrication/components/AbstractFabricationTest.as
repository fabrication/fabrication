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
	import flexunit.framework.SimpleTestCase;
	
	import com.anywebcam.mock.Mock;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.EventListenerMock;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class AbstractFabricationTest extends SimpleTestCase {
		
		public var fabrication:IFabrication;
		public var fabricator:ApplicationFabricator;
		public var fabricatorMock:Mock;
		
		public function AbstractFabricationTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			initializeFabrication();
			initializeFabricator();
		}
		
		override public function tearDown():void {
			fabrication.dispose();
		}
		
		public function initializeFabrication():void {
			
		}
		
		public function initializeFabricator():void {
			fabricator = fabrication.fabricator;
		}
		
		public function get readyEventName():String {
			return null;
		}
		
		public function get readyEvent():Event {
			return null;
		}
		
		public function testFabricationHasValidType():void {
			assertType(IFabrication, fabrication);
			assertType(IDisposable, fabrication);
		}
		
		public function testFabricationHasFabricator():void {
			assertNotNull(fabrication.fabricator);
			assertType(ApplicationFabricator, fabrication.fabricator);
		}
		
		public function testFabricationGetsModuleAddressFromItsFabricator():void {
			var moduleAddress:IModuleAddress = new ModuleAddress("A", "A0"); 
			fabricator.moduleAddress = moduleAddress;
			
			assertEquals(fabrication.moduleAddress, moduleAddress);
		}
		
		public function testFabricationGetsDefaultRouteFromItsFabricator():void {
			var defaultRoute:String = "X/*";
			fabricator.defaultRoute = defaultRoute;
			
			assertProperty(fabrication, "defaultRoute", String, defaultRoute, "Y/*");
		}
		
		public function testFabricationGetsRouterFromItsFabricator():void {
			var router:IRouter = new Router();
			fabricator.router = router;
			
			assertProperty(fabrication, "router", IRouter, router, new Router());
		}
		
		public function testFabricationProvidesItsStartupCommand():void {
			assertTrue((fabrication as Object).hasOwnProperty("getStartupCommand"));
			assertNull(fabrication.getStartupCommand());
		}
		
		public function testFabricationHasGetClassByNameImplementation():void {
			var classpath:String = getQualifiedClassName(AbstractFabricationTest);
			assertEquals(AbstractFabricationTest, fabrication.getClassByName(classpath));
		}
		
		public function testFabricationSendsCreatedEventOnceFabricatorIsReady():void {
			var eventListener:EventListenerMock = new EventListenerMock(fabrication, FabricatorEvent.FABRICATION_CREATED);
			eventListener.mock.method("handle").withArgs(
				function(event:Event):Boolean {
					assertType(FabricatorEvent, event);
					assertEquals(FabricatorEvent.FABRICATION_CREATED, event.type);
				return true;
				}
			).once;
			
			fabrication.dispatchEvent(readyEvent);
			verifyMock(eventListener.mock);
		}
		
		public function testFabricationSendsRemovedEventOnceFabricatorIsDisposed():void {
			var fabrication:IFabrication = new FlexApplication();
			var fabricator:ApplicationFabricator = fabrication.fabricator;
			
			var eventListener:EventListenerMock = new EventListenerMock(fabrication, FabricatorEvent.FABRICATION_REMOVED);
			eventListener.mock.method("handle").withArgs(
				function(event:Event):Boolean {
					assertType(FabricatorEvent, event);
					assertEquals(FabricatorEvent.FABRICATION_REMOVED, event.type);
				return true;
				}
			).once;
			
			fabrication.dispatchEvent(readyEvent);
			fabrication.dispose();
			
			verifyMock(eventListener.mock);
		}
		
		public function testFabricationStoresConfigurationObject():void {
			assertProperty(fabrication, "config", Object, null, new Object());
		}
	}
}
