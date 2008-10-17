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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCable;	

	/**
	 * ApplicationShutdownCommand performs cleanup before the application
	 * module is removed.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ApplicationShutdownCommand extends SimpleFabricationCommand {
		
		/**
		 * Disconnects the router cable for the current module from
		 * the application router.
		 * 
		 * @see org.puremvc.as3.multicore.interfaces.ICommand#execute()
		 */
		override public function execute(note:INotification):void {
			var moduleAddress:IModuleAddress = fabrication.moduleAddress;
			var inputPipe:NamedPipe = new NamedPipe(moduleAddress.getInputName());
			var outputPipe:NamedPipe = new NamedPipe(moduleAddress.getOutputName());
			var routerCable:RouterCable = new RouterCable(inputPipe, outputPipe);
			
			// TODO :: Improve cleanup, The cable listener is currently 
			// hanging to the inputPipe
			applicationRouter.disconnect(routerCable);
		}
		
	}
}
