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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.test {
    import mx.core.UIComponent;

    import mx.utils.UIDUtil;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.fabrication_internal;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICloneable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FabricationMediatorTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.mock.FlexMediatorTestMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.Expression;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;

    /**
     * @author Darshan Sawardekar
     */
    public class FlexMediatorTest extends FabricationMediatorTest {

        override public function createMediator():FabricationMediator
        {
            return new FlexMediatorTestMock();
        }

        public function get flexMediator():FlexMediator
        {
            return mediator as FlexMediator;
        }

        [Test]
        public function flexMediatorHasValidType():void
        {
            assertType(FlexMediator, mediator);
            assertType(ICloneable, mediator);
        }

        [Test]
        public function flexMediatorReflectedCloneIsValid():void
        {
            var component:UIComponent = new UIComponent();

            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            flexMediator.initializeNotifier(multitonKey);
            flexMediator.setViewComponent(component);

            var clonedMediator:FlexMediator = flexMediator.clone() as FlexMediator;
            assertNotNull(clonedMediator);
            assertType(FlexMediator, clonedMediator);
            assertType(FlexMediatorTestMock, clonedMediator);

            assertEquals(flexMediator.getMediatorName(), clonedMediator.getMediatorName());
            assertEquals(component, clonedMediator.getViewComponent());

            verifyMock(facade.mock);
        }

        [Test]
        public function flexMediatorSupportsComponentResolution():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            flexMediator.initializeNotifier(multitonKey);

            var baseComponent:UIComponent = new UIComponent();
            var resolver:ComponentResolver = flexMediator.resolve(baseComponent);

            assertNotNull(resolver);
            assertType(ComponentResolver, resolver);
            assertEquals(baseComponent, resolver.getBaseComponent());
        }

        [Test(expects="Error")]
        public function testFlexMediatorThrowsErrorForNonUIComponentResolutionAttempts():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            flexMediator.initializeNotifier(multitonKey);
            flexMediator.resolve(new Object());
        }

        [Test]
        public function flexMediatorHasRouteMapperKey():void
        {
            assertNotNull(FlexMediator.routeMapperKey);
            assertType(String, FlexMediator.routeMapperKey);
        }

        [Test]
        public function flexMediatorAllowsRegistrationOfFlexMediatorsWithPendingComponentResolutions():void
        {
            use namespace fabrication_internal;

            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            var notificationCache:HashMap = new HashMap();
            var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();

            facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
            facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
            facade.mock.method("findInstance").withArgs(FlexMediator.routeMapperKey).returns(routeMapper).atLeast(1);
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            fabrication.mock.method("getClassByName").withArgs(String).returns(FabricationMediatorTestMock).atLeast(1);

            var baseComponent:UIComponent = new UIComponent();
            flexMediator.setMediatorName("BaseMediator");
            flexMediator.initializeNotifier(multitonKey);
            flexMediator.setViewComponent(baseComponent);

            var childMediator:FlexMediator = new FlexMediator(
                    "ChildMediator", flexMediator.resolve(baseComponent).childComponent
                    );

            var internalMediator:FlexMediator = flexMediator.registerMediator(
                    childMediator
                    ) as FlexMediator;

            assertNotNull(internalMediator);
            assertType(FlexMediator, internalMediator);

            var expr:Expression = internalMediator.getViewComponent() as Expression;
            assertEquals("childComponent", expr.source);
        }

        [Test]
        public function flexMediatorResetsOnDisposal():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            mediator.initializeNotifier(multitonKey);

            flexMediator.dispose();
            assertTrue(flexMediator.disposed);
        }

        [Test]
        public function mediatorInjection():void {

            facade.mock.method( "hasProxy" ).withArgs( "MyProxy" ).returns( true );
            facade.mock.method( "hasProxy" ).withArgs( "FabricationProxy" ).returns( true );
            facade.mock.method( "retrieveProxy" ).withArgs( "MyProxy" ).returns( new FabricationProxy( instanceName + UIDUtil.createUID() ) );
            facade.mock.method( "retrieveProxy" ).withArgs( "FabricationProxy" ).returns( new FabricationProxy( instanceName + UIDUtil.createUID() ) );
            facade.mock.method( "hasMediator" ).withArgs( "MyMediator" ).returns( true );
            facade.mock.method( "hasMediator" ).withArgs( "FlexMediator" ).returns( true );
            facade.mock.method( "retrieveMediator" ).withArgs( "MyMediator" ).returns( new FlexMediator( instanceName + UIDUtil.createUID() ) );
            facade.mock.method( "retrieveMediator" ).withArgs( "FlexMediator" ).returns( new FlexMediator( instanceName + UIDUtil.createUID() ) );
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication).atLeast(1);

            var component:UIComponent = new UIComponent();
            var mediatorWithInjection:FlexMediatorTestMock = new FlexMediatorTestMock( instanceName );
            mediatorWithInjection.setViewComponent( component );
            mediatorWithInjection.initializeNotifier(multitonKey);
            mediatorWithInjection.onRegister();
            assertNotNull( mediatorWithInjection.injectedProxy );
            assertTrue( FabricationProxy, mediatorWithInjection.injectedProxy );

            assertNotNull( mediatorWithInjection.injectedMediator );
            assertTrue( FabricationMediator, mediatorWithInjection.injectedMediator );

            assertNotNull( mediatorWithInjection.injectedProxyByName );
            assertTrue( IProxy, mediatorWithInjection.injectedProxy );

            assertNotNull( mediatorWithInjection.injectedMediatorByName );
            assertTrue( IMediator, mediatorWithInjection.injectedMediatorByName );

            mediatorWithInjection.dispose();
            assertNull( mediatorWithInjection.injectedProxy );
            assertNull( mediatorWithInjection.injectedProxyByName );
            assertNull( mediatorWithInjection.injectedMediator );
            assertNull( mediatorWithInjection.injectedMediatorByName );

            verifyMock( facade.mock );
        }

    }
}
