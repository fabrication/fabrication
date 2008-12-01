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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import org.puremvc.as3.multicore.core.Controller;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.observer.Observer;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.UndoableNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;	

	/**
	 * FabricationController is the custom controller used by fabrication.
	 * It provides undo management operations and the ability to map
	 * the same notification name to multiple commands.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationController extends Controller implements IDisposable {

		/**
		 * The default group id name.
		 */
		static public const DEFAULT_GROUP_ID:String = "default";

		/**
		 * Creates and returns the multiton instance of the controller for
		 * the specified multiton key.
		 * 
		 * @param key The multiton key whose controller is to be retrieved.
		 */
		static public function getInstance(key:String):FabricationController {
			if (instanceMap[key] == null) {
				instanceMap[key] = new FabricationController(key);
			}
			
			return instanceMap[key] as FabricationController;
		}

		/**
		 * The undoable command stack
		 */
		//protected var undoStack:Stack;
		
		/**
		 * The redoable command stack.
		 */
		//protected var redoStack:Stack;
		
		/**
		 * Stores the different undo groups in the controller. 
		 */
		protected var groupsHashMap:HashMap;

		/**
		 * The current undo-redo group id.
		 */
		protected var _groupID:String = DEFAULT_GROUP_ID;

		/**
		 * Creates the FabricationController and initializes the undo and
		 * redo stacks.
		 */
		public function FabricationController(key:String) {
			super(key);
			
			groupsHashMap = new HashMap();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			groupsHashMap.dispose();
			groupsHashMap = null;
			
			commandMap.splice(0);
			commandMap = null;		
			
			view = null;	
			
			removeController(multitonKey);
		}
		
		/**
		 * Overrides Controller to use the FabricationView
		 */
		override protected function initializeController():void {
			view = FabricationView.getInstance(multitonKey);
		} 

		/**
		 * Override registerCommand to support multiple commands mapped to
		 * the same notification.
		 */
		override public function registerCommand(notificationName:String, clazz:Class):void {
			var commandList:Array = commandMap[notificationName];
			if (commandList == null ) {
				commandList = commandMap[notificationName] = new Array();
				view.registerObserver(notificationName, new Observer(executeCommand, this));
			}
			
			commandList.push(clazz);
		}

		/**
		 * Overrides executeCommand to add the command to the undoStack
		 * if it is undoable.
		 */
		override public function executeCommand(note:INotification):void {
			var commandList:Array = commandMap[note.getName()];
			if (commandList == null) return;

			var n:int = commandList.length;
			var commandInstance:ICommand;
			var commandClassRef:Class;
			var undoableCommand:IUndoableCommand;
			for (var i:int = 0;i < n; i++) {
				commandClassRef = commandList[i] as Class;
				commandInstance = new commandClassRef();

				commandInstance.initializeNotifier(multitonKey);
				
				if (commandInstance is IUndoableCommand) {
					undoableCommand = commandInstance as IUndoableCommand;
					undoableCommand.initializeUndoableCommand(note);					
				}
				
				commandInstance.execute(note);
				
				if (commandInstance is IUndoableCommand) {
					addCommand(undoableCommand);
				} else if (commandInstance is IDisposable) {
					(commandInstance as IDisposable).dispose();
				}				
			}
		}
		
		/**
		 * Executes the command class specified and returns its instance.
		 * 
		 * @param clazz The command class to execute
		 * @param body The optional body of the notification
		 * @param note The optional notification object to use when executing the command
		 */
		public function executeCommandClass(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			if (note == null) {
				note = new Notification(null, body);
			}
			
			var command:ICommand = new clazz();
			command.initializeNotifier(multitonKey);
			
			if (command is IUndoableCommand) {
				(command as IUndoableCommand).initializeUndoableCommand(note);
			}
			
			command.execute(note);
			
			return command;
		}
		
		/**
		 * Fabrication allows multiple commands to be mapped to the same notification. This
		 * method provides the means to remove a specific command to notification mapping.
		 * 
		 * @param notificationName The notification to unmap
		 * @param clazz The command class that the notification name was mapped to.
		 */
		public function removeSingleCommand(notificationName:String, clazz:Class):void {
			if (hasCommand(notificationName)) {
				var commandList:Array = commandMap[notificationName] as Array;
				
				if (commandList.length == 1) {
					removeCommand(notificationName);
				} else {
					var index:int = findCommandIndex(commandList, clazz);
					if (index >= 0) {
						commandList.splice(index, 1);
					}
				}
			}
		}

		/**
		 * Returns true if there are any commands on the undo stack that 
		 * can be undone. 
		 */
		public function canUndo():Boolean {
			return !undoStack.isEmpty();
		}

		/**
		 * Returns true if there are any commands on the redo stack that
		 * can be redone. 
		 */
		public function canRedo():Boolean {
			return !redoStack.isEmpty();
		}

		/**
		 * The current size of the undo stack
		 */
		public function undoSize():int {
			return undoStack.length();
		}
		
		/**
		 * The current size of the redo stack
		 */
		public function redoSize():int {
			return redoStack.length();
		}

		/**
		 * Undo's the commands in the undo stack upto the steps specified.
		 * A COMMAND_HISTORY_CHANGED notification is sent if any command was undone.
		 * 
		 * @param steps The number of steps to undo. Default is 1.
		 */
		public function undo(steps:int = 1):Boolean {
			var changed:Boolean = false;
			var command:IUndoableCommand;
			for (var i:int = 0;i < steps; i++) {
				if (!undoStack.isEmpty()) {
					command = undoStack.pop() as IUndoableCommand;
					unexecuteCommand(command, command.getNotification());
					
					redoStack.push(command);
					changed = true;
				}
			}
			
			if (changed) {
				notifyCommandHistoryChanged();
			}
			
			return changed;
		}

		/**
		 * Redo's the commands in the redo stack upto the steps specified.
		 * A COMMAND_HISTORY_CHANGED notification is sent if any command was redone.
		 * 
		 * @param steps The number of steps to redo. Default is 1.
		 */
		public function redo(steps:int = 1):Boolean {
			var changed:Boolean = false;
			var command:IUndoableCommand;
			for (var i:int = 0;i < steps; i++) {
				if (!redoStack.isEmpty()) {
					command = redoStack.pop() as IUndoableCommand;
					command.execute(command.getNotification());
					
					undoStack.push(command);
					changed = true;
				}
			}
			
			if (changed) {
				notifyCommandHistoryChanged();
			}
			
			return changed;
		}

		/**
		 * Checks if the command can be
		 * merged into the last command on the undo stack. If the merge
		 * is not successfull then the command is pushed to the undo stack.
		 * Eitherwise a COMMAND_HISTORY_CHANGED notification is sent after
		 * adding/merging the command.
		 * 
		 * @param command The undoable command instance to add/merge 
		 */
		protected function addCommand(command:IUndoableCommand):void {
			redoStack.clear();
			
			if (undoStack.isEmpty() || !((undoStack.peek() as IUndoableCommand).merge(command))) {
				undoStack.push(command);
			}
			
			notifyCommandHistoryChanged();
		}

		/**
		 * Performs an unexecute operation on the command specified with the
		 * notification specified.
		 * 
		 * @param command The undoable command to unexecute.
		 * @param notification The notification with which to perform the undo operation 
		 */
		protected function unexecuteCommand(command:IUndoableCommand, note:INotification):void {
			command.unexecute(note);
		}

		/**
		 * Sends a COMMAND_HISTORY_CHANGED notification using the view object.
		 */
		protected function notifyCommandHistoryChanged():void {
			var notification:UndoableNotification = new UndoableNotification(UndoableNotification.COMMAND_HISTORY_CHANGED);
			notification.undoable = canUndo();
			notification.redoable = canRedo();
			notification.undoableCommands = undoStack.getElements();
			notification.redoableCommands = redoStack.getElements();
			notification.groupID = groupID;
			
			if (notification.undoable) {
				notification.undoCommand = (undoStack.peek() as IUndoableCommand).getUndoPresentationName();
			}
			
			if (notification.redoable) {
				notification.redoCommand = (redoStack.peek() as IUndoableCommand).getRedoPresentationName();
			}
			
			view.notifyObservers(notification);
		}
		
		/**
		 * Sends a COMMAND_GROUP_CHANGED notification using the view object
		 */
		protected function notifyCommandGroupChanged():void {
			var notification:UndoableNotification = new UndoableNotification(UndoableNotification.COMMAND_GROUP_CHANGED);
			view.notifyObservers(notification);
		}
		
		/**
		 * Helper to get the index of a specific command in the command list
		 */
		private function findCommandIndex(commandList:Array, clazz:Class):int {
			var n:int = commandList.length;
			var commandClazz:Class;
			for (var i:int = 0; i < n; i++) {
				commandClazz = commandList[i];
				if (commandClazz == clazz) {
					return i;
				}
			}
			
			return -1;
		}
		
		/**
		 * The unique identifier of the current undo-redo group.
		 */
		public function get groupID():String {
			return _groupID;
		}
		
		/**
		 * @private
		 */
		public function set groupID(_groupID:String):void {
			if (_groupID == null || _groupID == "") {
				throw new Error("groupID must not be null.");	
			}
			
			this._groupID = _groupID;
			
			notifyCommandGroupChanged();
			notifyCommandHistoryChanged();
		}
		
		/**
		 * Disposes the specified undo-redo group.
		 * 
		 * @param $groupID The unique undo-redo group to remove.
		 */
		public function removeGroup($groupID:String):void {
			var store:GroupStore = getGroupStore($groupID);
			if (store != null) {
				store.dispose();
				groupsHashMap.remove($groupID);
			}
		}
		
		/**
		 * Returns the object in the groups hash map storing the undo-redo stacks
		 * for the specified group. The group store is created here if it isn't already
		 * present.
		 */
		protected function getGroupStore($groupID:String = null):GroupStore {
			if ($groupID == null) {
				$groupID = groupID;
			}
			
			var store:GroupStore = groupsHashMap.find($groupID) as GroupStore;
			if (store == null) {
				store = createGroupStore($groupID);
			}
			
			return store;
		}
		
		/**
		 * Initialize the undo-redo stack store for the specified group. 
		 */
		protected function createGroupStore($groupID:String = null):GroupStore {
			return groupsHashMap.put(
				$groupID, new GroupStore(new Stack(), new Stack())
			) as GroupStore;
		}
		
		/**
		 * Returns the undo stack for the current group.
		 */
		protected function get undoStack():Stack {
			return getGroupStore().undoStack;
		}
		
		/**
		 * Returns the redo stack for the current group.
		 */
		protected function get redoStack():Stack {
			return getGroupStore().redoStack;
		}
		
	}
}

import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;
import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;

internal class GroupStore implements IDisposable {

	public var undoStack:Stack;
	public var redoStack:Stack;
	
	public function GroupStore(undoStack:Stack, redoStack:Stack) {
		this.undoStack = undoStack;
		this.redoStack = redoStack;
	}
	
	public function dispose():void {
		undoStack.dispose();
		undoStack = null;
		
		redoStack.dispose();
		redoStack = null;	
	}
	
}