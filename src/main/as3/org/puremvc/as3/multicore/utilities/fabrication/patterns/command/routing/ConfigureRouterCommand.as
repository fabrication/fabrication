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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCable;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCableListener;	

	/**
	 * ConfigureRouterCommand creates the pipe fittings to the router
	 * specified and connects the router cable to it. The router
	 * must be passed into it as the body of the notificaton.
	 * 
	 * It can be used with a notification or directly with executeCommand
	 * to configure a custom router.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ConfigureRouterCommand extends SimpleFabricationCommand {

		/**
		 * The cable listener is stored on the facade for later removal.
		 */
		static public var routerCableListenerKey:String = "routerCableListener";

		/**
		 * Creates an input and output pipe fitting and wraps it with a
		 * router cable. The router cable is then connected to the router
		 * specified.
		 * 
		 * A pipe listener is also created to listen for incoming messages
		 * sent via the router. 
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */
		override public function execute(note:INotification):void {
			var router:IRouter = note.getBody() as IRouter;
			var moduleAddress:IModuleAddress = fabrication.moduleAddress;

			var inputPipe:NamedPipe = new NamedPipe(moduleAddress.getInputName());
			var outputPipe:NamedPipe = new NamedPipe(moduleAddress.getOutputName());
			var cableListener:RouterCableListener = new RouterCableListener(facade);
			var routerCable:RouterCable = new RouterCable(inputPipe, outputPipe);
			
			inputPipe.moduleGroup = fabrication.moduleGroup;
			outputPipe.moduleGroup = fabrication.moduleGroup;

			inputPipe.connect(cableListener);
			router.connect(routerCable);
			
			fabFacade.saveInstance(routerCableListenerKey, cableListener);
		}
	}
}
