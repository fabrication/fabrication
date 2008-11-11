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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing {
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.AbstractFabricationCommandTest;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
	import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class RouteMessageCommandTest extends AbstractFabricationCommandTest {
		
		public function RouteMessageCommandTest(method:String) {
			super(method);
		}
		
		override public function createCommand():ICommand {
			return new RouteMessageCommand();
		}
		
		override public function createNotification():INotification {
			var transport:TransportNotification = new TransportNotification(
				"changeNote", "changeBody", "changeType", "X/*"
			);
			
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT", transport
			);
			
			return new RouterNotification(
				RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, null, null, message
			);
		}
		
		public function testRouteMessageCommandHasValidType():void {
			assertType(RouteMessageCommand, command);
			assertType(SimpleFabricationCommand, command);
		}
		
		public function testRouteMessageCommandTranslatesDynamicTransportNotificationIntoSystemNotification():void {
			var routerNote:RouterNotification = notification as RouterNotification;
			var transport:TransportNotification = routerNote.getMessage().getNotification();
			
			facade.mock.method("notifyObservers").withArgs(
				function(note:INotification):Boolean {
					assertType(RouterNotification, note);
					var rnote:RouterNotification = note as RouterNotification;
					assertType(IRouterMessage, rnote.getMessage());
					
					assertEquals(routerNote.getMessage(), rnote.getMessage());
					assertEquals(transport, rnote.getMessage().getNotification());
					
					assertEquals(note.getName(), transport.getName());
					assertEquals(note.getType(), transport.getType());
					assertEquals(note.getBody(), transport.getBody());
					
					return true;
				}
			).once;
			
			executeCommand();
			
			verifyMock(facade.mock);
		}
		
		public function testRouteMessageCommandTranslatesCustomNotificationStoredInTransportNotificationIntoSystemNotificationOfThatCustomNotificationType():void {
			var customNotification:Notification = new Notification(
				"changeNote", "changeBody", "changeType"
			);
			
			var transport:TransportNotification = new TransportNotification(
				customNotification, "M/*"
			);
			
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT", transport
			);
			
			var routerNote:INotification = new RouterNotification(
				RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, null, null, message
			);
			
			facade.mock.method("notifyObservers").withArgs(
				function(note:INotification):Boolean {
					assertType(Notification, note);
					
					assertEquals(customNotification.getName(), note.getName());
					assertEquals(customNotification.getBody(), note.getBody());
					assertEquals(customNotification.getType(), note.getType());
					
					return true;
				}
			).once;
			
			executeCommand(routerNote);
			
			verifyMock(facade.mock);			
		}
		
		public function testRouteMessageCommandAttachesSourceRouterMessageToCustomNotificationsThatAreRouterMessageStoreAware():void {
			var customNotification:RouterMessageStoreMock = new RouterMessageStoreMock(
				"changeNote", "changeBody", "changeType"
			);
			
			var transport:TransportNotification = new TransportNotification(
				customNotification, "M/*"
			);
			
			var message:RouterMessage = new RouterMessage(
				Message.NORMAL, null, "A/A0/OUTPUT", "B/B0/INPUT", transport
			);
			
			customNotification.mock.method("getName").returns("changeNote");
			customNotification.mock.method("getBody").returns("changeBody");
			customNotification.mock.method("getType").returns("changeType");
			customNotification.mock.method("setMessage").withArgs(message).once;
			
			var routerNote:INotification = new RouterNotification(
				RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER, null, null, message
			);
			
			facade.mock.method("notifyObservers").withArgs(
				function(note:INotification):Boolean {
					assertType(RouterMessageStoreMock, note);
					
					assertEquals(customNotification.getName(), note.getName());
					assertEquals(customNotification.getBody(), note.getBody());
					assertEquals(customNotification.getType(), note.getType());
					
					return true;
				}
			).once;
			
			executeCommand(routerNote);
			
			verifyMock(facade.mock);
			verifyMock(customNotification.mock);			
		}
		
	}
}
