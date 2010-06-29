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
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlashApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;	

	/**
	 * Dispatched when the flash application's fabrication is created.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_CREATED
	 */
	[Event(name="fabricationCreated", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * Dispatched when the flash application's fabrication is removed.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_REMOVED
	 */
	[Event(name="fabricationRemoved", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * FlashApplication is the concrete fabrication for Flex applications.
	 * It creates the FlashApplicationFabricator to configure the fabrication
	 * to the flash environment.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlashApplication extends MovieClip implements IFabrication {
		
		/**
		 * The flash environment specific fabricator
		 */
		protected var _fabricator:FlashApplicationFabricator;

		/**
		 * Default route address assigned to this FlashApplication
		 */
		protected var _defaultRouteAddress:IModuleAddress;
		
		/**
		 * Optional configuration object 
		 */
		protected var _config:Object; 

		/**
		 * Initializes the FlexApplicationFabricator
		 */
		public function FlashApplication() {
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
		 * The flash environment specific fabricator
		 */		
		public function get fabricator():ApplicationFabricator {
			return _fabricator;
		}
		
		/**
		 * The message address for the current application
		 */
		public function get moduleAddress():IModuleAddress {
			return fabricator.moduleAddress;
		}

		/**
		 * The default route for the current application
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
		 * The default route address to be assigned to the child module.
		 */
		public function get defaultRouteAddress():IModuleAddress {
			return _defaultRouteAddress;
		}

		public function set defaultRouteAddress(_defaultRouteAddress:IModuleAddress):void {
			this._defaultRouteAddress = _defaultRouteAddress;
			defaultRoute = _defaultRouteAddress.getInputName();
		}

		/**
		 * The message router for the current application
		 */
		public function set router(_router:IRouter):void {
			fabricator.router = _router;
		}
		
		public function get router():IRouter {
			return fabricator.router;
		}
		
		/**
		 * The name of the current application module group for messaging.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule#moduleGroup
		 */
		public function get moduleGroup():String {
			return fabricator.moduleGroup;
		}
		
		public function set moduleGroup(moduleGroup:String):void {
			fabricator.moduleGroup = moduleGroup;
		}
		
		/**
		 * The configuration object of the current FlashApplication.
		 */
		public function get config():Object {
			return _config;
		}
		
		/**
		 * @private
		 */
		public function set config($config:Object):void {
			_config = $config;
		}
		
		/**
		 * Instantiates the flash environment specific fabricator. 
		 */
		public function initializeFabricator():void {
			_fabricator = new FlashApplicationFabricator(this);
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
			return getDefinitionByName(classpath) as Class;
		}
		
		/**
		 * For Flash applications the name is the id 
		 */
		public function get id():String {
			return name;
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
