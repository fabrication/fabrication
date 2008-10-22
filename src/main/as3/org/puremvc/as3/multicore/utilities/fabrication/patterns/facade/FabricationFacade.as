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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.facade {
	import org.puremvc.as3.multicore.utilities.fabrication.vo.NotificationInterests;	
	
	import flash.utils.getQualifiedClassName;

	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationRedoCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationUndoCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;	

	/**
	 * FabricationFacade is a concrete PureMVC facade implementation that
	 * provides the typical bootstrap process of a PureMVC application.
	 * 
	 * It implements a startup method to kickstart the PureMVC apparatus
	 * with a STARTUP notification.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationFacade extends Facade implements IDisposable {

		/**
		 * Returns the singleton instance of the FabricationFacade for the
		 * specified multiton key. If the instance is not present it is first
		 * created here.
		 * 
		 * @param key The multiton key
		 */
		static public function getInstance(key:String):FabricationFacade {
			if (instanceMap[key] == null) {
				instanceMap[key] = new FabricationFacade(key);
			}
			
			return instanceMap[key] as FabricationFacade;
		} 

		/**
		 * Calculates the name of the application from the its startup command.
		 * StartupCommand must be of the form [ApplicationName]StartupCommand.
		 * An error is thrown if this form is not used.
		 * 
		 * @param startupCommand The startup command class reference
		 * @throws Error StartupCommand must be of the form [ApplicationName]StartupCommand
		 */
		static public function calcApplicationName(startupCommand:Class = null):String {
			var classPath:String = getQualifiedClassName(startupCommand);
			var temp:Array = classPath.split("::");
			var className:String = temp[temp.length - 1];
			
			className = className.replace(/StartupCommand/, "");
			className = className.replace(/Command/, "");
			
			if (className == "") {
				throw new Error("StartupCommand must be of the form [ApplicationName]StartupCommand");
			}
			
			return className;			
		}

		/**
		 * Reference to the main application fabrication
		 */
		protected var application:Object;

		/**
		 * The startup command class
		 */
		protected var startupCommand:Class;

		/**
		 * The calculated name of the current application.
		 */
		protected var applicationName:String;

		/**
		 * Stores cached notification interests of a mediator. The
		 * notification interests of a mediator are store here the first
		 * time they are created. When additional instances of this
		 * mediator are created the cached notification interests are 
		 * used.
		 */
		protected var cachedNotificationInterests:Object;

		/**
		 * Creates a new FabricationFacade object.
		 */
		public function FabricationFacade(key:String) {
			super(key);
			
			cachedNotificationInterests = new Object();
		}

		/**
		 * Sends a SHUTDOWN notification to allow the application to
		 * perform any cleanup prior to removal and deletes external
		 * referenced objects.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			sendNotification(FabricationNotification.SHUTDOWN, getApplication());
			startupCommand = null;
			
			if (controller is IDisposable) {
				(controller as IDisposable).dispose();
			}
			
			if (view is IDisposable) {
				(view as IDisposable).dispose();
			}
			
			cachedNotificationInterests = null;
		}

		/**
		 * Overrides initializeController to create a FabricationController
		 * instead of the PureMVC default. Also registers the undo commands
		 * with the facade.
		 */
		override protected function initializeController():void {
			if (controller != null) {
				return;
			}
			
			controller = FabricationController.getInstance(multitonKey);
			
			registerCommand(FabricationNotification.UNDO, FabricationUndoCommand);
			registerCommand(FabricationNotification.REDO, FabricationRedoCommand);
		}

		/**
		 * Starts the PureMVC apparatus after registering and triggering
		 * a STARTUP notification. A BOOTSTRAP notification is also sent
		 * to allow the startup commands to be split into 2 parts, a
		 * creation phase and a configuration phase.
		 * 
		 * @param startupCommand The startup command class for this application
		 * @param application The main application reference
		 */
		public function startup(startupCommand:Class, application:Object):void {
			this.application = application;
			
			this.startupCommand = startupCommand; 
			applicationName = calcApplicationName(startupCommand);
			
			registerCommand(FabricationNotification.STARTUP, startupCommand);
			
			sendNotification(FabricationNotification.STARTUP, application);
			sendNotification(FabricationNotification.BOOTSTRAP, application);
		}

		/**
		 * Returns the current application controller as FabricationController
		 * object. 
		 */
		public function get fabricationController():FabricationController {
			return controller as FabricationController;
		}

		/**
		 * Executes an undo operation for the specified number of steps.
		 * 
		 * @param steps The number of steps to undo. Default is 1.
		 */
		public function undo(steps:int = 1):void {
			fabricationController.undo(steps);
		}

		/**
		 * Executes a redo operation for the specified number of steps
		 * 
		 * @param steps The number of steps to redo. Default is 1.
		 */
		public function redo(steps:int = 1):void {
			fabricationController.redo(steps);
		}

		/**
		 * Returns the main application class instance for the current
		 * application.  
		 */
		public function getApplication():Object {
			return application;
		}

		/**
		 * Alias to getApplication, cast as IFabrication
		 */
		public function getFabrication():IFabrication {
			return application as IFabrication;
		}

		/**
		 * Returns the calculated application name string.
		 */
		public function getApplicationName():String {
			return applicationName;
		}

		/**
		 * Wraps the notification and triggers a send via the router
		 * using a notification.
		 * 
		 * @param noteName The name of the notification to send
		 * @param noteBody The body of the notification to send
		 * @param noteType The type of the notification to send
		 * @param to The target destination module address of the notification.
		 * 			  to can be a ModuleAddress object or a string with the route
		 * 			  in the form ModuleName/InstanceName. If InstanceName is *
		 * 			  the message will be routed to all instances of the ModuleName.
		 */
		public function routeNotification(noteName:String, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			var wrapper:Object = new Object();
			wrapper.noteName = noteName;
			wrapper.noteBody = noteBody;
			wrapper.noteType = noteType;
			wrapper.to = to;
			
			sendNotification(RouterNotification.SEND_MESSAGE_VIA_ROUTER, wrapper);
		}
		
		/**
		 * Stores the notification interests in the application interests.
		 * 
		 * @param classpath The path to the mediator class
		 * @param interests The notification interests of the mediator
		 */
		public function saveNotificationInterests(classpath:String, interests:NotificationInterests):void {
			cachedNotificationInterests[classpath] = interests;
		}

		/**
		 * Removes the cached notification interests for the specified classpath.
		 * 
		 * @param classpath The classpath whose notification interests need to removed.
		 */
		public function clearNotificationInterests(classpath:String):void {
			delete(cachedNotificationInterests[classpath]);
		}
		
		/**
		 * Returns the notification interests for the specified mediator
		 * 
		 * @param classpath The classpath to the mediator
		 */
		public function getNotificationInterests(classpath:String):NotificationInterests {
			return cachedNotificationInterests[classpath];	
		}
		
		/**
		 * Returns a boolean depending on whether the specified mediator's
		 * notification interests are cached.
		 */
		public function hasNotificationInterests(classpath:String):Boolean {
			return getNotificationInterests(classpath) != null;
		}
	}
}
