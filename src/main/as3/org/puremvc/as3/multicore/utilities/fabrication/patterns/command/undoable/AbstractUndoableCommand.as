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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICommandProcessor;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	import flash.utils.getQualifiedClassName;	

	/**
	 * AbstractUndoableCommand is the base class for all fabrication
	 * undoable commands. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class AbstractUndoableCommand extends SimpleFabricationCommand implements IUndoableCommand, ICommandProcessor {

		/**
		 * Default undo prefix label
		 */
		static public var UNDO_PREFIX:String = "Undo ";
		
		/**
		 * Default redo prefix label
		 */
		static public var REDO_PREFIX:String = "Redo ";

		/**
		 * The notification object that was provided when the command
		 * was initialized.
		 */
		protected var notification:INotification;
		
		/**
		 * Abstract constructor
		 */
		public function AbstractUndoableCommand() {
			super();
		}
		
		/**
		 * Saves the notification object for later use.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand#initializeUndoableCommand()
		 */
		public function initializeUndoableCommand(notification:INotification):void {
			this.notification = notification;
		}

		/**
		 * Returns the notification object saved during initialization
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand#getNotification()
		 */		
		public function getNotification():INotification {
			return notification;
		}

		/**
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */		
		override public function execute(note:INotification):void {
			// abstract			
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand#unexecute()
		 */
		public function unexecute(note:INotification):void {
			// abstract
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand#merge()
		 */
		public function merge(command:IUndoableCommand):Boolean {
			return false;
		}
		
		/**
		 * Calculates the presentation name using reflection and returns it.
		 * This is a resonable initial approximation for most commands named
		 * using camel case syntax.
		 * 
		 * @example ChangeCustomPropertyCommand becomes Change Custom Property
		 */
		public function getDescription():String {
			var classpath:String = getQualifiedClassName(this);
			var classname:String = classpath.split("::")[1];
			
			classname = classname.replace(/Command$/, "");			
			classname = classname.replace(/([A-Z])/g, " \1");
			classname = classname.replace(/^ /, "");
			
			return classname;
		}
		
		/**
		 * Returns the calculated description as the presentation name.
		 */
		public function getPresentationName():String {
			return getDescription();
		}

		/**
		 * Prefixes the presentation name with the undo prefix
		 */		
		public function getUndoPresentationName():String {
			return UNDO_PREFIX + getPresentationName();
		}
		
		/**
		 * Prefixes the presentation name with the redo prefix.
		 */
		public function getRedoPresentationName():String {
			return "Redo " + getPresentationName();
		}
		
		/**
		 * Overrides executeCommand to initialize undoable commands before
		 * they are executed.
		 */
		override public function executeCommand(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			if (note == null) {
				note = getNotification();
			}
			
			var command:ICommand = new clazz();
			command.initializeNotifier(multitonKey);
			
			if (command is IUndoableCommand) {
				var undoableCommand:IUndoableCommand = command as IUndoableCommand;
				undoableCommand.initializeUndoableCommand(note);
			}
			
			command.execute(note);
			
			return command;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		override public function dispose():void {
			super.dispose();
			
			notification = null;
		}
		
	}
}
