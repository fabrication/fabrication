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
	 * Dispatched when the AIR application's fabrication is created.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_CREATED
	 */
	[Event(name="fabricationCreated", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * Dispatched when the AIR application's fabrication is removed.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_REMOVED
	 */
	[Event(name="fabricationRemoved", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * AirApplication is the base application class for AIR applications
	 * that use fabrication. It uses the AirApplicationFabricator to
	 * provide AIR environment specific configuration.
	 *
	 * @author Darshan Sawardekar, Rafał Szemraj
	 */
	public class AirHaloApplication extends WindowedApplication implements IFabrication {

		/**
		 * AIR specific application fabricator.
		 */
		protected var _fabricator:AirApplicationFabricator;

		/**
		 * Optional configuration object.
		 */
		protected var _config:Object;

		/**
		 * Creates a new AirApplication and initializes it fabricator.
		 */
		public function AirHaloApplication() {
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
		 * The configuration object of the current AirApplication.
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

        /**
         * @inheritDoc
         */
        public function get fabricationLoggerEnabled():Boolean
        {
            return false;
        }

        /**
         * @inheritDoc
         */
        public function get depnedencyProviders():Array
        {
            return [];
        }
	}
}
