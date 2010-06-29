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
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;

    import org.flexunit.async.Async;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.components.mock.FabricationMock;
    import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.mock.ComponentResolverMock;

    /**
     * @author Darshan Sawardekar
     */
    public class MediatorRegistrarTest extends BaseTestCase {

        public var multitonKey:String;
        public var facade:FacadeMock;
        public var fabrication:FabricationMock;
        public var registrar:MediatorRegistrar;
        public var timeoutMS:int = 1000;


        [Before]
        public function setUp():void
        {
            multitonKey = instanceName + "_setup";
            facade = FacadeMock.getInstance(multitonKey);
            fabrication = new FabricationMock();
            registrar = new MediatorRegistrar(facade);
        }

        [After]
        public function tearDown():void
        {
            facade = null;
            registrar = null;
        }

        public function createComponentResolver():ComponentResolverMock
        {
            return new ComponentResolverMock(new UIComponent(), facade, new ComponentRouteMapper());
        }

        public function createComponent(id:String):UIComponent
        {
            var component:UIComponent = new UIComponent();
            component.id = id;

            return component;
        }

        [Test]
        public function testMediatorRegistrarHasValidType():void
        {
            assertType(MediatorRegistrar, registrar);
            assertType(EventDispatcher, registrar);
            assertType(IDisposable, registrar);
        }

        [Test]
        public function testMediatorRegistrarSubscribesToResolversResolutionEventsOnRegistrationAndRunsResolver():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            var resolver:ComponentResolverMock = createComponentResolver();
            resolver.mock.method("addEventListener").withArgs(ComponentResolverEvent.COMPONENT_RESOLVED, Function).once;
            resolver.mock.method("addEventListener").withArgs(ComponentResolverEvent.COMPONENT_DESOLVED, Function).once;
            resolver.mock.method("run").withNoArgs.once;

            registrar.register(new FlexMediator(), resolver);

            assertTrue(resolver.mock.hasEventListener(ComponentResolverEvent.COMPONENT_RESOLVED));
            assertTrue(resolver.mock.hasEventListener(ComponentResolverEvent.COMPONENT_DESOLVED));
        }

        [Test(async)]
        public function testMediatorRegistrarRegistersMediatorWithFacadeOnComponentResolution():void
        {
            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);

            var resolver:ComponentResolverMock = createComponentResolver();
            registrar.register(new FlexMediator(), resolver);

            var resolvedComponent:UIComponent = new UIComponent();

            var registrationCompleted:Function = function(event:MediatorRegistrarEvent, passThroughData:Object = null ):void
            {
                assertType(MediatorRegistrarEvent, event);
                assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
                assertEquals(resolvedComponent, event.mediator.getViewComponent());
            };

            Async.handleEvent(this, registrar, MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompleted, timeoutMS);
            resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, resolvedComponent));
        }

        [Test(async)]
        public function testMediatorRegistrarRegistersMultipleMediatorsWithFacadeOnMultimodeComponentResolution():void
        {
            var resolver:ComponentResolverMock = createComponentResolver();
            var mediator:FlexMediator = new FlexMediator(instanceName);
            var baseName:String = instanceName;
            var sampleSize:int = 25;

            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            facade.mock.method("registerMediator").withArgs(FlexMediator).times(sampleSize);

            mediator.initializeNotifier(multitonKey);

            resolver.mock.method("getMultimode").returns(true).atLeast(1);
            registrar.register(mediator, resolver);

            var registrationCompleted:Function = function(event:MediatorRegistrarEvent, passThroughData:Object = null ):void
            {
                assertType(MediatorRegistrarEvent, event);
                assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
                assertEquals(baseName + "/" + event.mediator.getViewComponent().id, event.mediator.getMediatorName());
            };


            Async.handleEvent(this, registrar, MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompleted, timeoutMS);


            for (var i:int = 0; i < sampleSize; i++) {
                resolver.dispatchEvent(
                        new ComponentResolverEvent(
                                ComponentResolverEvent.COMPONENT_RESOLVED, createComponent("comp" + i)
                                )
                        );
            }

            verifyMock(resolver.mock);
            verifyMock(facade.mock);
        }

        [Test(async)]
        public function testMediatorRegistrarRemovesRegistrationWhenComponentIsDesolved():void
        {
            var resolver:ComponentResolverMock = createComponentResolver();
            var resolvedComponent:UIComponent = new UIComponent();

            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            facade.mock.method("removeMediator").withArgs(String).once;

            registrar.register(new FlexMediator(), resolver);


            var registrationCanceled:Function = function(event:MediatorRegistrarEvent, passThroughData:Object = null ):void
            {
                assertType(MediatorRegistrarEvent, event);
                assertEquals(MediatorRegistrarEvent.REGISTRATION_CANCELED, event.type);
                assertEquals(resolvedComponent, event.mediator.getViewComponent());
            };

            Async.handleEvent(this, registrar, MediatorRegistrarEvent.REGISTRATION_CANCELED, registrationCanceled, timeoutMS);
            resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, resolvedComponent));
            resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_DESOLVED, resolvedComponent));

            verifyMock(facade.mock);
        }

        [Test(async)]
        public function testMediatorRegistrarReturnsValidMediatorCorrespondingToSpecifiedComponent():void
        {
            var resolver:ComponentResolverMock = createComponentResolver();
            var mediator:FlexMediator = new FlexMediator(instanceName);
            var baseName:String = instanceName;
            var sampleSize:int = 25;

            facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
            facade.mock.method("registerMediator").withArgs(FlexMediator).times(sampleSize);

            mediator.initializeNotifier(multitonKey);

            resolver.mock.method("getMultimode").returns(true).atLeast(1);
            registrar.register(mediator, resolver);

            var registrationCompleted:Function = function(event:MediatorRegistrarEvent, passThroughData:Object = null ):void
            {
                assertType(MediatorRegistrarEvent, event);
                assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
                assertEquals(baseName + "/" + event.mediator.getViewComponent().id, event.mediator.getMediatorName());
                assertEquals(event.mediator, registrar.getMediator(event.mediator.getViewComponent() as UIComponent));
            };

            Async.handleEvent(this, registrar, MediatorRegistrarEvent.REGISTRATION_COMPLETED, registrationCompleted, timeoutMS);

            for (var i:int = 0; i < sampleSize; i++) {
                resolver.dispatchEvent(
                        new ComponentResolverEvent(
                                ComponentResolverEvent.COMPONENT_RESOLVED, createComponent("comp" + i)
                                )
                        );
            }

            verifyMock(resolver.mock);
            verifyMock(facade.mock);
        }

        [Test(expects="Error")]
        public function testMediatorRegistrarResetsAfterDisposal():void
        {
            registrar.dispose();
            registrar.register(new FlexMediator(), createComponentResolver());
        }


    }
}
