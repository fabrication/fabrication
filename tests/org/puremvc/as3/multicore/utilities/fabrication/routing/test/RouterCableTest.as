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

package org.puremvc.as3.multicore.utilities.fabrication.routing.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.*;

    /**
     * @author Darshan Sawardekar
     */
    public class RouterCableTest extends BaseTestCase {

        private var routerCable:RouterCable = null;


        [Before]
        public function setUp():void
        {
            routerCable = new RouterCable(new NamedPipe("input"), new NamedPipe("output"));
        }

        [After]
        public function tearDown():void
        {
            routerCable.dispose();
            routerCable = null;
        }

        [Test]
        public function testRouterCableHasValidType():void
        {
            assertType(RouterCable, routerCable);
            assertType(IRouterCable, routerCable);
            assertType(IDisposable, routerCable);
        }

        [Test]
        public function testRouterCableStoresInputPipe():void
        {
            assertType(NamedPipe, routerCable.getInput());
            assertEquals("input", routerCable.getInput().getName());
        }

        [Test]
        public function testRouterCableStoresOutputPipe():void
        {
            assertType(NamedPipe, routerCable.getOutput());
            assertEquals("output", routerCable.getOutput().getName());
        }

    }
}
