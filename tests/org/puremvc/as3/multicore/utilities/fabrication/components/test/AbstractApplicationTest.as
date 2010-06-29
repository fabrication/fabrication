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

package org.puremvc.as3.multicore.utilities.fabrication.components.test {
    import flash.events.Event;

    import flash.utils.getQualifiedClassName;

    import org.flexunit.async.Async;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.module.EmptyFlexModuleStartupCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
    import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;

    /**
     * @author Darshan Sawardekar
     */
    public class AbstractApplicationTest extends BaseTestCase {

        private var dependency:EmptyFlexModuleStartupCommand;
        protected var fabrication:IFabrication;


        [Before]
        public function setUp():void
        {

            initializeFabrication();

        }

        [After]
        public function tearDown():void
        {

            fabrication = null;

        }

        [Test]
        public function fabricationTypeAndPropertiesTest():void
        {

            assertTrue(fabrication is IFabrication);
            assertTrue(fabrication is IDisposable);
            assertTrue(fabrication.fabricator is ApplicationFabricator);
            assertProperty(fabrication, "config", Object, null, {});
            assertNotNull(fabrication.fabricator);
            assertNotNull(fabrication.getStartupCommand());

        }

        [Test]
        public function fabricationHasFabricator():void {

            assertNotNull(fabrication.fabricator);
			assertType(ApplicationFabricator, fabrication.fabricator);
		}

        [Test]
        public function fabricationGetsModuleAddressFromItsFabricator():void
        {

            var moduleAddress:IModuleAddress = new ModuleAddress("A", "A0");
            fabrication.fabricator.moduleAddress = moduleAddress;
            assertEquals(fabrication.moduleAddress, moduleAddress);

        }

        [Test]
        public function fabricationGetsDefaultRouteFromItsFabricator():void
        {

            var defaultRoute:String = "X/*";
            fabrication.fabricator.defaultRoute = defaultRoute;
            assertProperty(fabrication, "defaultRoute", String, defaultRoute, "Y/*");

        }

        [Test]
        public function fabricationGetsRouterFromItsFabricator():void
        {
            var router:IRouter = new Router();
            fabrication.fabricator.router = router;

            assertProperty(fabrication, "router", IRouter, router, new Router());
        }

        [Test]
        public function fabricationGetsModuleGroupFromItsFabricator():void
        {
            fabrication.fabricator.moduleGroup = "myGroup";
            assertProperty(fabrication, "moduleGroup", String, "myGroup", "myNewGroup");
        }

        [Test]
        public function fabricationProvidesItsStartupCommand():void {

			assertTrue((fabrication as Object).hasOwnProperty("getStartupCommand"));
		}

        [Test]
		public function fabricationHasGetClassByNameImplementation():void {

			var classpath:String = getQualifiedClassName(AbstractApplicationTest);
			assertEquals(AbstractApplicationTest, fabrication.getClassByName(classpath));
		}

        [Test]
        public function testFabricationStoresConfigurationObject():void {

            assertProperty(fabrication, "config", Object, null, new Object());
		}

        [Test(async)]
        public function checkForStartUpEvent():void
        {

            var readyHandler:Function = Async.asyncHandler(this, onApplicationReady, 200, null, timeOutHandler);
            var removedHandler:Function = Async.asyncHandler(this, onApplicationRemove, 200, null, timeOutHandler);
            fabrication.addEventListener(FabricatorEvent.FABRICATION_CREATED, readyHandler, false, 0, true);
            fabrication.addEventListener(FabricatorEvent.FABRICATION_REMOVED, removedHandler, false, 0, true);
            fabrication.dispatchEvent(getReadyEvent());
            fabrication.dispose();
        }

        private function onApplicationReady(event:Event, passThroughData:Object = null):void
        {
            assertEquals(event.target, fabrication);
            assertTrue(event is FabricatorEvent);
            assertEquals(event.type, FabricatorEvent.FABRICATION_CREATED);
        }

        private function onApplicationRemove(event:Event, passThroughData:Object = null):void
        {
            assertEquals(event.target, fabrication);
            assertTrue(event is FabricatorEvent);
            assertEquals(event.type, FabricatorEvent.FABRICATION_REMOVED);
        }

        protected function initializeFabrication():void
        {

        }


        protected function getReadyEvent():Event
        {

            return null;
        }

        private function timeOutHandler(event:Event):void
        {
            fail("Timeout error");
        }

    }
}
