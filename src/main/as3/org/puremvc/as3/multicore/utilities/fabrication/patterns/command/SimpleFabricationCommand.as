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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command {
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICommandProcessor;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;	

	/**
	 * SimpleFabricationCommand is the base class for all fabrication commands.
	 * It aliases common facade.<methodName> invocations and provides
	 * easier access to properties often required by a fabrication application.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class SimpleFabricationCommand extends SimpleCommand implements ICommandProcessor, IDisposable {

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces#executeCommand()
		 */
		public function executeCommand(clazz:Class, body:Object = null, note:INotification = null):ICommand {
			if (note == null) {
				note = new Notification(null, body);
			}
			
			var command:ICommand = new clazz();
			command.initializeNotifier(multitonKey);
			command.execute(note);
			
			return command;
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			
		}

		/**
		 * Reference to the fabrication facade
		 */
		public function get fabFacade():FabricationFacade {
			return facade as FabricationFacade;
		}

		/**
		 * Reference to the main fabrication application class
		 */
		public function get fabrication():IFabrication {
			return fabFacade.getApplication() as IFabrication;
		}

		/**
		 * Reference to the current message router
		 */
		public function get applicationRouter():IRouter {
			return fabrication.router;
		}

		/**
		 * Alias to facade.registerCommand
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#registerCommand
		 */
		public function registerCommand( notificationName:String, commandClassRef:Class ):void {
			facade.registerCommand(notificationName, commandClassRef);
		}

		/**
		 * Alias to facade.removeCommand
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#removeCommand
		 */
		public function removeCommand( notificationName:String ):void {
			facade.removeCommand(notificationName);
		}

		/**
		 * Alias to facade.hasCommand
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#hasCommand
		 */
		public function hasCommand( notificationName:String ):Boolean {
			return facade.hasCommand(notificationName);
		}

		/**
		 * Alias to facade.registerProxy
		 * 
		 * @return The proxy being registered
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#registerProxy
		 */
		public function registerProxy( proxy:IProxy ):IProxy {
			facade.registerProxy(proxy);
			return proxy;	
		}

		/**
		 * Alias to facade.retrieveProxy
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#retrieveProxy
		 */
		public function retrieveProxy( proxyName:String ):IProxy {
			return facade.retrieveProxy(proxyName);	
		}

		/**
		 * Alias to facade.removeProxy
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#removeProxy
		 */
		public function removeProxy( proxyName:String ):IProxy {
			return facade.removeProxy(proxyName);
		}

		/**
		 * Alias to facade.hasProxy
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#hasProxy
		 */
		public function hasProxy( proxyName:String ):Boolean {
			return facade.hasProxy(proxyName);
		}

		/**
		 * Alias to facade.registerMediator
		 * 
		 * @return The mediator being registered
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#registerMediator
		 */
		public function registerMediator( mediator:IMediator ):IMediator {
			facade.registerMediator(mediator);
			return mediator;
		}

		/**
		 * Alias to facade.retrieveMediator
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#retrieveMediator
		 */
		public function retrieveMediator( mediatorName:String ):IMediator {
			return facade.retrieveMediator(mediatorName) as IMediator;
		}

		/**
		 * Alias to facade.removeMediator
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#removeMediator
		 */
		public function removeMediator( mediatorName:String ):IMediator {
			return facade.removeMediator(mediatorName);
		}

		/**
		 * Alias to facade.hasMediator
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.IFacade#hasMediator
		 */
		public function hasMediator( mediatorName:String ):Boolean {
			return facade.hasMediator(mediatorName);
		}

		/**
		 * Alias to fabFacade.routeNotification
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade#routeNotification
		 */
		public function routeNotification(noteName:String, noteBody:Object = null, noteType:String = null, to:String = null):void {
			fabFacade.routeNotification(noteName, noteBody, noteType, to);
		}
	}
}
