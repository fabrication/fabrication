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
	import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.FlexEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;	

	/**
	 * Dispatched when a component was resolved from an expression.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent.COMPONENT_RESOLVED 
	 */
	[Event(name="componentResolved", type="org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent")]

	/**
	 * Dispatched when a component that was previously resolved was 
	 * desolved after it was removed.
	 * 
	 * @eventType org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent.COMPONENT_DESOLVED 
	 */
	[Event(name="componentDesolved", type="org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent")]

	/**
	 * ComponentResolver resolves expressions into their component objects
	 * on demand.
	 * 
	 * @author Darshan Sawardekar
	 */
	dynamic public class ComponentResolver extends Proxy implements IEventDispatcher, IDisposable {

		/**
		 * Regular expression used to find the numeric part of a component.
		 * This is used to identify index based routes from named routes.
		 */
		static private const partRegExp:RegExp = new RegExp("^([0-9]+)", "");
		
		/**
		 * Event indicating that the component has been created.
		 * @private 
		 */
		static private var createEventName:String = ChildExistenceChangedEvent.CHILD_ADD;
		
		/**
		 * Event indicating that the component has been initialized.
		 * @private
		 */
		static private var readyEventName:String = FlexEvent.CREATION_COMPLETE;
		
		/**
		 * Event indicating that the component has been removed.
		 * @private
		 */
		static private var removeEventName:String = ChildExistenceChangedEvent.CHILD_REMOVE;
		
		/**
		 * The base component to start resolution from.
		 * @private
		 */
		private var baseComponent:UIComponent;
		
		/**
		 * The initial component expression queried on the base component
		 * @private
		 */
		private var baseExpression:Expression;
		
		/**
		 * Indicates whether to resolve multiple components
		 * @private
		 */
		private var multimode:Boolean = false;
		
		/**
		 * EventDispatcher used to send events to listeners
		 */
		private var eventDispatcher:EventDispatcher;
		
		/**
		 * List of components that have been resolved so far
		 */
		private var resolvedComponents:Dictionary;
		
		/**
		 * Reference to the fabrication facade.
		 */
		private var facade:FabricationFacade;
		
		/**
		 * Route mapper instance cached to the current facade
		 */
		private var routeMapper:ComponentRouteMapper;

		/**
		 * Creates a new ComponentResolver for the base component specified
		 * and starts listening for component creation and removal on that component.
		 */
		public function ComponentResolver(baseComponent:UIComponent, facade:FabricationFacade, routeMapper:ComponentRouteMapper) {
			this.baseComponent = baseComponent;
			this.facade = facade;
			this.routeMapper = routeMapper;
			
			resolvedComponents = new Dictionary(true);
			eventDispatcher = new EventDispatcher(this);
						
			baseComponent.addEventListener(createEventName, handleCreateEvent, true);
			baseComponent.addEventListener(removeEventName, handleRemoveEvent, true);
		}

		/**
		 * @see Object#toString()
		 */		
		public function toString():String {
			return "[object ComponentResolver]";
		}
		
		/**
		 * Deletes the base component and expression and clears and
		 * resolved component references.
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			baseComponent.removeEventListener(createEventName, handleCreateEvent, true);
			baseComponent.removeEventListener(removeEventName, handleRemoveEvent, true);
			
			baseComponent = null;
			
			baseExpression.dispose();
			baseExpression = null;
			
			eventDispatcher = null;
			
			for (var component:Object in resolvedComponents) {
				delete(resolvedComponents[component]);				
			}
			
			routeMapper = null;
			resolvedComponents = null;
		}
		
		/**
		 * @see flash.events.EventDispatcher#addEventListener()
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @see flash.events.EventDispatcher#removeEventListener()
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @see flash.events.EventDispatcher#dispatchEvent()
		 */
		public function dispatchEvent(event:Event):Boolean {
			return eventDispatcher.dispatchEvent(event);
		}

		/**
		 * @see flash.events.EventDispatcher#hasEventListener()
		 */
		public function hasEventListener(type:String):Boolean {
			return eventDispatcher.hasEventListener(type);
		}

		/**
		 * @see flash.events.EventDispatcher#willEventListener()
		 */
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
		
		/**
		 * Sets the first expression on the component resolver chain.
		 * 
		 * @param baseExpression The first expression on the component resolver chain
		 * @param multimode Indicates whether to turn on multimode resolution.
		 */
		public function setBaseExpression(baseExpression:Expression, multimode:Boolean = true):Expression {
			this.multimode = multimode;
			this.baseExpression = baseExpression;
			
			baseExpression.root = this;
			
			return baseExpression;
		}
		
		/**
		 * Returns the base expression on the component resolver chain
		 */
		public function getBaseExpression():Expression {
			return baseExpression;
		}

		/**
		 * Creates a new child component expression with a regular expression
		 * and sets it as the base expression.
		 * 
		 * @param pattern The regular expression pattern string
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is true.
		 */
		public function re(pattern:String, multimode:Boolean = true):Expression {
			return setBaseExpression(Expression.reExpression(null, new RegExp(pattern, "")), multimode);
		}
		
		/**
		 * Creates a new descendant child expression with a regular expression
		 * and sets it as the base expression.
		 * 
		 * @param pattern The regular expression pattern string
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is true.
		 */
		public function rex(pattern:String, multimode:Boolean = true):Expression {
			var descendantsExpression:Expression = Expression.reExpression(baseExpression, Expression.descendantRegExp);
			Expression.reExpression(descendantsExpression, new RegExp(pattern, ""));
			
			return setBaseExpression(descendantsExpression, multimode);
		}

		/**
		 * Creates a new descendant expression and sets it the base
		 * expression.
		 * 
		 * @param name The name of the descendant component.
		 * @param multimode Specifies whether to match multiple components. Default is false.
		 */
		public function descendants(name:String, multimode:Boolean = false):Expression {
			return setBaseExpression(Expression.descendantsExpression(null, name), multimode);
		}

		/**
		 * Creates a named expression and sets it as the base expression.
		 * 
		 * @param name The name of the component
		 * @param multimode Optional multimode specifier if multiple components correspond to this expression. Default is false.
		 */
		public function resolve(name:String, multimode:Boolean = false):Expression {
			return setBaseExpression(Expression.nameExpression(null, name), multimode);
		}

		/**
		 * Starts matching the expression against the descriptors. 
		 */
		public function run():void {
			runExpressionOnDescriptors(baseComponent);
			if (baseComponent is Application && baseComponent["controlBar"] != null) {
				runExpression(baseComponent["controlBar"]);
			}
		}
		
		/**
		 * Returns the starting component of the resolution. 
		 */
		public function getBaseComponent():IEventDispatcher {
			return baseComponent;
		}		
		
		/**
		 * Changes the multimode match type of this resolver.
		 */
		public function setMultimode(multimode:Boolean):void {
			this.multimode = multimode;
		}
		
		/**
		 * Returns the multimode match type of this resolver.
		 */
		public function getMultimode():Boolean {
			return multimode;
		}

		/**
		 * For named component resolution with multimode true. Typically 
		 * the property operation is used. If .componentName() or 
		 * .componentName(true) is used multimode gets turn on.
		 */
		override flash_proxy function callProperty(name:*, ...args):* {
			var multimode:Boolean = (args.length == 1 && args[0] == true) || (args.length == 0);
			return resolve(name.toString(), multimode);
		}

		/**
		 * For named component resolution with multimode false. This is
		 * the most common usage.
		 */
		override flash_proxy function getProperty(name:*):* {
			return resolve(name.toString());
		}
		
		/**
		 * For descendant component resolution with multimode false.
		 */
		override flash_proxy function getDescendants(name:*):* {
			return descendants(name.toString());
		} 

		/**
		 * Matches the source component created against the current expression.
		 * @private 
		 */
		private function handleCreateEvent(event:ChildExistenceChangedEvent):void {
			if (event.relatedObject is UIComponent) {
				var relatedObject:UIComponent = event.relatedObject as UIComponent;
				runExpression(relatedObject);
			}
		}

		/**
		 * Runs the source component against the current expression.
		 * @private
		 */
		private function handleReadyEvent(event:FlexEvent):void {
			if (event.target["initialized"]) {
				runExpressionOnDescriptors(baseComponent);
			} 
			
			if (event.target is UIComponent) {
				var component:UIComponent = event.target as UIComponent;
				runExpression(component);
			}
		}
		
		/**
		 * If the source component was resolved earlier, it is marked as
		 * unresolved here.
		 * @private  
		 */
		private function handleRemoveEvent(event:ChildExistenceChangedEvent):void {
			var component:UIComponent = event.relatedObject as UIComponent;
			if (component != null && hasResolved(component)) {
				clearResolved(component);
			}
		}

		/**
		 * Executes the expression against the source component specified.
		 * @private
		 */
		private function runExpression(sourceComponent:UIComponent):Boolean {
			if (sourceComponent != null && baseExpression != null && !hasResolved(sourceComponent)) {
				var basePattern:RegExp = baseExpression.expand();
				var componentPath:String = calcPathFromComponent(sourceComponent);
				var matchResult:Object = basePattern.exec(componentPath);
				
				//debug("runExpression regex=" + basePattern.source + ", sourceComponent=" + sourceComponent);
				//debug("\tmatchResult=" + matchResult);
				if (matchResult != null) {
					var matchedGroup:String = matchResult[1];
					var matchedComponent:UIComponent = calcComponentFromPath(matchedGroup);
					
					//debug("\tmatchComponent=" + matchedComponent);
					if (matchedComponent == sourceComponent) {
						if (matchedComponent.initialized) {
							//debug("\tinitialized=" + matchedComponent.initialized);
							markAsResolved(matchedComponent);
							return true;
						} else {
							matchedComponent.addEventListener(readyEventName, handleReadyEvent);
						}
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Matches the source component against the static descriptors map.
		 * @private
		 */
		private function runExpressionOnDescriptors(component:UIComponent):void {
			if (baseExpression != null && !hasResolved(component)) {
				var routes:Array = routeMapper.fetchComponentRoutes(component);
				
				//printRoutes(routes);
				
				var n:int = routes.length;
				var route:ComponentRoute;
				var sourceComponent:UIComponent;
				
				for (var i:int = 0; i < n; i++) {
					route = routes[i];
					sourceComponent = calcComponentFromPath(route.path);
					
					if (sourceComponent != null) {
						runExpression(sourceComponent);
					}
				}
			}
		}
		
		/**
		 * Calculates the unique id of the component as specified in MXML.
		 * @private
		 */
		private function calcID(component:UIComponent):String {
			if (component == null) {
				return null;
			}

			if (component.id != null) {
				// needed with application states
				// this replaces the <Component>NNN to the id specified in the mxml.
				// not needed anymore, since using component[currentID] syntax.
				/* *
				if (component.name != component.id) { 
					component.name = component.id;
				}
				/* */
				
				return component.id;
			} else if (component.name != null) {
				return component.name;
			} else {
				return null;
			}
		}
		
		/**
		 * Calculates the path to the component uptil the baseComponent.
		 * @private
		 */
		private function calcPathFromComponent(component:UIComponent):String {
			if (baseComponent is Application && baseComponent["controlBar"] == component) {
				return calcID(component);
			}
			
			var currentComponent:UIComponent = component;
			var rootComponent:UIComponent = baseComponent;
			var path:String = "";

			while (currentComponent != null && currentComponent.parent != null && currentComponent != rootComponent) {
				path = calcID(currentComponent) + (path != "" ? "." + path : path);
				currentComponent = currentComponent.parent as UIComponent;				
			}
			
			return path;
		}
		
		/**
		 * Calculates the component from the path specified.
		 */
		private function calcComponentFromPath(path:String):UIComponent {
			if (baseComponent is Application && baseComponent["controlBar"] != null && baseComponent["controlBar"]["id"] == path) {
				return baseComponent["controlBar"];
			}
			
			var pathArray:Array = path.split(".");
			var currentID:String;
			var currentIDInt:int;
			var regres:Object;
			var currentComponent:UIComponent = baseComponent;
			var n:int = pathArray.length;
			var nextComponent:UIComponent;
			
			for (var i:int = 0; i < n; i++) {
				currentID = pathArray[i];
				regres = partRegExp.exec(currentID);
				
				if (regres != null) {
					currentIDInt = Number(regres[1]);
					if (currentIDInt < currentComponent.numChildren) {
						currentComponent = currentComponent.getChildAt(currentIDInt) as UIComponent;
					} else {
						//debug("ERROR : Cannot find child at index " + currentIDInt);
						currentComponent = null;
					}
				} else {

					// PATCH FOR FLEX4

					/*if (currentComponent.hasOwnProperty(currentID)) {
						nextComponent = currentComponent[currentID] as UIComponent;
					} else {
						nextComponent = currentComponent.getChildByName(currentID) as UIComponent;
					}*/

                    nextComponent = findComponentChildByName( currentComponent, currentID );

                    // END - PATCH FOR FLEX4
					
					if (nextComponent == null) {
						nextComponent = findComponentByID(currentComponent, currentID);
						//debug("+++++++++++ FOUND component by id " + nextComponent);
					}

					if (nextComponent == null) {
						//debug("ERROR : calcComponentFromPath failed for " + path);
						//debug("\t---currentID = " + currentID);
						//debug("\t---currentComponent = " + currentComponent);
						return null;
					}
					
					currentComponent = nextComponent;
				}
				
				if (currentComponent == null) {
					return null;
				}
			}
			
			//debug("calcComponentFromPath path=" + path + ", component=" + currentComponent);
			return currentComponent;
		}
		
		/**
		 * Locates a component from the id specified. Used when getChildByName returns
		 * null. This happens when id and name are both specified in the mxml tag.
		 * @private
		 */
		private function findComponentByID(component:UIComponent, id:String):UIComponent {
			var container:Container = component as Container;
			if (container == null) {
				return null;
			}
			
			var children:Array = container.getChildren();
			var n:int = children.length;
			var child:UIComponent;
			
			for (var i:int = 0; i < n; i++) {
				child = children[i];
				if (child.id == id) {
					return child;
				}
			}
			
			return null;
		}

        // PATCH FOR FLEX4
        private function findComponentChildByName( currentComponent:UIComponent, name:String ):UIComponent {

            var comp:UIComponent = null;
            if( currentComponent.hasOwnProperty( name ) )
                comp = currentComponent[ name ] as UIComponent;
            else {

                var numChildren:int = currentComponent.numChildren;
                var child:UIComponent;
                for( var i:int = 0; i<numChildren; ++i ) {

                    child = currentComponent.getChildAt( i ) as UIComponent;
                    if( child == null ) continue;
                    if( child.name == name || child.id == name) {

                        comp = child;
                        break;

                    }


                }

            }
            return comp;
        }
		
		/**
		 * Flags a component as resolved and sends an event indicating the same.
		 */
		private function markAsResolved(component:UIComponent):void {
			//debug("\t\tmarkAsResolved component=" + component);
			component.removeEventListener(readyEventName, handleReadyEvent);
			
			resolvedComponents[component] = true;
			dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, component, multimode));
		}
		
		/**
		 * Flags the component as unresolved and sends an event indicating the same.
		 */
		private function clearResolved(component:UIComponent):void {
			delete(resolvedComponents[component]);
			dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_DESOLVED, component, multimode));
		}
		
		/**
		 * Returns a boolean if the component has been resolved earlier.
		 */
		private function hasResolved(component:UIComponent):Boolean {
			return resolvedComponents[component] == true; 
		}
		
		/* *
		private function printRoutes(routes:Array):void {
			var n:int = routes.length;
			//debug("Total Routes = " + n);
			
			var route:ComponentRoute;
			for (var i:int = 0; i < n; i++) {
				route = routes[i];
				//debug("\t[" + route.id + " : " + route.path + "]");
			}
		}
		
		public function debug (...params):void {
			trace.apply(this, params);
		}
		/* */

	}
}