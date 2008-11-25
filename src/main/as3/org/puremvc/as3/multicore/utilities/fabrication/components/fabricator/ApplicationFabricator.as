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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.NameUtils;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;		

	/**
	 * ApplicationFabricator is the base class for all fabrication 
	 * main application fabricators. Fabricators adapt the Fabrication
	 * bootstrap into environment specific implementations.
	 * 
	 * The typical flow of an ApplicationFabricator is,
	 * 
	 * <ul>
	 * 	<li>Subscribe to the ready event for the main application</li>
	 * 	<li>Once the main application instance is ready, start the fabricator sequence</li>
	 * 	<li>initializeModuleAddress()</li>
	 * 	<li>initializeFacade()</li>
	 * 	<li>initializeEnvironment()</li>
	 * 	<li>startApplication()</li>
	 * </ul>
	 * 
	 * <p>
	 * The ApplicationFabricator class provides the default implementation
	 * for most of steps the above sequence. The initializeEnvironment is
	 * the hook method provide to customize the fabrication to be specific
	 * to the environment that the fabrication is for, i.e:- Flex, Air, Flash
	 * etc.
	 * </p>
	 * 
	 * <p>
	 * The initializeEnvironment typically registers a startup command
	 * with the facade that is specific to the current environment. 
	 * </p>
	 * 
	 * <p>
	 * Subclasses must override atleast 2 methods in the concrete fabricators.
	 * <ul>
	 * 	<li>get readyEventName():String - Return the ready event name for the environment.</li>
	 * 	<li>initializeEnvironment():void - Register the fabrication system command with the startup notification.</li>
	 * </ul> 
	 * </p>
	 * 
	 * @author Darshan Sawardekar
	 */
	public class ApplicationFabricator extends EventDispatcher implements IRouterAwareModule {

		/**
		 * The main application fabrication instance
		 */
		protected var _fabrication:IFabrication;

		/**
		 * Reference to the current fabrication facade
		 */
		protected var _facade:FabricationFacade;

		/**
		 * Default route to the application for message routing
		 */
		protected var _defaultRoute:String;

		/**
		 * Address of the current application
		 */
		protected var _moduleAddress:IModuleAddress;

		/**
		 * Reference to the startup command
		 */
		protected var _startupCommand:Class;

		/**
		 * The name of the ready event. This needs to be provided by
		 * the subclasses as it is environment specific.
		 */
		protected var _readyEventName:String;

		/**
		 * The calculated application name.
		 */
		protected var _applicationClassName:String;

		/**
		 * The calculated application instance name
		 */
		protected var _applicationInstanceName:String;

		/**
		 * The multiton key of the facade.
		 */
		protected var _multitonKey:String;

		/**
		 * The current application's message router
		 */
		protected var _router:IRouter;

		/**
		 * Creates a new ApplicationFabricator and subscribes to its
		 * fabrication's ready event. 
		 */
		public function ApplicationFabricator(_fabrication:IFabrication) {
			super();
			
			this._fabrication = _fabrication;
			
			_startupCommand = _fabrication.getStartupCommand();
			_fabrication.addEventListener(readyEventName, readyEventListener);
		}

		/**
		 * Disposes the current application's facade and sends a
		 * fabrication removed event.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			if (_facade != null) {
				_facade.dispose();
				_facade = null;
			}
			
			_startupCommand = null;
			_router = null;
			
			notifyFabricationRemoved();
			
			if (_moduleAddress != null) {
				_moduleAddress.dispose();
				_moduleAddress = null;
			}
			
			_fabrication = null;			
		}

		/**
		 * Returns the id of the concrete fabrication.
		 */
		public function get id():String {
			return fabrication.id;
		}

		/**
		 * The current application fabrication. 
		 */
		public function get fabrication():IFabrication {
			return _fabrication;
		}

		/**
		 * The current application's fabrication facade.
		 */
		public function get facade():FabricationFacade {
			return _facade;
		}

		/**
		 * The default message route. For shell this is typically * and
		 * for modules it is ShellName/ShellInstanceName
		 */
		public function get defaultRoute():String {
			return _defaultRoute;
		}

		/**
		 * @private
		 */
		public function set defaultRoute(_defaultRoute:String):void {
			this._defaultRoute = _defaultRoute;
		}

		/**
		 * The module address of the current application.
		 */
		public function get moduleAddress():IModuleAddress {
			return _moduleAddress;
		}

		public function set moduleAddress(_moduleAddress:IModuleAddress):void {
			this._moduleAddress = _moduleAddress;
		}

		/**
		 * Calculates the multiton key for the facade and returns it.
		 */
		public function get multitonKey():String {
			if (_multitonKey == null) {
				_multitonKey = applicationClassName + "/" + applicationInstanceName;
			}
			
			return _multitonKey;
		}

		/**
		 * The current application's startup command class.
		 */
		public function get startupCommand():Class {
			return _startupCommand;
		}

		/**
		 * Calculates the current application's name from its startup command class. 
		 */
		public function get applicationClassName():String {
			if (_applicationClassName == null && _startupCommand != null) {
				_applicationClassName = FabricationFacade.calcApplicationName(_startupCommand);
			}
			
			return _applicationClassName;			
		}

		/**
		 * Calculates the current application's instance name.
		 */
		public function get applicationInstanceName():String {
			if (_applicationInstanceName == null && applicationClassName != null) {
				_applicationInstanceName = NameUtils.nextName(applicationClassName);
			} 
			
			return _applicationInstanceName;
		}

		/**
		 * The current application's message router.
		 */
		public function get router():IRouter {
			return _router;
		}

		/**
		 * @private
		 */
		public function set router(_router:IRouter):void {
			this._router = _router;			
		}

		/**
		 * The name of the ready event for the current fabrication environment.
		 */
		protected function get readyEventName():String {
			throw new Error("The readyEventName must be overridden by the concrete fabricator " + getQualifiedClassName(this));
		}

		/**
		 * Starts the default fabricator initialization sequence. 
		 */
		protected function initializeFabricator():void {
			if (_startupCommand == null) {
				try {
					// While testing we need to have startup command, because the events
					// escape out the try-catch
					var testCase:Class = getDefinitionByName("flexunit.framework.TestCase") as Class;
					if (testCase != null) {
						_startupCommand = getDefinitionByName("org.puremvc.as3.multicore.utilities.fabrication.components.empty.EmptyFlexModuleStartupCommand") as Class;
					};
				} finally {
					// if the startupCommand is still null, we are in implementation mode
					// and need to indicate to the user that the startup command is missing
					if (_startupCommand == null) {
						throw new Error("Startup command class not found in getStartupCommand method in the main application class.");
					}
				}
			}
			
			initializeModuleAddress();
			initializeFacade();
			
			// hook method for configuring concrete fabricators
			// based on their environment
			initializeEnvironment();
			
			// starts the application using the startup notification
			startApplication();
		}

		/**
		 * Creates the module address for the current application.
		 */
		protected function initializeModuleAddress():void {
			if (_moduleAddress == null) {
				_moduleAddress = new ModuleAddress(applicationClassName, applicationInstanceName);
			}
		}

		/**
		 * Creates the facade for the current application.
		 */
		protected function initializeFacade():void {
			_facade = FabricationFacade.getInstance(multitonKey);
		}

		/**
		 * Abstract method. Subclasses should register their startup command
		 * here and perform an environment specific configuration.
		 */
		protected function initializeEnvironment():void {
		}

		/**
		 * Starts the Fabrication apparatus using the startup method on
		 * the facade and notifies a fabrication created event to listeners.
		 */
		protected function startApplication():void {
			_facade.startup(startupCommand, fabrication);
			notifyFabricationCreated();
		}

		/**
		 * Reacts to the ready event by starting the default fabricator sequence.
		 */
		protected function readyEventListener(event:Event):void {
			_fabrication.removeEventListener(readyEventName, readyEventListener);
			initializeFabricator();
		} 

		/**
		 * Notifies a FABRICATION_CREATED event to listeners.
		 */
		protected function notifyFabricationCreated():void {
			fabrication.notifyFabricationCreated();
		}

		/**
		 * Notifies a FABRICATION_REMOVED event to listeners.
		 */
		protected function notifyFabricationRemoved():void {
			fabrication.notifyFabricationRemoved();
		}
	}
}
