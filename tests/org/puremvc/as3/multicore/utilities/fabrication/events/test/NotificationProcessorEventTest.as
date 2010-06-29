/**
 * Copyright (C) 2009 Darshan Sawardekar.
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
    import mx.utils.UIDUtil;

    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.events.*;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;

    /**
     * @author Darshan Sawardekar
     */
    public class NotificationProcessorEventTest extends BaseTestCase {

        public var event:NotificationProcessorEvent;

        private var noteName:String = UIDUtil.createUID();

        [Before]
        public function setUp():void
        {
            event = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED);
        }

        [After]
        public function tearDown():void
        {
            event.dispose();
            event = null;
        }

        [Test]
        public function notificationProcessorEventHasValidType():void
        {
            assertType(NotificationProcessorEvent, event);
            assertType(IDisposable, event);
        }

        [Test]
        public function notificationProcessorEventHasProceedType():void
        {
            assertNotNull(NotificationProcessorEvent.PROCEED);
            assertType(String, NotificationProcessorEvent.PROCEED);
        }

        [Test]
        public function notificationProcessorEventHasAbortType():void
        {
            assertNotNull(NotificationProcessorEvent.ABORT);
            assertType(String, NotificationProcessorEvent.ABORT);
        }

        [Test]
        public function notificationProcessorEventHasFinishType():void
        {
            assertNotNull(NotificationProcessorEvent.FINISH);
            assertType(String, NotificationProcessorEvent.FINISH);
        }

        [Test]
        public function notificationProcessorEventConstructorStoresTypeAndNotification():void
        {
            var notification:Notification = new Notification(noteName);
            event = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED, notification);

            assertEquals(NotificationProcessorEvent.PROCEED, event.type);
            assertEquals(notification, event.notification);
        }

        [Test]
        public function notificationProcessorEventResetsOnDisposal():void
        {
            var event:NotificationProcessorEvent = new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED, new Notification(noteName));
            event.dispose();

            assertNull(event.notification);
        }
    }
}
