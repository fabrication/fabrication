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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICloneable;	
	
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.CloneUtils;	

	/**
	 * Dispatched when a component resolution resulted in the creation and
	 * registration of a new mediator with the fabrication facade.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent.REGISTRATION_COMPLETED
	 */
	[Event(name="registrationCompleted", type="org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent")]
	
	/**
	 * Dispatched when a component desolution resulted in the removal
	 * of the previously registered mediator.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent.REGISTRATION_CANCELED
	 */
	[Event(name="registrationCanceled", type="org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent")]

	/**
	 * MediatorRegistrar registers the mediator associated with the component
	 * once it becomes available. It also removes the mediator once the component
	 * is removed. For multimode matches the mediator is either cloned or
	 * recreated using a reflection of the original mediator.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class MediatorRegistrar extends EventDispatcher implements IDisposable {

		/**
		 * Classpath to the cloneable interface.
		 * @private
		 */
		static private var cloneableClass:String = getQualifiedClassName(ICloneable);

		/**
		 * Reference to the fabrication facade.
		 * @private
		 */
		private var facade:FabricationFacade;
		
		/**
		 * Reflected information of the original mediator
		 */
		private var defaultMediator:FlexMediator;
		private var defaultMediatorClass:Class;
		private var defaultMediatorCloneable:Boolean;
		private var defaultMediatorParams:Number; 
		 
		/**
		 * HashMap of mediators with their target component id.
		 */
		private var mediatorsMap:Object;
		
		/**
		 * Component path resolver.
		 */
		private var resolver:ComponentResolver;
		
		/**
		 * The name of the original mediator
		 */
		private var defaultMediatorName:String;
		
		/**
		 * Flag indicating if the original mediator object has been
		 * registed on the first component resolution.
		 */
		private var usedDefaultMediator:Boolean = false;
		
		/**
		 * Creates a new MediatorRegistrar and initializes the mediators
		 * hash map.
		 */
		public function MediatorRegistrar(facade:FabricationFacade) {
			this.facade = facade;
			
			mediatorsMap = new Object();
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose() 
		 */
		public function dispose():void {
			facade = null;
			
			resolver.removeEventListener(ComponentResolverEvent.COMPONENT_RESOLVED, componentResolvedListener);
			resolver.removeEventListener(ComponentResolverEvent.COMPONENT_DESOLVED, componentDesolvedListener);
			
			resolver.dispose();
			resolver = null; 
			
			defaultMediator = null;
			mediatorsMap = null;
		}
		
		/**
		 * Returns the mediator for the component specified. If no component
		 * specified this is a single component resolution so returns the 
		 * default mediator.
		 * 
		 * @param component The component's mediator 
		 */
		public function getMediator(component:UIComponent = null):FlexMediator {
			if (defaultMediator != null && (!getUseSuffix() || component == null)) {
				return defaultMediator;
			} else {
				return mediatorsMap[component.id] as FlexMediator;
			}
		}
		
		/**
		 * Saves the original mediator and its reflected information and
		 * starts the component resolution.
		 * 
		 * @param mediator The original mediator object
		 * @param resolver The component resolver 
		 */
		public function register(mediator:FlexMediator, resolver:ComponentResolver):void {
			this.resolver = resolver;
			
			saveMediaterInfo(mediator);
			
			resolver.addEventListener(ComponentResolverEvent.COMPONENT_RESOLVED, componentResolvedListener);
			resolver.addEventListener(ComponentResolverEvent.COMPONENT_DESOLVED, componentDesolvedListener);
			
			resolver.run();
		}

		/**
		 * Finds a mediator for the component resolved and registers it 
		 * with the facade.
		 * @private
		 */
		private function componentResolvedListener(event:ComponentResolverEvent):void {
			var component:UIComponent = event.component;
			var mediator:FlexMediator = getMediator(component);
			
			if (mediator == null) {
				createMediator(component);
			} else {
				registerMediator(mediator, component);
			}
		}

		/**
		 * Finds the mediator for the component that was removed and
		 * unregisters its mediator.
		 * @private
		 */
		private function componentDesolvedListener(event:ComponentResolverEvent):void {
			var component:UIComponent = event.component;
			var mediator:FlexMediator = getMediator(component);
			
			if (mediator != null) {
				unregisterMediator(mediator);
			}
		}
		
		/**
		 * Assigns the component to the mediator and registers it with the
		 * fabrication facade.
		 * @private
		 */
		private function registerMediator(mediator:FlexMediator, component:UIComponent):void {
			if (getUseSuffix()) {
				mediator.setMediatorName(defaultMediatorName + "/" + component.id);
			}
			
			mediator.setViewComponent(component);
			facade.registerMediator(mediator);			
			
			dispatchEvent(new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_COMPLETED, mediator));
		}
		
		/**
		 * Removes the mediator from the fabrication facade.
		 * @private
		 */
		private function unregisterMediator(mediator:FlexMediator):void {
			dispatchEvent(new MediatorRegistrarEvent(MediatorRegistrarEvent.REGISTRATION_CANCELED, mediator));
			
			delete(mediatorsMap[mediator.getViewComponent().id]);
			
			if (!getUseSuffix()) {
				defaultMediator = null;
			}
						
			facade.removeMediator(mediator.getMediatorName());
		}
		
		/**
		 * Suffixed mediator names are used only with multimode component
		 * resolvers.
		 * @private
		 */
		private function getUseSuffix():Boolean {
			return resolver.getMultimode();
		}
		
		/**
		 * Creates a mediator for the specified component. If the original
		 * mediator has not been used yet it is returned. Else a cloned
		 * mediator is created from it. 
		 * @private
		 */
		private function createMediator(component:UIComponent):FlexMediator {
			var mediator:FlexMediator = getMediator(component);
			if (mediator == null) {
				if (!usedDefaultMediator && defaultMediator != null) {
					mediator = defaultMediator;
					usedDefaultMediator = true;
				} else {
					mediator = cloneMediator();
				}
				
				if (mediator != null) {
					mediatorsMap[component.id] = mediator;
					registerMediator(mediator, component);					
				}
			}
			
			return mediator;
		}
		
		/**
		 * Builds information about the original mediator and saves it.
		 * This is used later for reflection purposes.
		 * @private 
		 */
		private function saveMediaterInfo(mediator:FlexMediator):void {
			var classpath:String = getQualifiedClassName(mediator);
			classpath.replace("::", ".");
			
			var fabrication:IFabrication = facade.getFabrication();
			var clazz:Class = fabrication.getClassByName(classpath);
			var clazzInfo:XML = describeType(clazz);
			var implementsInterfaces:XMLList = clazzInfo..implementsInterface;
			var constructorNode:XMLList = clazzInfo..constructor; 
			var requiredParameters:XMLList = constructorNode.parameter.(@optional == "false"); 
			
			defaultMediator = mediator;
			defaultMediatorName = mediator.getMediatorName();
			defaultMediatorClass = clazz;
			defaultMediatorCloneable = (clazzInfo..implementsInterface.(@type == cloneableClass)).length() == 1;
			defaultMediatorParams = requiredParameters.length();
		}
		
		/**
		 * Clones the original mediator if it is present else
		 * creates a new one using the reflected details of the
		 * original mediator.
		 * @private
		 */
		private function cloneMediator():FlexMediator {
			if (defaultMediatorCloneable && defaultMediator != null) {
				return defaultMediator.clone() as FlexMediator;
			} else {
				return CloneUtils.newInstance(defaultMediatorClass, defaultMediatorParams) as FlexMediator;
			}
		}
		
	}
}
