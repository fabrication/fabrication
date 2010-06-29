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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test {
    import flash.events.Event;

    import mx.core.UIComponent;
    import mx.modules.Module;

    import org.flexunit.async.Async;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.ComponentsDataProvider;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.ModuleAwareTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.*;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    [RunWith("org.flexunit.runners.Parameterized")]
    public class ComponentResolverTest extends ModuleAwareTestCase {

        static public var counter:int = 0;
        static public var checksAdded:Boolean = false;

        public var facade:FabricationFacade;
        public var routeMapper:ComponentRouteMapper;
        public var multitonKey:String;
        public var routes:Array;
        public var resolutionCount:int = 0;
        public var resolutionAsyncHandler:Function;
        public var resolvers:Array = new Array();
        public var resolvedComponents:Array = new Array();
        public var routesMap:HashMap = new HashMap();


        public function ComponentResolverTest(moduleUrl:String)
        {
            this.moduleUrl = moduleUrl;
        }


        public static var dataRetriever:ComponentsDataProvider = new ComponentsDataProvider("moduleLayouts.xml");

        [Parameters(loader="dataRetriever")]
        public static var componentsUrls:Array;

        [Before]
        public function setUp():void
        {
            multitonKey = instanceName + (counter++);
            facade = FabricationFacade.getInstance(multitonKey);
            routeMapper = new ComponentRouteMapper();
        }

        [After]
        public function tearDown():void
        {
            facade = null;
        }

        [Test]
        public function checkComponentResolverHasValidType():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            assertType(ComponentResolver, resolver);
            assertType(IDisposable, resolver);
        }

        [Test]
        public function checkComponentResolverStoresMultimode():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            assertFalse(resolver.getMultimode());
            resolver.setMultimode(true);
            assertTrue(resolver.getMultimode());
            resolver.setMultimode(false);
            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function checkComponentResolverCreatesValidExpressionForRegularExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var expr:Expression = resolver.re("component.*");

            assertType(Expression, expr);
            assertTrue(resolver.getMultimode());
            assertEquals("component.*", expr.source);
        }


        [Test]
        public function checkComponentResolverCreatesValidExpressionForDescendantRegularExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var descExpr:Expression = resolver.rex(instanceName);
            var reExpr:Expression = descExpr.child;

            assertType(Expression, descExpr);
            assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
            assertEquals(reExpr, descExpr.child);
            assertEquals(instanceName, reExpr.source);

            assertTrue(resolver.getMultimode());
            descExpr = resolver.rex(instanceName, false);
            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function checkComponentResolverCreatesValidDescendantsExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var descExpr:Expression = resolver.descendants(instanceName);
            var nameExpr:Expression = descExpr.child;

            assertType(Expression, descExpr);
            assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);

            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function checkComponentResolverCreatesValidNamedExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var nameExpr:Expression = resolver.resolve(instanceName);

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);
            assertFalse(resolver.getMultimode());

            nameExpr = resolver.resolve(instanceName, true);
            assertTrue(resolver.getMultimode());
        }

        [Test]
        public function checkComponentResolverStoresBaseExpression():void
        {
            var baseExpression:Expression = new Expression(null);
            var resolver:ComponentResolver = createComponentResolver();

            resolver.setBaseExpression(baseExpression);
            assertEquals(baseExpression, resolver.getBaseExpression());
            assertTrue(resolver.getMultimode());

            resolver.setBaseExpression(baseExpression, false);
            assertFalse(resolver.getMultimode());

            assertEquals(resolver, baseExpression.root);
        }

        [Test]
        public function checkDynamicPropertyNameExpressionBuildsValidLinkedExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var nameExpr:Expression = resolver[instanceName];

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);

            nameExpr = resolver.myProperty;
            assertEquals("myProperty", nameExpr.source);

            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function checkDynamicNLevelPropertyNameExpressionBuildsValidLinkedExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var expr:Expression = resolver.harry.ron.hermione.hagrid.dumbledore;

            assertEquals("(harry\\.ron\\.hermione\\.hagrid\\.dumbledore)", resolver.getBaseExpression().expand().source);
        }

        [Test]
        public function checkDynamicMethodNameExpressionBuildsValidLinkedExpression():void
        {
            var resolver:ComponentResolver = createComponentResolver();
            var expr:Expression = resolver.start;
            var nameExpr:Expression = expr[instanceName];

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);
            assertEquals(nameExpr, expr.child);

            nameExpr = expr.myProperty();
            assertEquals("myProperty", nameExpr.source);

            assertTrue(resolver.getMultimode());

            nameExpr = expr.multiProperty(false);
            assertFalse(resolver.getMultimode());

            nameExpr = expr.multiProperty(true);
            assertTrue(resolver.getMultimode());
        }

        [Test]
        public function checkDynamicDescendantsExpressionBuildsValidLinkedExpression():void
        {
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

        [Test(async)]
        public function testComponentResolutionInModule():void
        {

            super.loadModule();


        }


        override protected function moduleReadyAsyncHandler(event:Event, passThroughData:Object = null):void
        {
            super.moduleReadyAsyncHandler(event, passThroughData);
            var module:Module = event.target as Module;
            assertType(moduleUrl, Module, module);
            assertTrue("Routes property not found in " + moduleUrl, module.hasOwnProperty("routes"));
            var routes:Array = module["routes"];
            assertType(moduleUrl, Array, routes);
            assertTrue("Routes array must not be empty in " + moduleUrl, routes.length > 0);
            validateExpressionsInModule(module, routes);
        }

        private function validateExpressionsInModule(module:Module, routes:Array):void
        {
            this.routes = routes;

            resolutionAsyncHandler = Async.asyncHandler(this,
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
                id = route.elementName;
                expr = calcExpressionRoot(route.expr);
                expectedComponent = route.component;
                routesMap.put(id, true);

                resolver = createComponentResolver(module);
                resolver.addEventListener(ComponentResolverEvent.COMPONENT_RESOLVED,
                                          function(event:ComponentResolverEvent):void
                                          {
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

        private function verifyResolvedComponents(event:Event, passThroughData:Object = null):void
        {
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

        private function calcExpressionRoot(expr:Expression):Expression
        {
            var resolver:ComponentResolver = expr.root;
            return resolver.getBaseExpression();
        }

        private function componentResolved(event:ComponentResolverEvent):void
        {
            //trace("-----------------resolved " + event.component);

            if (resolvedComponents.length == routes.length) {
                resolutionAsyncHandler(event);
            }
        }

        private function resolutionTimeout(event:Event):void
        {
            fail(moduleUrl + " - resolution did not complete within expected interval.");
        }

        private function stubResolutionAsyncHandler(event:Event):void
        {

        }

        private function createComponentResolver(component:UIComponent = null):ComponentResolver
        {
            if (component == null) {
                component = new UIComponent();
            }

            return new ComponentResolver(component, facade, routeMapper);
        }

        private function printRoutes(routes:Array):void
        {
            var n:int = routes.length;
            trace("Total Routes = " + n);

            var route:Object;
            for (var i:int = 0; i < n; i++) {
                route = routes[i];
                trace("\t[" + route.elementName + " : " + route.path + "]" + (route.component ? " = " + route.component : ""));
            }
        }


    }
}
