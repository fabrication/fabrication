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

package org.puremvc.as3.multicore.utilities.fabrication.events.test {
    import flash.events.Event;

    import mx.core.UIComponent;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.events.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;

    /**
     * @author Darshan Sawardekar
     */
    public class ComponentResolverEventTest extends BaseTestCase {

        private var componentResolverEvent:ComponentResolverEvent = null;

        [Before]
        public function setUp():void
        {
            componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, new UIComponent(), true);
        }

        [After]
        public function tearDown():void
        {
            componentResolverEvent.dispose();
            componentResolverEvent = null;
        }

        [Test]
        public function instantiation():void
        {

            assertType(ComponentResolverEvent, componentResolverEvent);
            assertType(IDisposable, componentResolverEvent);
            assertType(Event, componentResolverEvent);
        }

        [Test]
        public function componentResolverEventHasResolvedType():void
        {
            assertNotNull(ComponentResolverEvent.COMPONENT_RESOLVED);
            assertType(String, ComponentResolverEvent.COMPONENT_RESOLVED);
        }

        [Test]
        public function componentResolverEventHasDesolvedType():void
        {
            assertNotNull(ComponentResolverEvent.COMPONENT_DESOLVED);
            assertType(String, ComponentResolverEvent.COMPONENT_DESOLVED);
        }

        [Test]
        public function componentResolverEventStoresType():void
        {
            assertEquals(ComponentResolverEvent.COMPONENT_RESOLVED, componentResolverEvent.type);
        }

        [Test]
        public function componentResolverEventStoresComponent():void
        {
            var component:UIComponent = new UIComponent();
            componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, component, true);
            assertEquals(component, componentResolverEvent.component);
            assertType(UIComponent, componentResolverEvent.component);
        }

        [Test]
        public function componentResolverEventStoresMultimode():void
        {
            assertType(Boolean, componentResolverEvent.multimode);
            assertEquals(true, componentResolverEvent.multimode);
        }

        [Test(expects="Error")]
        public function componentResolverEventResetsAfterDisposal():void
        {
            componentResolverEvent = new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, new UIComponent(), true);
            componentResolverEvent.dispose();

            assertNull(componentResolverEvent.component);
            componentResolverEvent.component.id;
        }
    }
}
