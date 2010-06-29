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
    import com.anywebcam.mock.Mock;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.IMockable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandTestMock;

    /**
     * @author Darshan Sawardekar
     */
    public class SimpleUndoableCommandTest extends AbstractFabricationCommandTest {

        override public function createCommand():ICommand
        {
            return new SimpleUndoableCommandTestMock();
        }
        
        [Test]
        public function simpleUndoableCommandHasValidType():void
        {
            assertType(SimpleUndoableCommand, undoCommand);
            assertType(AbstractUndoableCommand, undoCommand);
        }

        [Test]
        public function simpleUndoableCommandStoresBeginState():void
        {
            assertNull(simpleUndoableCommand.getBeginState());

            var state:Object = new Object();
            simpleUndoableCommand.saveBeginState(state);
            assertEquals(state, simpleUndoableCommand.getBeginState());
        }
       
        [Test]
        public function simpleUndoableCommandStoresCancelState():void
        {
            assertNull(simpleUndoableCommand.getCancelState());

            var state:Object = new Object();
            simpleUndoableCommand.saveCancelState(state);
            assertEquals(state, simpleUndoableCommand.getCancelState());
        }

        [Test]
        public function simpleUndoableCommandInvokesCommitWithBeginStateDuringInitialExecution():void
        {
            var beginState:Object = new Object();
            var mock:Mock = (simpleUndoableCommand as IMockable).mock;

            simpleUndoableCommand["mockState"] = true;
            mock.method("getBeginState").withNoArgs.returns(beginState).once;
            mock.method("commit").withArgs(beginState).once;

            executeCommand();

            verifyMock(mock);
        }

        [Test]
        public function simpleUndoableCommandInvokesCommitWithCancelStateDuringUndoExecution():void
        {
            var cancelState:Object = new Object();
            var mock:Mock = (simpleUndoableCommand as IMockable).mock;

            simpleUndoableCommand["mockState"] = true;
            executeCommand();

            mock.method("getCancelState").withNoArgs.returns(cancelState).once;
            mock.method("commit").withArgs(cancelState).once;

            unexecuteCommand();

            verifyMock(mock);
        }

        [Test]
        public function simpleUndoableCommandInvokerCommitWithBeginStateDuringRedoExecution():void
        {
            var beginState:Object = new Object();
            var cancelState:Object = new Object();
            var mock:Mock = (simpleUndoableCommand as IMockable).mock;

            simpleUndoableCommand["mockState"] = true;
            mock.method("getBeginState").withNoArgs.returns(beginState).atLeast(1);
            mock.method("getCancelState").withNoArgs.returns(cancelState).atLeast(1);

            executeCommand();
            unexecuteCommand();

            mock.method("commit").withArgs(beginState).once;
            executeCommand();

            verifyMock(mock);
        }

        [Test]
        public function simpleUndoableCommandResetsAfterDisposal():void
        {
            simpleUndoableCommand["mockState"] = false;
            simpleUndoableCommand.saveBeginState(new Object());
            simpleUndoableCommand.saveCancelState(new Object());

            simpleUndoableCommand.dispose();

            assertNull(simpleUndoableCommand.getBeginState());
            assertNull(simpleUndoableCommand.getCancelState());
        }

        public function get simpleUndoableCommand():SimpleUndoableCommand
        {
            return command as SimpleUndoableCommand;
        }

        

    }
}
