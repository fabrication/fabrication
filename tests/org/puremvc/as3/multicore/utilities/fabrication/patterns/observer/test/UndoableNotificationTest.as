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
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.*;

    /**
     * @author Darshan Sawardekar
     */
    public class UndoableNotificationTest extends BaseTestCase {

        private var undoableNotification:UndoableNotification = null;
        private var body:Object = new Object();

        [Before]
        public function setUp():void
        {
            undoableNotification = new UndoableNotification(UndoableNotification.COMMAND_HISTORY_CHANGED, body, "test_type");
        }

        [After]
        public function tearDown():void
        {
            undoableNotification.dispose();
            undoableNotification = null;
        }

        [Test]
        public function testInstantiation():void
        {
            assertType(UndoableNotification, undoableNotification);
            assertType(INotification, undoableNotification);
            assertType(IDisposable, undoableNotification);
        }

        [Test]
        public function testUndoableNotificationHasCommandHistoryChangedName():void
        {
            assertNotNull(UndoableNotification.COMMAND_HISTORY_CHANGED);
            assertType(String, UndoableNotification.COMMAND_HISTORY_CHANGED);
        }

        [Test]
        public function testUndoableNotificationStoresUndoable():void
        {
            undoableNotification.undoable = true;
            assertTrue(undoableNotification.undoable);
            assertType(Boolean, undoableNotification.undoable);
        }

        [Test]
        public function testUndoableNotificationStoresRedoable():void
        {
            undoableNotification.redoable = true;
            assertTrue(undoableNotification.redoable);
            assertType(Boolean, undoableNotification.redoable);
        }

        [Test]
        public function testUndoableNotificationStoresUndoCommandName():void
        {
            undoableNotification.undoCommand = "Undo";
            assertEquals("Undo", undoableNotification.undoCommand);
            assertType(String, undoableNotification.undoCommand);
        }

        [Test]
        public function testUndoableNotificationStoresRedoCommand():void
        {
            undoableNotification.redoCommand = "Redo";
            assertEquals("Redo", undoableNotification.redoCommand);
            assertType(String, undoableNotification.redoCommand);
        }

        [Test]
        public function testUndoableNotificationStoresUndoCommandList():void
        {
            var commands:Array = new Array();
            undoableNotification.undoableCommands = commands;
            assertEquals(commands, undoableNotification.undoableCommands);
            assertType(Array, undoableNotification.undoableCommands);
        }

        [Test]
        public function testUndoableNotificationStoresRedoCommandList():void
        {
            var commands:Array = new Array();
            undoableNotification.redoableCommands = commands;
            assertEquals(commands, undoableNotification.redoableCommands);
            assertType(Array, undoableNotification.redoableCommands);
        }

        [Test]
        public function testUndoableNotificationStoresGroupID():void
        {
            assertProperty(undoableNotification, "groupID", String, null, "groupA");
        }

        [Test(expects="Error")]
        public function testUndoableNotificationResetsAfterDisposal():void
        {
            var undoableNotification:UndoableNotification = new UndoableNotification(UndoableNotification.COMMAND_HISTORY_CHANGED, body, "test_type");
            undoableNotification.dispose();

            assertNull(undoableNotification.getBody());
            assertNull(undoableNotification.getType());
            assertNull(undoableNotification.undoableCommands);
            assertNull(undoableNotification.redoableCommands);
            assertNull(undoableNotification.undoCommand);
            assertNull(undoableNotification.redoCommand);
            assertNull(undoableNotification.groupID);

            undoableNotification.getBody().constructor;
        }
    }
}
