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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.test {
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.AbstractUndoableCommandTestMock;

    /**
     * @author Darshan Sawardekar
     */
    public class AbstractUndoableCommandTest extends AbstractFabricationCommandTest {


        override public function createCommand():ICommand
        {
            return new AbstractUndoableCommandTestMock();
        }

        [Test]
        public function abstractUndoableCommandHasValidType():void
        {
            assertType(AbstractUndoableCommand, command);
            assertType(SimpleFabricationCommand, command);
        }

        [Test]
        public function abstractUndoableCommandStoresPrefixNames():void
        {
            assertNotNull(AbstractUndoableCommand.UNDO_PREFIX);
            assertNotNull(AbstractUndoableCommand.REDO_PREFIX);
            assertType(String, AbstractUndoableCommand.UNDO_PREFIX);
            assertType(String, AbstractUndoableCommand.REDO_PREFIX);
        }

        [Test]
        public function abstractUndoableCommandStoresNotificationOnInitialization():void
        {
            executeCommand();
            assertEquals(notification, undoCommand.getNotification());
        }

        [Test]
        public function abstractUndoableCommandIsNotMergeableByDefault():void
        {
            assertFalse(undoCommand.merge(new AbstractUndoableCommandTestMock()));
        }

        [Test]
        public function abstractUndoableCommandHasValidDescription():void
        {
            assertEquals("Abstract Undoable Test Mock", undoCommand.getDescription());
        }

        [Test]
        public function abstractUndoableCommandHasValidPresentationNames():void
        {
            assertEquals("Abstract Undoable Test Mock", undoCommand.getPresentationName());
            assertEquals(AbstractUndoableCommand.UNDO_PREFIX + "Abstract Undoable Test Mock", undoCommand.getUndoPresentationName());
            assertEquals(AbstractUndoableCommand.REDO_PREFIX + "Abstract Undoable Test Mock", undoCommand.getRedoPresentationName());
        }

        [Test]
        public function abstractUndoableCommandResetsAfterDisposal():void
        {
            executeCommand();
            undoCommand.dispose();

            assertNull(undoCommand.getNotification());
        }

    }
}
