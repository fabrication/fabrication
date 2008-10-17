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
 
package org.puremvc.as3.multicore.utilities.fabrication.components {
	import flash.utils.getDefinitionByName;
	
	import mx.modules.Module;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlexModuleFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;	

	/**
	 * FlexModule is the concrete fabrication for the flex module environment.
	 * It uses the FlexModuleFabricator to provide a flex module environment
	 * specific configuration.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlexModule extends Module implements IFabrication {

		/**
		 * The FlexModule fabricator.
		 */
		protected var _fabricator:FlexModuleFabricator;

		/**
		 * Creates the FlexModule and initializes its fabricator.
		 */
		public function FlexModule() {
			super();
			
			initializeFabricator();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			_fabricator.dispose();
			_fabricator = null;
		}

		/**
		 * The FlexModule environment specific fabricator.
		 */
		public function get fabricator():ApplicationFabricator {
			return _fabricator;
		}

		/**
		 * The current application's message module address.
		 */
		public function get moduleAddress():IModuleAddress {
			return fabricator.moduleAddress;
		}

		/**
		 * The current application's default route.
		 */
		public function get defaultRoute():String {
			return fabricator.defaultRoute;
		}

		/**
		 * @private
		 */
		public function set defaultRoute(_defaultRoute:String):void {
			fabricator.defaultRoute = _defaultRoute;
		}

		/**
		 * The current application's message router. 
		 */
		public function get router():IRouter {
			return fabricator.router;
		}

		/**
		 * @private
		 */
		public function set router(_router:IRouter):void {
			fabricator.router = _router;
		}

		/**
		 * Instantiates the FlexModule environment specific fabricator.
		 */
		public function initializeFabricator():void {
			_fabricator = new FlexModuleFabricator(this);
		} 

		/**
		 * Abstract method. Subclasses should provide their application
		 * specific startup command class.
		 */
		public function getStartupCommand():Class {
			return null;
		}

		/**
		 * Returns the class reference for the specified qualified classpath.
		 * This method must be implemented by each module's main class
		 * in addition to the base application class. It allows the Fabrication
		 * apparatus to use reflection inside a module application swf from
		 * the parent shell swf. The body of this method must be,
		 * 
		 * @example The following code is the implementation of the fabrication
		 * <listing>
		 * 	public function getClassByName(classpath:String):Class {
		 * 		return getDefinitionByName(classpath) as Class;
		 * 	}
		 * </listing>
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#getClassByName 
		 */
		public function getClassByName(classpath:String):Class {
			return getDefinitionByName(classpath) as Class;
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#notifyFabricationCreated
		 */
		public function notifyFabricationCreated():void {
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED));			
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#notifyFabricationRemoved
		 */
		public function notifyFabricationRemoved():void {
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_REMOVED));			
		}
	}
}
