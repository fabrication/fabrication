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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable {
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AbstractFabricationCommandTest;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class AbstractUndoableCommandTest extends AbstractFabricationCommandTest {
		
		public function AbstractUndoableCommandTest(method:String) {
			super(method);
		}
		
		override public function createCommand():ICommand {
			return new AbstractUndoableCommandTestMock();
		}
		
		public function testAbstractUndoableCommandHasValidType():void {
			assertType(AbstractUndoableCommand, command);
			assertType(SimpleFabricationCommand, command);
		}
		
		public function testAbstractUndoableCommandStoresPrefixNames():void {
			assertNotNull(AbstractUndoableCommand.UNDO_PREFIX);
			assertNotNull(AbstractUndoableCommand.REDO_PREFIX);
			assertType(String, AbstractUndoableCommand.UNDO_PREFIX);
			assertType(String, AbstractUndoableCommand.REDO_PREFIX);
		}
		
		public function testAbstractUndoableCommandStoresNotificationOnInitialization():void {
			executeCommand();
			assertEquals(notification, undoCommand.getNotification());
		}
		
		public function testAbstractUndoableCommandIsNotMergeableByDefault():void {
			assertFalse(undoCommand.merge(new AbstractUndoableCommandTestMock()));
		}
		
		public function testAbstractUndoableCommandHasValidDescription():void {
			assertEquals("Abstract Undoable Test Mock", undoCommand.getDescription());
		}
		
		public function testAbstractUndoableCommandHasValidPresentationNames():void {
			assertEquals("Abstract Undoable Test Mock", undoCommand.getPresentationName());
			assertEquals(AbstractUndoableCommand.UNDO_PREFIX + "Abstract Undoable Test Mock", undoCommand.getUndoPresentationName());
			assertEquals(AbstractUndoableCommand.REDO_PREFIX + "Abstract Undoable Test Mock", undoCommand.getRedoPresentationName());
		}
		
		public function testAbstractUndoableCommandResetsAfterDisposal():void {
			executeCommand();
			undoCommand.dispose();
			
			assertNull(undoCommand.getNotification());
		}
		
	}
}
