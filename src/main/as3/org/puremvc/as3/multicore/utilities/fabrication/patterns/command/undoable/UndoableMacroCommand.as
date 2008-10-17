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
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.AbstractUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;	

	/**
	 * UndoableMacroCommand is the undoable fabrication command for grouping
	 * multiple undoable commands together under a single command. Commands
	 * will be undone in the reverse order that they were initially executed.
	 * 
	 * <p>
	 * To add sub commands to the macro command use the addSubCommand method.
	 * Subcommands must be added only in the initializeUndoableComamnd method.
	 * A super.initializeUndoableCommand must be called first in this method.  
	 * </p>
	 * 
	 * <p>
	 * The addSubCommand method supports associating a notification with the 
	 * sub command. The notification is optional, and if only a body is specified
	 * a notification object is created automatically at the time of execution. 
	 * </p>
	 * 
	 * @author Darshan Sawardekar
	 */
	public class UndoableMacroCommand extends AbstractUndoableCommand implements IUndoableCommand {

		/**
		 * Stores the subcommand classes and their corresponding notifications
		 */
		protected var subCommands:Array;

		/**
		 * The undoable command stack
		 */
		protected var undoStack:Stack;

		/**
		 * The redoable command stack
		 */
		protected var redoStack:Stack;

		/**
		 * Initializes the undo and redo stacks and the array of sub commands.
		 * Subclasses must override this method. The super.initializeUndoableCommand
		 * must be called first.
		 */
		override public function initializeUndoableCommand(notification:INotification):void {
			super.initializeUndoableCommand(notification);
			
			undoStack = new Stack();
			redoStack = new Stack();
			subCommands = new Array();
			
			// override and add subcommands in subclasses
		}

		/**
		 * Creates the subcommands and executes them if this is the first pass,
		 * else re-executes the commands from the redo stack. As the commands
		 * are executed they are pushed to the undo stack.
		 */
		override public function execute(note:INotification):void {
			var command:IUndoableCommand;
			
			if (redoStack.isEmpty()) {
				var commandClazz:Class;
				var n:int = subCommands.length;
				var internalNote:INotification;
				var internalBody:Object;
				var wrapper:Object;
				var commandNote:INotification;
				for (var i:int = 0;i < n; i++) {
					wrapper = subCommands[i];
					commandClazz = wrapper.clazz as Class;
					internalNote = wrapper.note as INotification;
					internalBody = wrapper.body as Object;
					
					if (internalNote != null) {
						commandNote = internalNote;
					} else {
						commandNote = note;
					}
					
					if (internalNote == null && internalBody != null) {
						// need to create a new notification for each subcommand
						// else the shared body will result in notification pollution
						commandNote = new Notification(null, internalBody);
					}
					
					command = executeCommand(commandClazz, commandNote) as IUndoableCommand;
					
					undoStack.push(command);
				}
			} else {
				while (!redoStack.isEmpty()) {
					command = redoStack.pop() as IUndoableCommand;
					command.execute(command.getNotification());
					undoStack.push(command);
				}
			}
		}

		/**
		 * Executes the commands on the undo stack and pushes them onto
		 * the redo stack.
		 */
		override public function unexecute(note:INotification):void {
			var command:IUndoableCommand;
			while (!undoStack.isEmpty()) {
				command = undoStack.pop() as IUndoableCommand;
				command.unexecute(command.getNotification());
				
				redoStack.push(command);
			}
		}

		/**
		 * Adds the commands and any corresponding notification and body
		 * to the subcommand store.
		 */
		public function addSubCommand(clazz:Class, body:Object = null, note:INotification = null):void {
			subCommands.push({clazz:clazz, body:body, note:note});
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.interfaces.IDisposable#dispose()
		 */
		override public function dispose():void {
			undoStack.dispose();
			undoStack = null;
			
			redoStack.dispose();
			redoStack = null;
			
			subCommands = null;
		}		 
	}
}
