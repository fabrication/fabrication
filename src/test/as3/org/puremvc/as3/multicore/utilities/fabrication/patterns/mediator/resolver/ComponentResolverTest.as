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
	import flexunit.framework.TestUtils;	
	import flexunit.framework.ModuleAwareTestCase;
	import flexunit.framework.TestSuite;
	
	import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.modules.Module;
	
	import flash.events.Event;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class ComponentResolverTest extends ModuleAwareTestCase {
		
		static public var counter:int = 0;
		static public var checksAdded:Boolean = false;
		
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			var moduleListLoader:ModuleListLoader = ModuleListLoader.getInstance();
			
			var modules:Array = moduleListLoader.modules;
			var n:int = modules.length;
			var module:String;
			
			var checkRegExp:RegExp = new RegExp("^check.*",	 "");
			var checkSuite:TestSuite = TestUtils.suite(ComponentResolverTest, checkRegExp);
			
			suite.addTest(checkSuite);
			
			for (var i:int = 0; i < n; i++) {
				module = modules[i];
				suite.addTest(create(module));
			}			
			
			return suite;
		}
		
		static public function create(moduleUrl:String):ComponentResolverTest {
			return new ComponentResolverTest("testComponentResolutionInModule", moduleUrl);
		}
		
		public var moduleUrl:String;
		public var facade:FabricationFacade;
		public var routeMapper:ComponentRouteMapper;
		public var multitonKey:String;
		public var routes:Array;
		public var resolutionCount:int = 0;
		public var resolutionAsyncHandler:Function;
		public var resolvers:Array = new Array();
		public var resolvedComponents:Array = new Array();
		public var routesMap:HashMap = new HashMap();
		
		public function ComponentResolverTest(method:String, moduleUrl:String = null) {
			super(method);
			
			this.moduleUrl = moduleUrl;
			//this.timeoutMS = 3000;
		}
		
		override public function setUp():void {
			multitonKey = methodName + (counter++);
			facade = FabricationFacade.getInstance(multitonKey);
			routeMapper = new ComponentRouteMapper();
		}
		
		override public function tearDown():void {
			facade = null;
		}
		
		public function checkComponentResolverHasValidType():void {
			var resolver:ComponentResolver = createComponentResolver();
			assertType(ComponentResolver, resolver);
			assertType(IDisposable, resolver);
		}
		
		public function checkComponentResolverStoresMultimode():void {
			var resolver:ComponentResolver = createComponentResolver();
			assertGetterAndSetter(resolver, "multimode", Boolean, false, true);
		}
		
		public function checkComponentResolverCreatesValidExpressionForRegularExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var expr:Expression = resolver.re("component.*");
			
			assertType(Expression, expr);
			assertTrue(resolver.getMultimode());
			assertEquals("component.*", expr.source); 
		}
		
		public function checkComponentResolverCreatesValidExpressionForDescendantRegularExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var descExpr:Expression = resolver.rex(methodName);
			var reExpr:Expression = descExpr.child;
			
			assertType(Expression, descExpr);
			assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
			assertEquals(reExpr, descExpr.child);
			assertEquals(methodName, reExpr.source);
			
			assertTrue(resolver.getMultimode());
			descExpr = resolver.rex(methodName, false);
			assertFalse(resolver.getMultimode());
		}
		
		public function checkComponentResolverCreatesValidDescendantsExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var descExpr:Expression = resolver.descendants(methodName);
			var nameExpr:Expression = descExpr.child;
			
			assertType(Expression, descExpr);
			assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
			assertType(Expression, nameExpr);
			assertEquals(methodName, nameExpr.source);
			
			assertFalse(resolver.getMultimode());
		}
		
		public function checkComponentResolverCreatesValidNamedExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var nameExpr:Expression = resolver.resolve(methodName);
			
			assertType(Expression, nameExpr);
			assertEquals(methodName, nameExpr.source);
			assertFalse(resolver.getMultimode());
			
			nameExpr = resolver.resolve(methodName, true);
			assertTrue(resolver.getMultimode());
		}
		
		public function checkComponentResolverStoresBaseExpression():void {
			var baseExpression:Expression = new Expression(null);
			var resolver:ComponentResolver = createComponentResolver();
			
			resolver.setBaseExpression(baseExpression);
			assertEquals(baseExpression, resolver.getBaseExpression());
			assertTrue(resolver.getMultimode());
			
			resolver.setBaseExpression(baseExpression, false);
			assertFalse(resolver.getMultimode());
			
			assertEquals(resolver, baseExpression.root);
		}
		
		public function checkDynamicPropertyNameExpressionBuildsValidLinkedExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var nameExpr:Expression = resolver[methodName];
			
			assertType(Expression, nameExpr);
			assertEquals(methodName, nameExpr.source);
			
			nameExpr = resolver.myProperty;
			assertEquals("myProperty", nameExpr.source);
			
			assertFalse(resolver.getMultimode());
		}
		
		public function checkDynamicNLevelPropertyNameExpressionBuildsValidLinkedExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var expr:Expression = resolver.harry.ron.hermione.hagrid.dumbledore;
			
			assertEquals("(harry\\.ron\\.hermione\\.hagrid\\.dumbledore)", resolver.getBaseExpression().expand().source);
		}
		
		public function checkDynamicMethodNameExpressionBuildsValidLinkedExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var expr:Expression = resolver.start;
			var nameExpr:Expression = expr[methodName];
			
			assertType(Expression, nameExpr);
			assertEquals(methodName, nameExpr.source);
			assertEquals(nameExpr, expr.child);
			
			nameExpr = expr.myProperty();
			assertEquals("myProperty", nameExpr.source);
			
			assertTrue(resolver.getMultimode());
			
			nameExpr = expr.multiProperty(false);
			assertFalse(resolver.getMultimode());
			
			nameExpr = expr.multiProperty(true);
			assertTrue(resolver.getMultimode());
		}
		
		public function checkDynamicDescendantsExpressionBuildsValidLinkedExpression():void {
			var resolver:ComponentResolver = createComponentResolver();
			var expr:Expression = resolver.start;
			var descExpr:Expression = expr..myComponent;
			var nameExpr:Expression = descExpr.child;
			
			assertType(Expression, descExpr);
			assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
			assertType(Expression, nameExpr);
			assertEquals("myComponent", nameExpr.source);
			
			assertFalse(resolver.getMultimode());
		}
		
		public function testComponentResolutionInModule():void {
			verifyExpressions(moduleUrl);
		}
		
		public function verifyExpressions(url:String):void {
			//trace("verifyRoutes " + url);
			loadModule(url,
				function(event:FlexEvent):void {
					var module:Module = event.target as Module;
					
					assertType(moduleUrl, Module, module);
					assertTrue("Routes property not found in " + moduleUrl, module.hasOwnProperty("routes"));
					
					var routes:Array = module["routes"];
					//trace("verifyExpressions url=" + url);
					//printRoutes(routes);
					
					assertType(moduleUrl, Array, routes);
					assertTrue("Routes array must not be empty in " + moduleUrl, routes.length > 0);
					
					validateExpressionsInModule(module, routes);
					//removeModule(module);
				}
			);
		}
		
		public function validateExpressionsInModule(module:Module, routes:Array):void {
			this.routes = routes;
			
			resolutionAsyncHandler = addAsync(
				verifyResolvedComponents, timeoutMS, null, resolutionTimeout
			);
			
			var resolver:ComponentResolver;
			var i:int;
			var n:int = routes.length;
			var route:Object;
			var id:String;
			var expr:Expression;
			var expectedComponent:UIComponent;
			
			for (i = 0; i < n; i++) {
				route = routes[i];
				id = route.id; 
				expr = calcExpressionRoot(route.expr);
				expectedComponent = route.component;
				routesMap.put(id, true);
				
				resolver = createComponentResolver(module);
				resolver.addEventListener(ComponentResolverEvent.COMPONENT_RESOLVED,
					function(event:ComponentResolverEvent):void {
						resolvedComponents.push({
							expr:(event.target as ComponentResolver).getBaseExpression(),
							expectedComponent:expectedComponent, 
							component:event.component
						});
						componentResolved(event);
					} 
				);				
				
				expr.root = resolver;
				resolver.setBaseExpression(expr);
				
				//trace("Expecting " + id + " = " + expr.expand());
				resolvers.push(resolver);
				resolver.run();
			}
		}
		
		public function verifyResolvedComponents(event:Event):void {
			var expectedResolutions:int = routes.length;
			var actualResolutions:int = resolvedComponents.length;
			var i:int;
			var wrapper:Object;
			var component:UIComponent;
			var id:String;
			var expectedComponent:UIComponent;
			var expectedComponentsMap:HashMap = new HashMap();
			var componentForID:UIComponent;
			
			for (i = 0; i < expectedResolutions; i++) {
				expectedComponent = routes[i].component;
				/* *
				trace("+++++ expectedComponent = " + routes[i]);
				for (var j:String in routes[i]) {
					trace("\t" + j + " : " + routes[i][j]);	
					
				}
				/* */
				expectedComponentsMap.put(expectedComponent.id, expectedComponent);
			}
			
			for (i = 0; i < actualResolutions; i++) {
				wrapper = resolvedComponents[i];
				component = wrapper.component;
				expectedComponent = wrapper.expectedComponent;
			
				componentForID = expectedComponentsMap.find(component.id) as UIComponent;
				
				assertNotNull("No component expected for resolved component id=" + component.id + ", component=" + component);
				assertEquals(componentForID, component);
			}
		}
		
		public function calcExpressionRoot(expr:Expression):Expression {
			var resolver:ComponentResolver = expr.root;
			return resolver.getBaseExpression();
		}
		
		public function componentResolved(event:ComponentResolverEvent):void {
			//trace("-----------------resolved " + event.component);
			
			if (resolvedComponents.length == routes.length) {
				resolutionAsyncHandler(event);
			}
		}
		
		public function resolutionTimeout(event:Event):void {
			fail(moduleUrl + " - resolution did not complete within expected interval.");
		}
		
		public function stubResolutionAsyncHandler(event:Event):void {
			
		}
		
		public function createComponentResolver(component:UIComponent = null):ComponentResolver {
			if (component == null) {
				component = new UIComponent();
			}
			
			return new ComponentResolver(component, facade, routeMapper);
		}
		
		private function printRoutes(routes:Array):void {
			var n:int = routes.length;
			trace("Total Routes = " + n);
			
			var route:Object;
			for (var i:int = 0; i < n; i++) {
				route = routes[i];
				trace("\t[" + route.id + " : " + route.path + "]" + (route.component ? " = " + route.component : ""));
			}
		}
	}
}
