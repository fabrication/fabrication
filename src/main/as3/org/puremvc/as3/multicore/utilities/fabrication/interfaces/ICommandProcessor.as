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
	 * An interface that describes the way to execute a PureMVC command.
	 * This gives an object the ability to execute any arbitrary command with
	 * or without a notification.   
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface ICommandProcessor {

		/**
		 * Instantiates the command class and executes it with the specified
		 * notification. The notification is optional.
		 * 
		 * If the command only depends on the notification body you can 
		 * specify only a body without a notification. A temporary notification
		 * object is created with that body which is used to execute the command.  
		 * 
		 * @param clazz	 The command class to execute
		 * @param body The optional body of the notification
		 * @param notification The notification object for the command.
		 * 
		 * @return The instantiated command instance.
		 */
		function executeCommand(clazz:Class, body:Object = null, notification:INotification = null):ICommand;
	}
}
