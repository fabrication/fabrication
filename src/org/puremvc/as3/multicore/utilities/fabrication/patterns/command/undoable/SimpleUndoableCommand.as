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
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.AbstractUndoableCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;	
	
	/**
	 * SimpleUndoableCommand is the base command for property change undo's.
	 * Property change undo's are undo operations that have a distinct before
	 * and after property value. It abstracts such an undo into 2 operations
	 * 
	 * <ul>
	 * 	<li>Saving begin and cancel state of the property within the command</li>
	 * 	<li>Committing the new state of the property typically to a proxy</li>
	 * </ul>
	 * 
	 * <p>
	 * The begin state of the property is the value that the command will be
	 * executed with initially, i.e:- with execute. The begin state typically
	 * is provide as the body of the notification that triggered the command.
	 * </p>
	 * 
	 * <p>
	 * The cancel state of the property is the value that the command will be
	 * executed when it needs to be undone, i.e:- with unexecute. The cancel
	 * state of the property is typically looked up from a proxy.
	 * </p>
	 * 
	 * <p>
	 * The begin and cancel state of the property must be saved in the
	 * initializeUndoableCommand method. You must also invoke 
	 * super.initializeUndoableCommand in this method.
	 * </p>
	 * 
	 * <p>
	 * The commit method is called with the state of the property depending
	 * on the direction of the execution, i.e:- undo or redo. With the first
	 * execution or a redo direction the state will be the begin state of
	 * the command. With the undo direction the state will be the cancel state
	 * of the command.
	 * </p> 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class SimpleUndoableCommand extends AbstractUndoableCommand {
		
		/**
		 * The state object for the initial or redo operation direction
		 */
		protected var beginState:Object;
		
		/**
		 * The state object for the undo operation direction
		 */
		protected var cancelState:Object;
		
		/**
		 * Stores the begin state locally.
		 * 
		 * @param state The begin state object
		 */
		public function saveBeginState(state:Object):void {
			this.beginState = state;
		}
		
		/**
		 * Stores the cancel state locally.
		 * 
		 * @param state The cancel state object
		 */
		public function saveCancelState(state:Object):void {
			this.cancelState = state;
		}
		
		/**
		 * Returns the current begin state object.
		 */
		public function getBeginState():Object {
			return beginState;
		}
		
		/**
		 * Returns the cancel state object.
		 */
		public function getCancelState():Object {
			return cancelState;
		}
		
		/**
		 * Abstract method. Subclasses need to save their begin and
		 * cancel states here.
		 */
		override public function initializeUndoableCommand(notification:INotification):void {
			super.initializeUndoableCommand(notification);
			
			// abstract
		}
		
		/**
		 * Performs a commit operation with the begin state.
		 */
		override public function execute(note:INotification):void {
			commit(getBeginState());
		}
		
		/**
		 * Performs a commit operation with the cancel state.
		 */
		override public function unexecute(note:INotification):void {
			commit(getCancelState());
		}
		
		/**
		 * Abstract method. Subclasses need to implement the concrete
		 * means to save the state back typically to a proxy.
		 */
		protected function commit(state:Object):void {
			// abstract
		}
		
		/**
		 * Cleans up the begin and cancel states before disposal.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.interfaces.IDisposable#dispose()
		 */
		override public function dispose():void {
			super.dispose();
			
			beginState = null;
			cancelState = null;
		}
		
	}
}
