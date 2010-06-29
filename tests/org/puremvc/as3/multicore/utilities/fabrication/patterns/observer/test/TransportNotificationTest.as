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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.test {
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.*;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;

    /**
     * @author Darshan Sawardekar
     */
    public class TransportNotificationTest extends BaseTestCase {

        public var notification:TransportNotification;

        [Before]
        public function setUp():void
        {
            notification = new TransportNotification("noteName", "noteBody", "noteType", "X/X0/INPUT");
        }

        [After]
        public function tearDown():void
        {
            notification.dispose();
        }

        [Test]
        public function testTransportNotificationHasValidType():void
        {
            assertType(TransportNotification, notification);
            assertType(INotification, notification);
            assertType(IDisposable, notification);
        }

        [Test]
        public function testTransportNotificationConstructorWithAllArguments():void
        {
            var notification:TransportNotification = new TransportNotification("A0", "A1", "A2", "A3");
            assertEquals("A0", notification.getName());
            assertEquals("A1", notification.getBody());
            assertEquals("A2", notification.getType());
            assertEquals("A3", notification.getTo());
        }

        [Test]
        public function testTransportNotificationConstructorWithOnlyCustomNotification():void
        {
            var customNotification:INotification = new Notification("B0");
            var notification:TransportNotification = new TransportNotification(customNotification);

            assertEquals(customNotification, notification.getCustomNotification());
            assertEquals("B0", notification.getName());
            assertNull(notification.getBody());
            assertNull(notification.getType());
            assertNull(notification.getTo());
        }

        [Test]
        public function testTransportNotificationConstructorWithCustomNotificationAndToDestinationInOwnToArgument():void
        {
            var customNotification:INotification = new Notification("B0");
            var notification:TransportNotification = new TransportNotification(customNotification, null, null, "R/R0/INPUT");

            assertEquals(customNotification, notification.getCustomNotification());
            assertEquals("B0", notification.getName());
            assertEquals("R/R0/INPUT", notification.getTo());
            assertNull(notification.getBody());
            assertNull(notification.getType());
        }

        [Test]
        public function testTransportNotificationConstructorWithCustomNotificationAndToDestinationAsBodyArgument():void
        {
            var customNotification:INotification = new Notification("L0");
            var notification:TransportNotification = new TransportNotification(customNotification, "X/X0/INPUT");

            assertEquals(customNotification, notification.getCustomNotification());
            assertEquals("L0", notification.getName());
            assertEquals("X/X0/INPUT", notification.getTo());
            assertNull(notification.getBody());
            assertNull(notification.getType());
        }

        [Test]
        public function testTransportNotificationSavesToDestinationAddressOfStringAndModuleAddressTypes():void
        {
            assertGetterAndSetter(notification, "to", String, "X/X0/INPUT", "N/N0/INPUT");

            var initialModuleAddress:IModuleAddress = new ModuleAddress("M", "M0");
            notification.setTo(initialModuleAddress);
            assertGetterAndSetter(notification, "to", IModuleAddress, initialModuleAddress, new ModuleAddress("O", "O0"));
        }

        [Test]
        public function testTransportNotificatonResetsAfterDisposal():void
        {
            var customNotification:INotification = new Notification("B0");
            var notification:TransportNotification = new TransportNotification(customNotification);

            notification.dispose();

            assertNull(notification.getCustomNotification());
            assertNull(notification.getBody());
            assertNull(notification.getType());
            assertNull(notification.getTo());
        }

    }
}
