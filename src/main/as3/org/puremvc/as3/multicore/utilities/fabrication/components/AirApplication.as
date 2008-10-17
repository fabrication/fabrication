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
	
	import mx.core.WindowedApplication;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.AirApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;	

	/**
	 * AirApplication is the base application class for AIR applications
	 * that use fabrication. It uses the AirApplicationFabricator to
	 * provide AIR environment specific configuration. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class AirApplication extends WindowedApplication implements IFabrication {
		
		/**
		 * AIR specific application fabricator.
		 */
		protected var _fabricator:AirApplicationFabricator;

		/**
		 * Creates a new AirApplication and initializes it fabricator.
		 */
		public function AirApplication() {
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
		 * The AIR specific application fabricator.
		 */		
		public function get fabricator():ApplicationFabricator {
			return _fabricator;
		}
		
		/**
		 * The message address of the current module.
		 */
		public function get moduleAddress():IModuleAddress {
			return fabricator.moduleAddress;
		}
		
		/**
		 * The default message route for the current module.
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
		 * Instatiates the AIR application fabricator.
		 */
		public function initializeFabricator():void {
			_fabricator = new AirApplicationFabricator(this);
		} 
		
		/**
		 * Abstract method. Subclasses should provide their application
		 * specific startup command class.
		 */
		public function getStartupCommand():Class {
			return null;
		}
		
		/**
		 * Concrete implementation of getClassByName.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#getClassByName
		 */
		public function getClassByName(classpath:String):Class {
			return getDefinitionByName(name) as Class;
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
