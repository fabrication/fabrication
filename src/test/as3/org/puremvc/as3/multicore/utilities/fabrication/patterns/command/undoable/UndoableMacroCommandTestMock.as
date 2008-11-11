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
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class UndoableMacroCommandTestMock extends UndoableMacroCommand {
		
		public var commandList:Array = new Array();
		
		public function UndoableMacroCommandTestMock() {
			super();
		}
		
		override public function executeCommand(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			if (note == null) {
				note = new Notification(null, body);
			}
			
			var command:ICommand = new clazz();
			command.initializeNotifier(multitonKey);
			
			if (command is IUndoableCommand) {
				(command as IUndoableCommand).initializeUndoableCommand(note);
			}
			
			command.execute(note);
			commandList.push(command);
			
			return command;
		}
		
		public function getUndoStack():Stack {
			return undoStack;
		}
		
		public function getRedoStack():Stack {
			return redoStack;
		}
		
	}
}
