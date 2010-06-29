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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test {
    import flash.events.Event;

    import mx.modules.Module;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.ComponentsDataProvider;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.ModuleAwareTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.*;

    /**
     * @author Darshan Sawardekar
     */
    [RunWith("org.flexunit.runners.Parameterized")]
    dynamic public class ComponentRouteMapperTest extends ModuleAwareTestCase {


        public function ComponentRouteMapperTest(moduleUrl:String)
        {
            this.moduleUrl = moduleUrl;
        }

        public static var dataRetriever:ComponentsDataProvider = new ComponentsDataProvider("moduleLayouts.xml");

        [Parameters(loader="dataRetriever")]
        public static var componentsUrls:Array;

        [Test]
        public function testComponentRouteMapperHasValidType():void
        {
            var mapper:ComponentRouteMapper = new ComponentRouteMapper();
            assertType(ComponentRouteMapper, mapper);
            assertType(IDisposable, mapper);
        }

        [Test(async)]
        public function testComponentRoutesInModule():void
        {
            super.loadModule();
        }


        override protected function moduleReadyAsyncHandler(event:Event, passThroughData:Object = null):void
        {
            super.moduleReadyAsyncHandler(event, passThroughData);
            var module:Module = event.target as Module;
            assertType(moduleUrl, Module, module);
            assertTrue("Routes property not found in " + moduleUrl, module.hasOwnProperty("routes"));
            var routes:Array = module["routes"];
            assertType(moduleUrl, Array, routes);
            assertTrue("Routes array must not be empty in " + moduleUrl, routes.length > 0);
            var mapper:ComponentRouteMapper = createRouteMapper();
            var mappedRoutes:Array = mapper.fetchComponentRoutes(module);
            var expectedRoutesCount:int = routes.length;
            var mappedRoutesCount:int = mappedRoutes.length;
            var i:int;
            var expectedRoute:Object;
            var mappedRoute:ComponentRoute;
            assertEquals("Invalid mapped routes count.", expectedRoutesCount, mappedRoutesCount);
            routes.sortOn("id");
            mappedRoutes.sortOn("id");
            for (i = 0; i < expectedRoutesCount; i++) {
                expectedRoute = routes[i];
                mappedRoute = mappedRoutes[i];
                /* *
                 trace("Matching " +
                 "expectedRoute(" + expectedRoute.id + ", " + expectedRoute.path + ") vs " +
                 "actualRoute(" + mappedRoute.id + ", " + mappedRoute.path + ")"
                 );
                 /* */
                assertEquals(moduleUrl, expectedRoute.id, mappedRoute.id);
                assertEquals(moduleUrl, expectedRoute.path, mappedRoute.path);
            }
            assertTrue(mapper.hasCachedRoutes(module));
            assertEquals(mappedRoutes, mapper.fetchComponentRoutes(module));
        }

        private function createRouteMapper():ComponentRouteMapper
        {
            return new ComponentRouteMapper();
        }

        private function printRoutes(routes:Array):void
        {
            var n:int = routes.length;
            trace("Total Routes = " + n);

            var route:ComponentRoute;
            for (var i:int = 0; i < n; i++) {
                route = routes[i];
                trace("\t[" + route.id + " : " + route.path + "]");
            }
        }

    }
}
