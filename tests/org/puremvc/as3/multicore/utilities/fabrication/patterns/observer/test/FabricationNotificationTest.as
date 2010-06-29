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
    import mx.core.FlexGlobals;

    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.*;

    import spark.components.Application;

    /**
     * @author Darshan Sawardekar
     */
    public class FabricationNotificationTest extends BaseTestCase {

        private var fabricationNotification:FabricationNotification = null;


        [Before]
        public function setUp():void
        {
            fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, FlexGlobals.topLevelApplication as Application, "test");
        }

        [After]
        public function tearDown():void
        {
            fabricationNotification.dispose();
            fabricationNotification = null;
        }

        [Test]
        public function testInstantiation():void
        {
            assertType(FabricationNotification, fabricationNotification);
            assertType(INotification, fabricationNotification);
            assertType(IDisposable, fabricationNotification);
        }

        [Test]
        public function testFabricationNotificationHasStartupName():void
        {
            assertNotNull(FabricationNotification.STARTUP);
            assertType(String, FabricationNotification.STARTUP);
        }

        [Test]
        public function testFabricationNotificationHasShutdownName():void
        {
            assertNotNull(FabricationNotification.SHUTDOWN);
            assertType(String, FabricationNotification.SHUTDOWN);
        }

        [Test]
        public function testFabricationNotificationHasBootstrapName():void
        {
            assertNotNull(FabricationNotification.BOOTSTRAP);
            assertType(String, FabricationNotification.BOOTSTRAP);
        }

        [Test]
        public function testFabricationNotificationHasUndoName():void
        {
            assertNotNull(FabricationNotification.UNDO);
            assertType(String, FabricationNotification.UNDO);
        }

        [Test]
        public function testFabricationNotificationHasRedoName():void
        {
            assertNotNull(FabricationNotification.REDO);
            assertType(String, FabricationNotification.REDO);
        }

        [Test]
        public function testFabricationNotificationStoresName():void
        {
            assertEquals(FabricationNotification.STARTUP, fabricationNotification.getName());
            assertType(String, fabricationNotification.getName());
        }

        [Test]
        public function testFabricationNotificationStoresBody():void
        {
            fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, FlexGlobals.topLevelApplication as Application, "test");

            assertEquals(FlexGlobals.topLevelApplication as Application, fabricationNotification.getBody());
        }

        [Test]
        public function testFabricationNotificationStoresType():void
        {
            assertEquals("test", fabricationNotification.getType());
            assertType(String, fabricationNotification.getType());
        }

        [Test(expects="Error")]
        public function testFabricationNotificationResetsAfterDisposal():void
        {
            fabricationNotification = new FabricationNotification(FabricationNotification.STARTUP, FlexGlobals.topLevelApplication as Application, "test");
            fabricationNotification.dispose();

            assertNull(fabricationNotification.getBody());
            fabricationNotification.getBody().constructor;
        }
    }
}
