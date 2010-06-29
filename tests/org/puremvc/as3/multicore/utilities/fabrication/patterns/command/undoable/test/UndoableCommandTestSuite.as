package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.test {
    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class UndoableCommandTestSuite {

        public var simpleUndoableCommandTest:SimpleUndoableCommandTest;
        public var fabricationUndoCommandTest:FabricationUndoCommandTest;
        public var fabricationRedoCommandTest:FabricationRedoCommandTest;
        public var undoableMacroCommandTest:UndoableMacroCommandTest;
        public var changeUndoGroupCommand:ChangeUndoGroupCommandTest;

    }
}