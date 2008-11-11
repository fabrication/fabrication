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
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICloneable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentResolver;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ComponentRouteMapper;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.Expression;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	
	import mx.core.UIComponent;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FlexMediatorTest extends FabricationMediatorTest {
		
		public function FlexMediatorTest(method:String) {
			super(method);
		}
		
		override public function createMediator():FabricationMediator {
			return new FlexMediatorTestMock();
		}
		
		public function get flexMediator():FlexMediator {
			return mediator as FlexMediator;
		}
		
		public function testFlexMediatorHasValidType():void {
			assertType(FlexMediator, mediator);
			assertType(ICloneable, mediator);
		}
		
		public function testFlexMediatorReflectedCloneIsValid():void {
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
		
		public function testFlexMediatorAllowsChangingMediatorNameAfterInstantiation():void {
			assertGetterAndSetter(flexMediator, "mediatorName", String, null, "MyMediator");
		}
		
		public function testFlexMediatorSupportsComponentResolution():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			flexMediator.initializeNotifier(multitonKey);
			
			var baseComponent:UIComponent = new UIComponent();
			var resolver:ComponentResolver = flexMediator.resolve(baseComponent);
			
			assertNotNull(resolver);
			assertType(ComponentResolver, resolver);
			assertEquals(baseComponent, resolver.getBaseComponent());
		}
		
		public function testFlexMediatorThrowsErrorForNonUIComponentResolutionAttempts():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			flexMediator.initializeNotifier(multitonKey);

			assertThrows(Error);			
			flexMediator.resolve(new Object());
		}
		
		public function testFlexMediatorAllowsRegistrationOfFlexMediatorsWithPendingComponentResolutions():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			var notificationCache:HashMap = new HashMap();
			var routeMapper:ComponentRouteMapper = new ComponentRouteMapper();
			
			facade.mock.method("hasInstance").withArgs(String).returns(true).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.notificationCacheKey).returns(notificationCache).atLeast(1);
			facade.mock.method("findInstance").withArgs(FabricationMediator.routeMapperKey).returns(routeMapper).atLeast(1);
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
		
		public function testFlexMediatorResetsOnDisposal():void {
			facade.mock.method("getFabrication").withNoArgs.returns(fabrication);
			mediator.initializeNotifier(multitonKey);
			
			flexMediator.dispose();
			assertTrue(flexMediator.disposed);
		}
		
	}
}
