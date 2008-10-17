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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {
	import flash.events.IEventDispatcher;

	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;	

	/**
	 * The interface that an application's main class must implement to 
	 * hook into the Fabrication apparatus. It allows different class
	 * heirarchies to support fabrication without needing to duplicate code
	 * needed to hook into the Fabrication apparatus from scratch. 
	 * 
	 * The application's main class creates an instance of the concrete 
	 * ApplicationFabricator and defers work to it. The ApplicationFabricator
	 * provides a standard fabrication for all applications with hook methods
	 * to customize it for the specific environment like Flex, Air, Flash, etc.  
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IFabrication extends IEventDispatcher, IRouterAwareModule {

		/**
		 * Returns the concrete ApplicationFabricator for the current 
		 * fabrication. 
		 * 
		 * @return The concrete ApplicationFabricator 
		 */
		function get fabricator():ApplicationFabricator;

		/**
		 * Returns the unique identifier of the current fabrication. This 
		 * corresponds to the id or instanceName provided by DisplayObject
		 * or UIComponent.
		 * 
		 * @return The unique identifier of the current fabrication
		 */
		function get id():String;

		/**
		 * Creates the concrete application fabricator. This method should 
		 * be invoked from the constructor function. The fabricator used
		 * corresponds to the environment it is created for. A 
		 * <code>FlexApplication</code> corresponds to <code>FlexApplicationFabricator</code>
		 * and so on.
		 */
		function initializeFabricator():void;

		/**
		 * Returns the startup command class for the application. The
		 * startup command will be executed with a startup notification 
		 * by the Fabrication facade.
		 * 
		 * The startup command class must be named <code>[ApplicationName]StartupCommand</code>.
		 * The [ApplicationName] will used as the name of the application or module
		 * inside Fabrication.
		 * 
		 * @return The application specific startup command class
		 */
		function getStartupCommand():Class;

		/**
		 * Returns the class reference for the specified qualified classpath.
		 * This method must be implemented by each application's main class
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
		 */
		function getClassByName(classpath:String):Class;
		
		/**
		 * Sends a FABRICATION_CREATED event to listeners
		 */
		function notifyFabricationCreated():void;
		
		/**
		 * Sends a FABRICATION_REMOVED event to listeners.
		 */ 
		function notifyFabricationRemoved():void;
		
	}
}
