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
	import mx.events.ModuleEvent;

	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModule;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexModuleLoader;
	import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;	

	/**
	 * FlexModuleLoaderFabricator is the concrete fabricator for FlexModuleLoader.
	 * The FlexModuleLoader only loads the module without performing the
	 * fabrication initialization sequence. It is only provided to propagate
	 * route changes from the ModuleLoader to Module.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlexModuleLoaderFabricator extends ApplicationFabricator {

		/**
		 * Indicates if the module has finisted loading
		 * @private
		 */
		private var _ready:Boolean = false;
		
		/**
		 * Creates a new FlexModuleLoaderFabricator
		 */
		public function FlexModuleLoaderFabricator(_fabrication:FlexModuleLoader) {
			super(_fabrication);
		}
		
		/**
         * @inheritDoc
         */
		override public function dispose():void {
			if (module != null) {
				module.removeEventListener(FabricatorEvent.FABRICATION_CREATED, moduleFabricationCreated);
				module.removeEventListener(FabricatorEvent.FABRICATION_REMOVED, moduleFabricationRemoved);
			}
			
			super.dispose();
		}
		
		/**
		 * Returns the fabrication as a FlexModuleLoader
		 */
		public function get moduleLoader():FlexModuleLoader {
			return fabrication as FlexModuleLoader;
		}
		
		/**
		 * Returns the child of the FlexModuleLoader as a FlexModule 
		 */
		public function get module():FlexModule {
			return moduleLoader.child as FlexModule;
		}

		/**
		 * Returns the fabricator for the child module if ready.
		 */
		public function get moduleFabricator():ApplicationFabricator {
			if (isReady()) {
				return (moduleLoader.child as IFabrication).fabricator;
			} else {
				return null;
			}
		}
		
		/**
		 * Indicates whether the module has finished loading.
		 */
		public function isReady():Boolean {
			return _ready;
		}
		
		/**
		 * Provides the ModuleLoader's ready event, i.e.:- ready
		 */
		override protected function get readyEventName():String {
			return ModuleEvent.READY;
		}
		
		/**
		 * Overrides the initializeFabricator to not performing the default
		 * initialization sequence. Instead it picks up the properties
		 * saved on the ModuleLoader for propagation.
		 */
		override protected function initializeFabricator():void {
			// ModuleLoader holds the references to the router and
			// defaultRoute until the Module is loader and ready
			// Here we fetch those values
			defaultRoute = moduleLoader.defaultRoute;
			router = moduleLoader.router;
			
			module.config = moduleLoader.config;
			module.moduleGroup = moduleLoader.moduleGroup;
			
			_ready = true;
			
			module.addEventListener(FabricatorEvent.FABRICATION_CREATED, moduleFabricationCreated);
			module.addEventListener(FabricatorEvent.FABRICATION_REMOVED, moduleFabricationRemoved);
		}
		
		/**
		 * Stops the FABRICATION_CREATED of the ModuleLoader's fabricator
		 * from being sent. When the module is ready its event will bubble
		 * up. 
		 */
		override protected function notifyFabricationCreated():void {
						
		}

		/**
		 * Stops the FABRICATION_REMOVED of the ModuleLoader's fabrication
		 * from being set. When the module is removed its event will bubble up.
		 */
		override protected function notifyFabricationRemoved():void {
			
		}
		
		/**
		 * Forwards a fabrication created event via the module loader
		 */
		protected function moduleFabricationCreated(event:FabricatorEvent):void {
			fabrication.notifyFabricationCreated();
		}
		
		/**
		 * Forwards a fabrication removed event via the module loader
		 */
		protected function moduleFabricationRemoved(event:FabricatorEvent):void {
			fabrication.notifyFabricationRemoved();
		}
	}
}
