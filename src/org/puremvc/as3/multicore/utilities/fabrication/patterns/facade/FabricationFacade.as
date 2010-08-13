/**
 * Copyright (C) 2008 Darshan Sawardekar, 2010 Rafał Szemraj.
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
    import flash.utils.getQualifiedClassName;

    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationModel;
    import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationView;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.ChangeUndoGroupCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationRedoCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationUndoCommand;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationDependencyProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
	 * FabricationFacade is a concrete PureMVC facade implementation that
	 * provides the typical bootstrap process of a PureMVC application.
	 * 
	 * It implements a startup method to kickstart the PureMVC apparatus
	 * with a STARTUP notification.
	 * 
	 * @author Darshan Sawardekar, Rafał Szemraj
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
		 * The custom singleton object instances map
		 */
		protected var singletonInstanceMap:HashMap;

        public var logger:FabricationLogger = FabricationLogger.getInstance();
        private var _fabricationLoggerEnabled:Boolean;

		/**
		 * Creates a new FabricationFacade object.
		 */
		public function FabricationFacade(key:String) {
			super(key);
			
			singletonInstanceMap = new HashMap();
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
			
			if (view is IDisposable) {
				(view as IDisposable).dispose();
			}
			
			if (controller is IDisposable) {
				(controller as IDisposable).dispose();
			}
			
			if (model is IDisposable) {
				(model as IDisposable).dispose();
			}
			
			singletonInstanceMap.dispose();
			singletonInstanceMap = null;
			
			removeCore(multitonKey);
		}

		/**
		 * Overrides the initializeModel to create FabricationModel instead of
		 * the PureMVC default.
		 */
		override protected function initializeModel():void {
			if (model != null) {
				return;
			}
			
			model = FabricationModel.getInstance(multitonKey);
		}

		/**
		 * Override the initializeView to create a FabricationView instead of
		 * the PureMVC default
		 */
		override protected function initializeView():void {
			if (view != null) {
				return;
			}
			
			view = FabricationView.getInstance(multitonKey);
			(view as FabricationView).controller = controller as FabricationController;
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
			registerCommand(FabricationNotification.CHANGE_UNDO_GROUP, ChangeUndoGroupCommand);
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

            var fabrication:IFabrication = application as IFabrication;
            if( fabrication ) {

                registerProxy( new FabricationDependencyProxy() );
                addDependencyProviders( fabrication.dependencyProviders );

            }

			registerCommand(FabricationNotification.STARTUP, startupCommand);
			
			sendNotification(FabricationNotification.STARTUP, application);
			sendNotification(FabricationNotification.BOOTSTRAP, application);


            if( _fabricationLoggerEnabled )
                logger.logFabricatorStart( getFabrication(), calcApplicationName( startupCommand ) );
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
		 * Returns the multiton key for the current facade.
		 */
		public function getMultitonKey():String {
			return multitonKey;
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
		public function routeNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			var transportNotification:TransportNotification = new TransportNotification(noteName, noteBody, noteType, to);
			sendNotification(RouterNotification.SEND_MESSAGE_VIA_ROUTER, transportNotification);
            if( logger )
                logger.logRouteNotificationAction( transportNotification );
		}


        override public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
        {
            super.sendNotification(notificationName, body, type);
            if( _fabricationLoggerEnabled && filter( notificationName ) )
                logger.logSendNotificationAction( new Notification(notificationName, body, type ) );
        }


        override public function notifyObservers(notification:INotification):void
        {
            super.notifyObservers(notification);
        }

        /**
		 * Alias to fabricationController.registerCommandClass
		 */
		public function executeCommandClass(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			return fabricationController.executeCommandClass(clazz, body, note);
		}

		/**
		 * Stores the instance with the specified key in the singleton hash map.
		 * 
		 * @param key The unique key of the singleton instance
		 * @param instance The object to store
		 */
		public function saveInstance(key:String, instance:Object):Object {
			return singletonInstanceMap.put(key, instance);
		}

		/**
		 * Returns the singleton instance for the corresponding key.
		 * 
		 * @param key The unique key of the singleton instance to lookup.
		 */
		public function findInstance(key:String):Object {
			return singletonInstanceMap.find(key);
		}

		/**
		 * Returns a boolean depending on whether an instance for the specified key 
		 * exists in the singleton hash map.
		 * 
		 * @param key The unique key for the singleton instance to verify.
		 */
		public function hasInstance(key:String):Object {
			return singletonInstanceMap.exists(key);
		}

		/**
		 * Removes the instance for the specified key from the singleton hash map
		 * 
		 * @param key The unique key for the singleton instance to remove.
		 */
		public function removeInstance(key:String):Object {
			return singletonInstanceMap.remove(key);
		}

		/**
		 * Registers the interceptor with the fabrication controller.
		 * 
		 * @param noteName The name of the notification to register the interceptor with.
		 * @param clazz The concrete interceptor class.
		 * @param parameters Optional parameters for the interceptor.
		 */
		public function registerInterceptor(noteName:String, clazz:Class, parameters:Object = null):void {

			fabricationController.registerInterceptor(noteName, clazz, parameters);
            if( _fabricationLoggerEnabled )
                logger.logInterceptorRegistration( clazz, noteName, parameters );
		}

		/**
		 * Removes the interceptor from the fabrication controller.
		 * 
		 * @param noteName The name of the notification whose interceptor is to be removed.
		 * @param clazz The name of the concrete interceptor class that was registered earlier with this noteName.
		 */		
		public function removeInterceptor(noteName:String, clazz:Class = null):void {
			fabricationController.removeInterceptor(noteName, clazz);
		}

        /**
         * @inheritDoc
         */
        override public function registerProxy(proxy:IProxy):void
        {
            super.registerProxy(proxy);
            if( _fabricationLoggerEnabled )
                logger.logProxyRegistration( proxy );
        }

        /**
         * @inheritDoc
         */
        override public function registerMediator(mediator:IMediator):void
        {
            super.registerMediator(mediator);
            if( _fabricationLoggerEnabled )
                logger.logMediatorRegistration( mediator );
        }

        /**
         * @inheritDoc
         */
        override public function registerCommand(notificationName:String, commandClassRef:Class):void
        {
            super.registerCommand(notificationName, commandClassRef);
            if( _fabricationLoggerEnabled )
                if( notificationName != FabricationNotification.STARTUP )
                    logger.logCommandRegistration( commandClassRef, notificationName );
        }


        public function set fabricationLoggerEnabled(value:Boolean):void
        {
            _fabricationLoggerEnabled = value;
        }


        private function addDependencyProviders( dependencyProviders:Array ):void {

            var dependencyProxy:FabricationDependencyProxy = retrieveProxy( FabricationDependencyProxy.NAME ) as FabricationDependencyProxy;
            for each( var provider:* in dependencyProviders )
                dependencyProxy.addDependecyProvider( provider );
            
        }

        private function filter( notificationName:String ):Boolean {

            var filtered:Boolean;
            switch( notificationName ) {

                case FabricationNotification.STARTUP: filtered = true;
                case FabricationNotification.SHUTDOWN: filtered = true;
                case FabricationNotification.BOOTSTRAP: filtered = true;
                case FabricationNotification.UNDO: filtered = true;
                case FabricationNotification.REDO: filtered = true;
                case FabricationNotification.CHANGE_UNDO_GROUP: filtered = true;
                case RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER: filtered = true;
                case RouterNotification.SEND_MESSAGE_VIA_ROUTER: filtered = true;
                default:;

            }

            return !filtered;


        }
    }
}
