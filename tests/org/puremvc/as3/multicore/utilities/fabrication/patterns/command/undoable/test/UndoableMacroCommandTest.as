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
    import flash.utils.getQualifiedClassName;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.test.AbstractFabricationCommandTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandMock1;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandMock2;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandMock3;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandMock4;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.SimpleUndoableCommandMock5;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.mock.UndoableMacroCommandTestMock;

    /**
     * @author Darshan Sawardekar
     */
    public class UndoableMacroCommandTest extends AbstractFabricationCommandTest {

        public var commandsToLink:Array = [
            SimpleUndoableCommandMock1,
            SimpleUndoableCommandMock2,
            SimpleUndoableCommandMock3,
            SimpleUndoableCommandMock4,
            SimpleUndoableCommandMock5
        ];

        [Test]
        public function undoableMacroCommandHasValidType():void
        {
            assertType(UndoableMacroCommand, command);
            assertType(IUndoableCommand, command);
            assertType(AbstractUndoableCommand, command);
        }

        [Test]
        public function undoableMacroCommandAllowsAddingSubCommands():void
        {

            macroCommand.addSubCommand(SimpleUndoableCommandMock1);
            macroCommand.addSubCommand(SimpleUndoableCommandMock2);
            macroCommand.addSubCommand(SimpleUndoableCommandMock3);
            macroCommand.addSubCommand(SimpleUndoableCommandMock4);
            macroCommand.addSubCommand(SimpleUndoableCommandMock5);

        }

        [Test]
        public function undoableMacroCommandRunsInCorrectOrder():void
        {
            var sampleSize:int = 25;
            var commandList:Array;
            var i:int;

            macroCommand.addSubCommand(SimpleUndoableCommandMock1);
            macroCommand.addSubCommand(SimpleUndoableCommandMock2);
            macroCommand.addSubCommand(SimpleUndoableCommandMock3);
            macroCommand.addSubCommand(SimpleUndoableCommandMock4);
            macroCommand.addSubCommand(SimpleUndoableCommandMock5);

            for (i = 0; i < sampleSize; i++) {
                executeCommand();
                commandList = macroCommand.getUndoStack().getElements();
                verifyCommandsAreInAscendingOrder(commandList);

                unexecuteCommand();
                commandList = macroCommand.getRedoStack().getElements();
                verifyCommandsAreInDescendingOrder(commandList.slice());
            }
        }

        override public function createCommand():ICommand
        {
            return new UndoableMacroCommandTestMock();
        }

        public function get macroCommand():UndoableMacroCommandTestMock
        {
            return command as UndoableMacroCommandTestMock;
        }

        private function verifyCommandsAreInAscendingOrder(commands:Array):void
        {
            var indices:Array = calcCommandOrderFromInstances(commands);
            var ascOrder:Array = indices.slice().sort(Array.NUMERIC);

            assertArrayEquals("Invalid command execution order.", ascOrder, indices);
        }

        private function verifyCommandsAreInDescendingOrder(commands:Array):void
        {
            var indices:Array = calcCommandOrderFromInstances(commands);
            var descOrder:Array = indices.slice().sort(Array.NUMERIC | Array.DESCENDING);

            assertArrayEquals("Invalid command execution order.", descOrder, indices);
        }

        private function calcCommandOrderFromInstances(commands:Array):Array
        {
            var commandOrder:Array = new Array();
            var command:ICommand;
            var n:int = commands.length;
            var className:String;
            var re:RegExp = new RegExp(".*([0-9]+)$", "");
            var matchResult:Object;
            var index:int;

            for (var i:int = 0; i < n; i++) {
                command = commands[i];
                className = getQualifiedClassName(command);
                matchResult = re.exec(className);
                index = parseInt(matchResult[1]);

                commandOrder.push(index);
            }

            return commandOrder;
        }

    }
}
