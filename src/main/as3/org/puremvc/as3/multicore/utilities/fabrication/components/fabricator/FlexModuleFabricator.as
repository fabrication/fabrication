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
 
package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator {
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.intro.DefaultFlexModuleStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ModuleStartupCommand;	

	/**
	 * FlexModuleFabricator is the concrete fabricator for the FlexModule
	 * environment. Modules are similar to application except that they
	 * get their message router from the parent shell.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlexModuleFabricator extends ApplicationFabricator {
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabrication
		 */
		public function FlexModuleFabricator(_fabrication:FlexModule) {
			super(_fabrication);
			
			if (_startupCommand == null) {
				_startupCommand = DefaultFlexModuleStartupCommand;
			}
		}

		/**
		 * Returns the FlexModuleLoader that loaded this module.
		 */		
		public function get moduleLoader():FlexModuleLoader {
			return (module.parent as FlexModuleLoader);
		}
		
		/**
		 * Returns the fabrication as a FlexModule 
		 */
		public function get module():FlexModule {
			return fabrication as FlexModule;
		}
		
		/**
		 * Provides the ready event name for FlexModule, i.e.:- initialize
		 */
		override protected function get readyEventName():String {
			return FlexEvent.INITIALIZE;
		}
		
		/**
		 * Fetches the router and defaultRoute from the parent module loader
		 * and registers a module system fabrication command with the startup
		 * system notification.
		 */
		override protected function initializeEnvironment():void {
			module.router = moduleLoader.router;
			module.defaultRoute = moduleLoader.defaultRoute;
			
			facade.registerCommand(FabricationNotification.STARTUP, ModuleStartupCommand);
		}
		
	}
}
