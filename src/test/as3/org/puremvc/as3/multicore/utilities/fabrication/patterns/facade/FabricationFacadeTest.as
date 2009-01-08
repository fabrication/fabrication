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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.facade {
	import flexunit.framework.SimpleTestCase;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexApplicationMock;
	import org.puremvc.as3.multicore.utilities.fabrication.components.empty.EmptyFlexModuleStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationControllerMock;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationModel;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationModelMock;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationView;
	import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationViewMock;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediatorMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.DisposableMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.SimpleFabricationCommandMock1;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxyMock;
	
	import mx.core.Application;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class FabricationFacadeTest extends SimpleTestCase {
		
		/* *
		static public function suite():TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(new FabricationFacadeTest("testFabricationFacadeDisposesSingletonsOnItsDisposal"));
			return suite;
		}
		/* */
		
		private var facade:FabricationFacade;
		
		public function FabricationFacadeTest(method:String) {
			super(method);
		}
		
		override public function setUp():void {
			facade = FabricationFacade.getInstance(methodName + "_setup");
		}
		
		override public function tearDown():void {
			facade.dispose();
			facade = null;
		}
		
		public function testFabricationFacadeHasValidType():void {
			assertType(FabricationFacade, facade);
			assertType(Facade, facade);
			assertType(IDisposable, facade);
		}
		
		public function testFabricationFacadeCachesInstancesOnItsMultitonKey():void {
			var key:String = methodName;
			var sampleSize:int = 25;
			var facade:FabricationFacade;
			var i:int;
			var j:int;
			
			for (i = 0; i < sampleSize; i++) {
				facade = FabricationFacade.getInstance(key + i);
				for (j = 0; j < sampleSize; j++) {
					assertEquals(facade, FabricationFacade.getInstance(key + i));
				}
			}
		}
		
		public function testFabricationFacadeCalculatesValidApplicationNameFromStartupCommand():void {
			assertEquals("SimpleFabricationMock", FabricationFacade.calcApplicationName(SimpleFabricationCommandMock));
			assertEquals("SimpleFabricationMock1", FabricationFacade.calcApplicationName(SimpleFabricationCommandMock1));
			
			assertEquals("SimpleFabrication", FabricationFacade.calcApplicationName(SimpleFabricationCommand));
			assertEquals("EmptyFlexModule", FabricationFacade.calcApplicationName(EmptyFlexModuleStartupCommand));
			
			assertThrows(Error);
			FabricationFacade.calcApplicationName(StartupCommand);
		}
		
		public function testFabricationFacadeUsesFabricationModel():void {
			var key:String = methodName;
			var fabricationModel:FabricationModel = FabricationModel.getInstance(key);
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			var proxy:FabricationProxyMock = new FabricationProxyMock("A0");
			proxy.mock.ignoreMissing = true;
			proxy.mock.method("getProxyName").returns("A0");
			
			facade.registerProxy(proxy);
			
			assertEquals(proxy, facade.retrieveProxy(proxy.getProxyName()));
		}
		
		public function testFabricationFacadeUsesFabricationView():void {
			var key:String = methodName;
			var fabricationView:FabricationView = FabricationView.getInstance(key);
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			var mediator:FabricationMediatorMock = new FabricationMediatorMock("B0");
			mediator.mock.ignoreMissing = true;
			mediator.mock.method("getMediatorName").withNoArgs.returns("B0");
			mediator.mock.method("listNotificationInterests").withNoArgs.returns([]);
			
			facade.registerMediator(mediator);
			
			assertEquals(mediator, facade.retrieveMediator(mediator.getMediatorName()));
		}
		
		public function testFabricationFacadeUsesFabricationController():void {
			var key:String = methodName;
			var fabricationController:FabricationController = FabricationController.getInstance(key);
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			
			facade.registerCommand("x0", SimpleFabricationCommandMock);
			
			assertTrue(facade.hasCommand("x0"));
		}
		
		public function testFabricationFacadeSavesValidApplicationReferenceOnStartup():void {
			facade.startup(SimpleFabricationCommandMock, Application.application);
			assertEquals(Application.application, facade.getApplication());
		}
		
		public function testFabricationFacadeSavesValidApplicationNameOnStartup():void {
			facade.startup(SimpleFabricationCommandMock, Application.application);
			assertEquals("SimpleFabricationMock", facade.getApplicationName());
		}
		
		public function testFabricationFacadeRegistersSpecifiedStartupCommandOnStartup():void {
			assertFalse(facade.hasCommand(FabricationNotification.STARTUP));
			facade.startup(SimpleFabricationCommandMock, Application.application);
			assertTrue(facade.hasCommand(FabricationNotification.STARTUP));
		}
		
		public function testFabricationFacadeSendsStartupNotificationOnStartup():void {
			var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
			mediator.mock.ignoreMissing = true;
			mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
			mediator.mock.method("listNotificationInterests").returns([FabricationNotification.STARTUP]);
			mediator.mock.method("handleNotification").withArgs(
				function(note:INotification):void {
					assertEquals(FabricationNotification.STARTUP, note.getName());
					assertEquals(Application.application, note.getBody());
				}
			);
			
			facade.registerMediator(mediator);
			facade.startup(SimpleFabricationCommandMock, Application.application);
			
			verifyMock(mediator.mock);
		}
		
		public function testFabricationFacadeSendsBootstrapNotificationOnStartup():void {
			var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
			mediator.mock.ignoreMissing = true;
			mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
			mediator.mock.method("listNotificationInterests").returns([FabricationNotification.BOOTSTRAP]);
			mediator.mock.method("handleNotification").withArgs(
				function(note:INotification):void {
					assertEquals(FabricationNotification.BOOTSTRAP, note.getName());
					assertEquals(Application.application, note.getBody());
				}
			);
			
			facade.registerMediator(mediator);
			facade.startup(SimpleFabricationCommandMock, Application.application);
			
			verifyMock(mediator.mock);
		}
		
		public function testFabricationFacadeInvokesUndoAndRedoOnFabricationController():void {
			var key:String = methodName;
			var stepSize:int = 5;
			var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			controller.mock.ignoreMissing = true;
			controller.mock.method("undo").withArgs(stepSize).once;
			controller.mock.method("redo").withArgs(stepSize).once;
			
			facade.undo(stepSize);
			facade.redo(stepSize);
			
			verifyMock(controller.mock);
		}
		
		public function testFabricationFacadeHasReferenceToItsFabrication():void {
			var fabrication:FlexApplicationMock = new FlexApplicationMock();
			facade.startup(SimpleFabricationCommandMock, fabrication);
			
			assertEquals(fabrication, facade.getFabrication());
		}
		
		public function testFabricationFacadeHasValidMultitonKey():void {
			assertEquals(methodName + "_setup", facade.getMultitonKey());
		}
		
		public function testFabricationFacadeSendsValidSystemNotificationToRouteNotifications():void {
			var mediator:FabricationMediatorMock = new FabricationMediatorMock("X0");
			mediator.mock.ignoreMissing = true;
			mediator.mock.method("getMediatorName").withNoArgs.returns("X0");
			mediator.mock.method("listNotificationInterests").returns([RouterNotification.SEND_MESSAGE_VIA_ROUTER]);
			mediator.mock.method("handleNotification").withArgs(
				function(note:INotification):Boolean {
					assertEquals(RouterNotification.SEND_MESSAGE_VIA_ROUTER, note.getName());
					
					var transport:TransportNotification = note.getBody() as TransportNotification;
					
					assertType(TransportNotification, transport);
					assertEquals("r0", transport.getName());
					assertEquals("r1", transport.getBody());
					assertEquals("r2", transport.getType());
					assertEquals("r3", transport.getTo());
					return true;
				}
			).once;
			
			facade.registerMediator(mediator);
			facade.startup(SimpleFabricationCommandMock, Application.application);
			facade.routeNotification("r0", "r1", "r2", "r3");
			
			verifyMock(mediator.mock);
		}
		
		public function testFabricationFacadeCanSaveSingletonInstanceWithoutDuplication():void {
			var key:String = methodName;
			var sampleSize:int = 25;
			var instance:Object;
			var i:int;
			
			for (i = 0; i < sampleSize; i++) {
				instance = new Object();
				assertEquals(instance, facade.saveInstance(key + i, instance));
				assertTrue(facade.hasInstance(key + i));
				assertEquals(instance, facade.findInstance(key + i));
				
				assertEquals(instance, facade.removeInstance(key + i));
				assertFalse(facade.hasInstance(key + i));
				assertNull(facade.findInstance(key + i));
			}
		}
		
		public function testFabricationFacadeDisposesModelViewAndControllerOnItsDisposal():void {
			var key:String = methodName;
			var model:FabricationModelMock = FabricationModelMock.getInstance(key);
			model.mock.ignoreMissing = true;
			model.mock.method("dispose").withNoArgs.once;
			
			var view:FabricationViewMock = FabricationViewMock.getInstance(key);
			view.mock.ignoreMissing = true;
			view.mock.method("dispose").withNoArgs.once;
			
			var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
			controller.mock.ignoreMissing = true;
			controller.mock.method("dispose").withNoArgs.once;
			
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			
			facade.dispose();
			
			verifyMock(model.mock);
			verifyMock(view.mock);
			verifyMock(controller.mock);
		}
		
		public function testFabricationFacadeDisposesSingletonsOnItsDisposal():void {
			var facade:FabricationFacade = FabricationFacade.getInstance(methodName);
			
			var sampleSize:int = 25;
			var i:int = 0; 
			var disposableMock:DisposableMock;
			var mockList:Array = new Array();
			
			for (i = 0; i < sampleSize; i++) {
				disposableMock = new DisposableMock();
				disposableMock.mock.method("dispose").withNoArgs.once;
				
				facade.saveInstance("_dispmock" + i, disposableMock);
				mockList.push(disposableMock);
			}
			
			facade.dispose();
			
			for (i = 0; i < sampleSize; i++) {
				disposableMock = mockList[i];
				verifyMock(disposableMock.mock);
			}
		}
		
		public function testFabricationRemovesCoreAfterItsDisposal():void {
			var key:String = methodName;
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			assertTrue(Facade.hasCore(key));
			
			facade.dispose();
			
			assertFalse(Facade.hasCore(key));			
		}
		
		public function testFabricationFacadeCanDirectlyExecuteCommandsUsingTheFabricationController():void {
			var key:String = methodName;
			var controller:FabricationControllerMock = FabricationControllerMock.getInstance(key);
			var facade:FabricationFacade = FabricationFacade.getInstance(key);
			var body:Object = new Object();
			var note:INotification = new Notification("x", "y", "z");
			
			assertEquals(controller, facade.fabricationController);
			
			controller.mock.method("executeCommandClass").withArgs(SimpleFabricationCommandMock, body, note).returns( new SimpleFabricationCommandMock()).once;
			facade.executeCommandClass(SimpleFabricationCommandMock, body, note);
			
			verifyMock(controller.mock);
		}
		
		public function testFabricationFacadeRegistersDefaultUndoCommands():void {
			assertTrue(facade.hasCommand(FabricationNotification.UNDO));
			assertTrue(facade.hasCommand(FabricationNotification.REDO));
			assertTrue(facade.hasCommand(FabricationNotification.CHANGE_UNDO_GROUP));
		}
		
	}
}
