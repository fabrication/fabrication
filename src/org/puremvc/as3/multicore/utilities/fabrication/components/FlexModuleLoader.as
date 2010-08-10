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
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;
	
	import mx.modules.ModuleLoader;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlexModuleLoaderFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;	

	/**
	 * Dispatched when the fabrication of the flex module loaded by this
	 * module loader is created.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_CREATED
	 */
	[Event(name="fabricationCreated", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * Dispatched when the fabrication of the flex module loaded by this 
	 * module loader is removed.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent.FABRICATION_REMOVED
	 */
	[Event(name="fabricationRemoved", type="org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent")]

	/**
	 * FlexModuleLoader is the concrete application fabrication for
	 * loading flex modules. It implements IFabrication to allow
	 * configuration of the module prior to it has completed loading.
	 * 
	 * @author Darshan Sawardekar, Rafał Szemraj
	 */
	public class FlexModuleLoader extends ModuleLoader implements IFabrication {

		/**
		 * FlexModuleLoader specific fabricator
		 */
		protected var _fabricator:FlexModuleLoaderFabricator;
		
		/**
		 * Message router assigned to this ModuleLoader
		 */
		protected var _router:IRouter;
		
		/**
		 * Default route assigned to this ModuleLoader
		 */
		protected var _defaultRoute:String;
		
		/**
		 * Default route address assigned to this ModuleLoader
		 */
		protected var _defaultRouteAddress:IModuleAddress;
		
		/**
		 * The group that this application is part of.
		 */
		protected var _moduleGroup:String;
		
		/**
		 * Optional configuration object.
		 */
		protected var _config:Object;

		/**
		 * Creates the FlexModuleLoader and initializes is fabricator
		 */
		public function FlexModuleLoader() {
			super();
			applicationDomain = ApplicationDomain.currentDomain;
			initializeFabricator();
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			module.dispose();
			
			_fabricator.dispose();
			_fabricator = null;
			
			_router = null;
			_defaultRouteAddress = null;
		}

		/**
		 * Returns true if the child flex module is ready.
		 */
		public function isReady():Boolean {
			return _fabricator != null && _fabricator.isReady();
		}

		/**
		 * The FlexModuleLoader fabricator
		 */
		public function get fabricator():ApplicationFabricator {
			return _fabricator;
		}

		/**
		 * The child FlexModule fabricator. Returns null if the child is
		 * not ready.
		 */
		public function get moduleFabricator():ApplicationFabricator {
			if (_fabricator.isReady()) {
				return _fabricator.moduleFabricator;
			} else {
				return null;
			}
		}

		/**
		 * The child module as a FlexModule if ready, else null.
		 */
		public function get module():FlexModule {
			if (isReady()) {
				return child as FlexModule;
			} else {
				return null;
			}
		}

		/**
		 * The current application's module address
		 */
		public function get moduleAddress():IModuleAddress {
			return fabricator.moduleAddress;
		}

		/**
		 * The default route to be assigned to the child module.
		 */
		public function get defaultRoute():String {
			return fabricator.defaultRoute;
		}

		/**
		 * The configuration object of the current FlexApplication.
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
		
		public function set defaultRoute(_defaultRoute:String):void {
			this._defaultRoute = _defaultRoute;
			if (fabricator != null) { 
				fabricator.defaultRoute = _defaultRoute;
				if ((fabricator as FlexModuleLoaderFabricator).isReady()) {
					// if the defaultRoute was changed after initialization
					// it must propagate to the module
					module.defaultRoute = _defaultRoute;
				}
			}
		}

		/**
		 * The message router to be assigned to the child module.
		 */
		public function get router():IRouter {
			return _router;
		}

		public function set router(_router:IRouter):void {
			this._router = _router;
			if (fabricator != null) {
				fabricator.router = _router;
				if ((fabricator as FlexModuleLoaderFabricator).isReady()) {
					// if the router was changed after initialization
					// it must propagate to the module
					module.router = _router;
				}
			}
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
		 * The name of the current application module group for messaging.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule#moduleGroup
		 */
		public function get moduleGroup():String {
			if (fabricator != null) {
				return fabricator.moduleGroup;
			} else {
				return _moduleGroup;
			}
		}
		
		public function set moduleGroup(moduleGroup:String):void {
			if (fabricator != null) {
				fabricator.moduleGroup = moduleGroup;
			} else {
				_moduleGroup = moduleGroup;				
			}
		}
		
		/**
		 * Initializes the FlexModuleLoader specific fabricator.
		 */
		public function initializeFabricator():void {
			_fabricator = new FlexModuleLoaderFabricator(this);
		} 

		/**
		 * Returns null. This fabrication is a proxy to the FlexModule's fabrication.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication#getStartupCommand
		 */
		public function getStartupCommand():Class {
			return null;
		}

		/**
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
