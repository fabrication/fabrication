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
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.*;

    /**
     * @author Darshan Sawardekar
     */
    public class ComponentRouteTest extends BaseTestCase {

        public var route:ComponentRoute;


        [Before]
        public function setUp():void
        {
            route = new ComponentRoute(instanceName, instanceName + "Path");
        }

        [After]
        public function tearDown():void
        {
            route.dispose();
            route = null;
        }

        [Test]
        public function testComponentRouteTestHasValidType():void
        {
            assertType(ComponentRoute, route);
            assertType(IDisposable, route);
        }

        [Test]
        public function testComponentRouteStoresComponentID():void
        {
            assertProperty(route, "id", String, instanceName, "new_id");
        }

        [Test]
        public function testComponentRouteStoresComponentPath():void
        {
            assertProperty(route, "path", String, instanceName + "Path", "path.to.component");
        }

        [Test]
        public function testComponentRouteResetsAfterDisposal():void
        {
            var route:ComponentRoute = new ComponentRoute(instanceName, instanceName + "Path");
            route.dispose();

            assertNull(route.id);
            assertNull(route.path);
        }

    }
}
