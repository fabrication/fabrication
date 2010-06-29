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

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.events.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

    /**
     * @author Darshan Sawardekar
     */
    public class MediatorRegistrarEventTest extends BaseTestCase {

        private var mediatorRegistrarEvent:MediatorRegistrarEvent = null;

        [Before]
        public function setUp():void
        {
            mediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, new FlexMediator("foo", null));
        }

        [After]
        public function tearDown():void
        {
            mediatorRegistrarEvent.dispose();
            mediatorRegistrarEvent = null;
        }

        [Test]
        public function instantiation():void
        {

            assertType(MediatorRegistrarEvent, mediatorRegistrarEvent);
            assertType(Event, mediatorRegistrarEvent);
            assertType(IDisposable, mediatorRegistrarEvent);
        }

        [Test]
        public function mediatorRegistrarEventHasCompletedType():void
        {
            assertNotNull(MediatorRegistrarEvent.REGISTRATION_COMPLETED);
            assertType(String, MediatorRegistrarEvent.REGISTRATION_COMPLETED);
        }

        [Test]
        public function mediatorRegistrarEventHasCanceledType():void
        {
            assertNotNull(MediatorRegistrarEvent.REGISTRATION_CANCELED);
            assertType(String, MediatorRegistrarEvent.REGISTRATION_CANCELED);
        }

        [Test]
        public function mediatorRegistrarEventStoresType():void
        {
            assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, mediatorRegistrarEvent.type);
        }

        [Test]
        public function mediatorRegistrarEventStoresMediator():void
        {
            var mediator:FlexMediator = new FlexMediator("test", null);
            var mediatorRegistrarEvent:MediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, mediator);

            assertEquals(mediator, mediatorRegistrarEvent.mediator);
            assertType(FlexMediator, mediatorRegistrarEvent.mediator);
        }

        [Test(expects="Error")]
        public function mediatorRegistrarEventResetsAfterDisposal():void
        {
            mediatorRegistrarEvent = new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, new FlexMediator("foo", null));
            mediatorRegistrarEvent.dispose();

            assertNull(mediatorRegistrarEvent.mediator);
            mediatorRegistrarEvent.mediator.getMediatorName();
        }
    }
}
