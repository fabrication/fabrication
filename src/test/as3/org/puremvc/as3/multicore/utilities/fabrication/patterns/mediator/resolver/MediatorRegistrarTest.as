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
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.utilities.fabrication.components.FabricationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.events.ComponentResolverEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacadeMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import mx.core.UIComponent;
	
	import flash.events.EventDispatcher;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class MediatorRegistrarTest extends SimpleTestCase {
		
		public var multitonKey:String;
		public var facade:FabricationFacadeMock;
		public var fabrication:FabricationMock;
		public var registrar:MediatorRegistrar;
		public var timeoutMS:int = 1000;
		
		public function MediatorRegistrarTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			multitonKey = methodName + "_setup";
			facade = FabricationFacadeMock.getInstance(multitonKey);
			fabrication = new FabricationMock();
			registrar = new MediatorRegistrar(facade);
		}
		
		override public function tearDown():void {
			facade = null;
			registrar = null;
		}
		
		public function createComponentResolver():ComponentResolverMock {
			return new ComponentResolverMock(new UIComponent(), facade, new ComponentRouteMapper());
		}
		
		public function createComponent(id:String):UIComponent {
			var component:UIComponent = new UIComponent();
			component.id = id;
			
			return component;
		}
		
		public function testMediatorRegistrarHasValidType():void {
			assertType(MediatorRegistrar, registrar);
			assertType(EventDispatcher, registrar);
			assertType(IDisposable, registrar);
		}
		
		public function testMediatorRegistrarSubscribesToResolversResolutionEventsOnRegistrationAndRunsResolver():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			
			var resolver:ComponentResolverMock = createComponentResolver();
			resolver.mock.method("addEventListener").withArgs(ComponentResolverEvent.COMPONENT_RESOLVED, Function).once;
			resolver.mock.method("addEventListener").withArgs(ComponentResolverEvent.COMPONENT_DESOLVED, Function).once;
			resolver.mock.method("run").withNoArgs.once;
			
			registrar.register(new FlexMediator(), resolver);
			
			assertTrue(resolver.mock.hasEventListener(ComponentResolverEvent.COMPONENT_RESOLVED));
			assertTrue(resolver.mock.hasEventListener(ComponentResolverEvent.COMPONENT_DESOLVED));
		}
		
		public function testMediatorRegistrarRegistersMediatorWithFacadeOnComponentResolution():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			
			var resolver:ComponentResolverMock = createComponentResolver();
			registrar.register(new FlexMediator(), resolver);
			
			var resolvedComponent:UIComponent = new UIComponent();
			
			var registrationCompleted:Function = function(event:MediatorRegistrarEvent):void {
				assertType(MediatorRegistrarEvent, event);
				assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
				assertEquals(resolvedComponent, event.mediator.getViewComponent());
			};
			
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, addAsync(registrationCompleted, timeoutMS));
			resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, resolvedComponent));
		}
		
		public function testMediatorRegistrarRegistersMultipleMediatorsWithFacadeOnMultimodeComponentResolution():void {
			var resolver:ComponentResolverMock = createComponentResolver();
			var mediator:FlexMediator = new FlexMediator(methodName);
			var baseName:String = methodName; 
			var sampleSize:int = 25;
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			facade.mock.method("registerMediator").withArgs(FlexMediator).times(sampleSize);
			
			mediator.initializeNotifier(multitonKey);
			
			resolver.mock.method("getMultimode").returns(true).atLeast(1);
			registrar.register(mediator, resolver);
			
			var registrationCompleted:Function = function(event:MediatorRegistrarEvent):void {
				assertType(MediatorRegistrarEvent, event);
				assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
				assertEquals(baseName + "/" + event.mediator.getViewComponent().id, event.mediator.getMediatorName());
			};
			
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, addAsync(registrationCompleted, timeoutMS));
			
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
		
		public function testMediatorRegistrarRemovesRegistrationWhenComponentIsDesolved():void {
			var resolver:ComponentResolverMock = createComponentResolver();
			var resolvedComponent:UIComponent = new UIComponent();
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			facade.mock.method("removeMediator").withArgs(String).once;
			
			registrar.register(new FlexMediator(), resolver);
			
			
			var registrationCanceled:Function = function(event:MediatorRegistrarEvent):void {
				assertType(MediatorRegistrarEvent, event);
				assertEquals(MediatorRegistrarEvent.REGISTRATION_CANCELED, event.type);
				assertEquals(resolvedComponent, event.mediator.getViewComponent());
			};
			
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_CANCELED, addAsync(registrationCanceled, timeoutMS));
			resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_RESOLVED, resolvedComponent));
			resolver.dispatchEvent(new ComponentResolverEvent(ComponentResolverEvent.COMPONENT_DESOLVED, resolvedComponent));
			
			verifyMock(facade.mock);
		}
		
		public function testMediatorRegistrarReturnsValidMediatorCorrespondingToSpecifiedComponent():void {
			var resolver:ComponentResolverMock = createComponentResolver();
			var mediator:FlexMediator = new FlexMediator(methodName);
			var baseName:String = methodName; 
			var sampleSize:int = 25;
			
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			facade.mock.method("registerMediator").withArgs(FlexMediator).times(sampleSize);
			
			mediator.initializeNotifier(multitonKey);
			
			resolver.mock.method("getMultimode").returns(true).atLeast(1);
			registrar.register(mediator, resolver);
			
			var registrationCompleted:Function = function(event:MediatorRegistrarEvent):void {
				assertType(MediatorRegistrarEvent, event);
				assertEquals(MediatorRegistrarEvent.REGISTRATION_COMPLETED, event.type);
				assertEquals(baseName + "/" + event.mediator.getViewComponent().id, event.mediator.getMediatorName());
				assertEquals(event.mediator, registrar.getMediator(event.mediator.getViewComponent() as UIComponent));
			};
			
			registrar.addEventListener(MediatorRegistrarEvent.REGISTRATION_COMPLETED, addAsync(registrationCompleted, timeoutMS));
			
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
		
		public function testMediatorRegistrarResetsAfterDisposal():void {
			registrar.dispose();
			
			assertThrows(Error);
			registrar.register(new FlexMediator(), createComponentResolver());
		}
		
	}
}
