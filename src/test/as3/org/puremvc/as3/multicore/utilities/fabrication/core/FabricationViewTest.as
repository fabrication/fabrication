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
 
package org.puremvc.as3.multicore.utilities.fabrication.core {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.core.View;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediatorMock;		

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationViewTest extends SimpleTestCase {
		
		private var fabricationView:FabricationView;
		
		public function FabricationViewTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			fabricationView = FabricationView.getInstance(methodName + "_setup");
		}
		
		override public function tearDown():void {
			fabricationView.dispose();
			fabricationView = null;
		}
		
		public function testFabricationViewHasValidType():void {
			assertType(FabricationView, fabricationView);
			assertType(View, fabricationView);
			assertType(IDisposable, fabricationView);
		}
		
		public function testFabricationViewIsCachedByItsMultitonKey():void {
			var sampleSize:int = 25;
			var view:FabricationView;
			var i:int = 0;
			var j:int = 0;
			var key:String;
			
			for (i = 0; i < sampleSize; i++) {
				key = methodName + "_view" + i;
				view = FabricationView.getInstance(key);
				for (j = 0; j < sampleSize; j++) {
					assertEquals(view, FabricationView.getInstance(key));
				}
			}
		}
		
		public function testFabricationViewRemovesMultitonOnItsDisposal():void {
			var key:String = methodName;
			var fabricationView:FabricationView = FabricationView.getInstance(key);
			assertEquals(fabricationView, FabricationView.getInstance(key));
			
			fabricationView.dispose();
			
			assertNotEquals(fabricationView, FabricationView.getInstance(key));
		}
		
		public function testFabricationViewDisposesMediatorsOnItsDisposal():void {
			var fabricationView:FabricationView = new FabricationView(methodName);
			var mediator:FabricationMediatorMock;
			var sampleSize:int = 25;
			var mediatorList:Array = new Array();
			var i:int;
			var mediatorName:String; 
			
			for (i = 0; i < sampleSize; i++) {
				mediatorName = methodName + "_mediator" + i;
				mediator = new FabricationMediatorMock(mediatorName);
				mediator.mock.ignoreMissing = true;
				mediator.mock.method("dispose").withNoArgs.once;
				mediator.mock.method("getMediatorName").withNoArgs.returns(mediatorName);
				mediator.mock.method("listNotificationInterests").withNoArgs.returns([]);
				
				fabricationView.registerMediator(mediator);
				mediatorList.push(mediator);
			}
			
			fabricationView.dispose();
			
			for (i = 0; i < sampleSize; i++) {
				mediator = mediatorList[i];
				verifyMock(mediator.mock);
			}
		}
		
		public function testFabricationViewResetsAfterDisposal():void {
			var fabricationView:FabricationView = FabricationView.getInstance(methodName);
			fabricationView.dispose();
			
			assertThrows(Error);
			fabricationView.registerMediator(new FabricationMediatorMock("x"));

		}
		
	}
}
