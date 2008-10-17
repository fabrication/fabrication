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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;		

	/**
	 * An interface to describe a PureMVC command that can is undoable
	 * and redoable.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IUndoableCommand extends ICommand {

		/**
		 * Saves the notification for this undoable command and 
		 * performs an necessary initialization.
		 * 
		 * @param notification The notification object that triggered this command  
		 */
		function initializeUndoableCommand(notification:INotification):void;

		/**
		 * Returns the notification object that this command was 
		 * initialized with.
		 */
		function getNotification():INotification;

		/**
		 * Undo's the previous changes of this command.
		 * 
		 * @param notification The notification object that this command was initialized with.
		 */
		function unexecute(notification:INotification):void;

		/**
		 * Tries to merge the specified command with this command. If 
		 * successful returns true else returns false.
		 */
		function merge(command:IUndoableCommand):Boolean;

		/**
		 * Returns a descriptive name for this command.
		 */
		function getDescription():String;

		/**
		 * Returns the presentation name for this command.
		 */
		function getPresentationName():String;

		/**
		 * Returns the presentation name for this command when performing
		 * an undo operation.
		 */
		function getUndoPresentationName():String;

		/**
		 * Returns the presentation name for this command when performing
		 * a redo operation
		 */
		function getRedoPresentationName():String;
	}
}
