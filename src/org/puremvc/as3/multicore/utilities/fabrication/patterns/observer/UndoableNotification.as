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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.patterns.observer.Notification;	
	
	/**
	 * UndoableNotification is the notification object sent to 
	 * indicate undo/redo command stack changes.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class UndoableNotification extends Notification implements IDisposable {

		/**
		 * Notified when a new command is added to the stack or an undo or 
		 * redo is performed.
		 */
		static public const COMMAND_HISTORY_CHANGED:String = "commandHistoryChanged";
		
		/**
		 * Notified when the undo-redo group is changed in the FabricationController
		 */
		static public const COMMAND_GROUP_CHANGED:String = "commandGroupChanged";
		
		/**
		 * Indicates if an undo operation can be performed from the current
		 * position on the stack.
		 */
		public var undoable:Boolean;
		
		/**
		 * Indicates if a redo operation can be performed from the current
		 * position on the stack.
		 */ 
		public var redoable:Boolean;
		
		/**
		 * List of undoable command objects.
		 */
		public var undoableCommands:Array;
		
		/**
		 * List of redoable command objects.
		 */
		public var redoableCommands:Array;
		
		/**
		 * The current undo command name
		 */
		public var undoCommand:String;
		
		/**
		 * The current redo command name
		 */
		public var redoCommand:String;
		
		/**
		 * The unique name of the current group
		 */
		public var groupID:String;
		
		/**
		 * Creates a new UndoableNotification object
		 */
		public function UndoableNotification(name:String, body:Object = null, type:String = null) {
			super(name, body, type);
		}
		
		/**
		 * @see Object#toString
		 */
		override public function toString():String {
			return "UndoableNotification : " +
				"\r\tundoable : " + undoable +
				"\r\tredoable : " + redoable;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			setBody(null);
			setType(null);
			
			undoableCommands = null;
			redoableCommands = null;
			undoCommand = null;
			redoCommand = null;
			groupID = null;
		}
		
	}
	
}
