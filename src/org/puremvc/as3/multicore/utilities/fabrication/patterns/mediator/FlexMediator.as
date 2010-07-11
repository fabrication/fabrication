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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICloneable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.Expression;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.MediatorRegistrar;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.CloneUtils;
	
	import mx.core.UIComponent;
	
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;	

	/**
	 * FlexMediator is the base mediator class for all Flex based application
	 * mediators. It provides automatic component resolution using the 
	 * flex component resolver. 
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlexMediator extends FabricationMediator implements ICloneable {

		/**
		 * Default name of this mediator
		 */
		static public const NAME:String = "FlexMediator";

		/**
		 * Stores the registrars used in this mediator
		 */
		protected var registrars:Array;
		
		/**
		 * Flag indicates whether the mediator has been disposed
		 */
		public var disposed:Boolean = false;
		
		/**
		 * Singleton key name for the component resolver within this facade. 
		 */
		static public var routeMapperKey:String = "routeMapper"; 

		/**
		 * Reference to the component route mapper for this facade.
		 */
		protected var routeMapper:ComponentRouteMapper;

        /**
         * Names of injected properites
         */
        protected var injectionFieldsNames:Array;

		/**
		 * Creates a new FlexMediator object and initializes the registrars.
		 */
		public function FlexMediator(name:String = null, viewComponent:Object = null) {
			super(name, viewComponent);
			
			registrars = new Array();
		}

        /**
         * @inheritDoc
         */
        override public function onRegister():void
        {
            super.onRegister();
            performInjections();
        }

        /**
		 * Removes the registrars used by the mediator.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		override public function dispose():void {
			if (disposed) {
				return;
			}
			
			disposed = true;
			var n:int = registrars.length;
			var registrar:MediatorRegistrar;
			
			for (var i:int = 0; i < n; i++) {
				registrar = registrars[i] as MediatorRegistrar;

				registrar.removeEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompletedListener);
				registrar.removeEventListener(MediatorRegistrarEvent.REGISTRATION_CANCELED, registrationCanceledListener);
				
				registrar.dispose();
				registrars[i] = null;
			}
			
			registrars = null;
			routeMapper = null;

            if (injectionFieldsNames) {
                var injectedFieldsNum:uint = injectionFieldsNames.length;
                for ( i = 0; i < injectedFieldsNum; i++) {

                    var fieldName:String = ""+injectionFieldsNames[i];
                    this[ fieldName ] = null;
                }
                injectionFieldsNames = null;
            }

			super.dispose();
		}
		
		/**
		 * Overrides the initializeNotifier to initialize local references to the route mapper.
		 */
		override public function initializeNotifier(key:String):void {
			super.initializeNotifier(key);

			initializeRouteMapper();			
		}
		
		/**
		 * Creates the singleton route mapper for the current facade.
		 * @private
		 */
		protected function initializeRouteMapper():void {
			if (!fabFacade.hasInstance(routeMapperKey)) {
				routeMapper = fabFacade.saveInstance(routeMapperKey, new ComponentRouteMapper()) as ComponentRouteMapper;
			} else {
				routeMapper = fabFacade.findInstance(routeMapperKey) as ComponentRouteMapper;
			}
		}

		// Needs to be overridden if the the mediator is other than
		// (name:String, viewComponent:Object)
		// or (viewComponent:Object)
		/**
		 * Creates a shallow clone of the mediator using reflection.
		 * This method needs to override if the mediator constructor
		 * contains more than 2 required parameters that cannot take
		 * explicit null values. The supported constructors are,
		 * 
		 * <ul>
		 * 	<li>Mediator(name:String, viewComponent:Object)</li>
		 * 	<li>Mediator(viewComponent:Object)</li>
		 * 	<li>Mediator(name:String, viewComponent:Object, param1:String = null, ...args)</li>
		 * </ul>
		 */
		public function clone():ICloneable {
			var classpath:String = getQualifiedClassName(this);
			classpath.replace("::", ".");
			
			var clazz:Class = fabrication.getClassByName(classpath);
			var clazzInfo:XML = describeType(clazz);
			var constructorNode:XMLList = clazzInfo..constructor as XMLList; 
			var requiredParameters:XMLList = constructorNode.parameter.(@optional = "false"); 
			var requiredParametersCount:int = requiredParameters.length();
			var mediator:FlexMediator = CloneUtils.newInstance(clazz, requiredParametersCount) as FlexMediator;

			mediator.setMediatorName(getMediatorName());
			mediator.setViewComponent(getViewComponent());
			
			requiredParameters = null;
			constructorNode = null;
			clazzInfo = null;
			clazz = null;
			
			return mediator;
		}

		/**
		 * Changes the mediator name. This is done when RegExp 
		 * component resolvers are used.
		 * 
		 * @param name The name of the mediator
		 */
		public function setMediatorName(name:String):void {
			this.mediatorName = name;
		}
		
		/**
		 * Creates the base link of the component resolver chain. Additional
		 * link can be added to this to indicate the path to your viewComponent.
		 */
		public function resolve(baseComponent:Object):ComponentResolver {
			if (baseComponent is UIComponent) {
				return new ComponentResolver(baseComponent as UIComponent, fabFacade, routeMapper);
			} else {
				throw new Error("Incorrect baseComponent, " + baseComponent + ", resolve needs a valid baseComponent.");
			}
		}

		/**
		 * Overrides registerMediator to create on demand mediator registration.
		 * The mediator is only registered with the facade when the viewComponent
		 * that it is associated with is created. The viewComponent can be
		 * created with a deferred creationPolicy or programmatically as the
		 * result of an application state change, etc. The component
		 * resolver supports all these cases.
		 */		
		override public function registerMediator(mediator:IMediator):IMediator {
			var registrar:MediatorRegistrar = new MediatorRegistrar(fabFacade);
			var mediatorComponent:Object = mediator.getViewComponent();
			
			if (mediatorComponent is Expression) {
				var expression:Expression = mediatorComponent as Expression;
				var resolver:ComponentResolver = expression.root;
				var flexMediator:FlexMediator = mediator as FlexMediator;
	
				registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompletedListener);
				registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_CANCELED, registrationCanceledListener);
				
				registrars.push(registrar);
				registrar.register(flexMediator, resolver);
			} else {
				super.registerMediator(mediator);
			}
			
			return mediator;
		}
		
		/**
		 * Disposes the mediator on removal from the facade. Subclasses
		 * that override this should call super.dispose. 
		 */
		override public function onRemove():void {
			dispose();
		}
		
		/**
		 * Hook method to listen for a specific mediator registration. Subclasses
		 * can use this method to react to mediator registration as needed. 
		 */
		protected function registrationCompletedListener(event:MediatorRegistrarEvent):void {
			//var registrar:MediatorRegistrar = event.target as MediatorRegistrar;
			//trace("AutoRegistration completed for mediator " + event.mediator.getMediatorName());
			//trace("\tviewComponent = " + event.mediator.getViewComponent());
		}
		
		/**
		 * Hook method to listen for a specific mediator registration cancellation.
		 * Subclasses can use this method to react to mediator cancellation as needed.
		 */
		protected function registrationCanceledListener(event:MediatorRegistrarEvent):void {
			//var registrar:MediatorRegistrar = event.target as MediatorRegistrar;
			//trace("AutoRegistration removed for mediator " + event.mediator.getMediatorName());
		}

        /**
         * Performs injection action on current FlexMediator.
         * By convention we allow proxies and mediators injection on
         * FlexMediator instance
         * @see org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector
         * @see org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector
         */
        protected function performInjections():void
        {
            injectionFieldsNames = [];
            injectionFieldsNames = injectionFieldsNames.concat(( new ProxyInjector(fabFacade, this) ).inject());
            injectionFieldsNames = injectionFieldsNames.concat(( new MediatorInjector(fabFacade, this) ).inject());
        }
		
	}
}
