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
    import flash.display.DisplayObject;
    import flash.utils.getDefinitionByName;

    import mx.core.UIComponent;
    import mx.modules.Module;

	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlexModuleFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;

	/**
	 * Dispatched when the flex module's fabrication is created.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_CREATED
	 */
	[Event(name="fabricationCreated", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * Dispatched when the flex module's fabrication is removed.
	 *
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_REMOVED
	 */
	[Event(name="fabricationRemoved", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * FlexModule is the concrete fabrication for the flex module environment.
	 * It uses the FlexModuleFabricator to provide a flex module environment
	 * specific configuration.
	 *
	 * @author Darshan Sawardekar, Rafał Szemraj
	 */
	public class FlexModule extends Module implements IFabrication {

		/**
		 * The FlexModule fabricator.
		 */
		protected var _fabricator:FlexModuleFabricator;

		/**
		 * Default route address assigned to this Module
		 */
		protected var _defaultRouteAddress:IModuleAddress;

		/**
		 * Optional configuration object.
		 */
		protected var _config:Object;

		/**
		 * Creates the FlexModule and initializes its fabricator.
		 */
		public function FlexModule() {
			super();

			initializeFabricator();
		}

		/**
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function get moduleAddress():IModuleAddress {
			return fabricator.moduleAddress;
		}

		/**
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function get moduleGroup():String {
			return fabricator.moduleGroup;
		}

		public function set moduleGroup(moduleGroup:String):void {
			fabricator.moduleGroup = moduleGroup;
		}

		/**
		 * @inheritDoc
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
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function initializeFabricator():void {
			_fabricator = new FlexModuleFabricator(this);
		}

		/**
		 * @inheritDoc
		 */
		public function getStartupCommand():Class {
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getClassByName(classpath:String):Class {
			return getDefinitionByName(classpath) as Class;
		}

		/**
		 * @inheritDoc
		 */
		public function notifyFabricationCreated():void {
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED));
		}

		/**
		 * @inheritDoc
		 */
		public function notifyFabricationRemoved():void {
			dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_REMOVED));
		}

        /**
         * @inheritDoc
         */
        public function get fabricationLoggerEnabled():Boolean
        {
            var parentFabrication:IFabrication;
            if( systemManager )
                    parentFabrication = parentApplication as IFabrication;
            return parentFabrication ? parentFabrication.fabricationLoggerEnabled : false;
        }

        /**
         * @inheritDoc
         */
        public function get dependencyProviders():Array
        {
            var parentFabrication:IFabrication;
            if( systemManager )
                    parentFabrication = parentApplication as IFabrication;
            return parentFabrication ? parentFabrication.dependencyProviders : [];
        }

	}
}
