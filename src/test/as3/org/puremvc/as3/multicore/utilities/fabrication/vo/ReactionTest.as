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

package org.puremvc.as3.multicore.utilities.fabrication.vo {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mock.EventDispatcherMock;
	
	import com.hexagonstar.util.debug.Debug;
	
	import flexunit.framework.SimpleTestCase;	

	/**
	 * @author Darshan Sawardekar
	 */
	public class ReactionTest extends SimpleTestCase {

		public var reaction:Reaction;

		public function ReactionTest(method:String) {
			super(method);
		}

		override public function setUp():void {
			reaction = new Reaction(null, null, null);
		}

		public function testReactionHasValidType():void {
			assertType(Reaction, reaction);
			assertType(IDisposable, reaction);
		}

		public function testReactionStoresEventSource():void {
			assertProperty(reaction, "source", IEventDispatcher, null, new EventDispatcher());
		}

		public function testReactionStoresEventType():void {
			assertProperty(reaction, "eventType", String, null, "click");
		}

		public function testReactionStoresEventHandler():void {
			assertProperty(reaction, "handler", Function, null, function():void {
			});
		}

		public function testReactionStoreCapturePhase():void {
			assertProperty(reaction, "capture", Boolean, false, true);
		}

		public function testReactionConstructorStoresPropertiesCorrectly():void {
			var expectedSource:IEventDispatcher = new EventDispatcher();
			var expectedEventType:String = "click";
			var expectedHandler:Function = function():void {
			};
			var expectedCapturePhase:Boolean = true;
			
			reaction = new Reaction(expectedSource, expectedEventType, expectedHandler, expectedCapturePhase);
			
			assertEquals(expectedSource, reaction.source);
			assertEquals(expectedEventType, reaction.eventType);
			assertEquals(expectedHandler, reaction.handler);
			assertEquals(expectedCapturePhase, reaction.capture);
		}

		public function testReactionSubscribesToSourceOnStart():void {
			var source:EventDispatcherMock = new EventDispatcherMock();
			var expectedHandler:Function = function(event:Event):void {
			};
			
			source.mock.method("addEventListener").withArgs("fooEvent", expectedHandler, false).once;
			
			assertFalse(source.mock.hasEventListener("fooEvent"));
			
			reaction = new Reaction(source, "fooEvent", expectedHandler);
			reaction.start();
			
			assertTrue(source.mock.hasEventListener("fooEvent"));
		}
		
		public function testReactionUnsubscribesFromSourceOnStop():void {
			var source:EventDispatcherMock = new EventDispatcherMock();
			var expectedHandler:Function = function(event:Event):void {
			};
			
			source.mock.method("addEventListener").withArgs("fooEvent", expectedHandler, false).once;
			
			reaction = new Reaction(source, "fooEvent", expectedHandler);
			reaction.start();
			
			assertTrue(source.mock.hasEventListener("fooEvent"));
			reaction.stop();
			assertFalse(source.mock.hasEventListener("fooEvent"));			
		}
		
		public function testReactionInvokesHandlerOnFulfil():void {
			var source:EventDispatcher = new EventDispatcher();
			var execCount:int = 0;
			var expectedHandler:Function = function(event:Event):void {
				assertEquals("fooEvent", event.type);
				execCount++;
			};
			
			reaction = new Reaction(source, "fooEvent", expectedHandler);
			reaction.start();
			
			source.dispatchEvent(new Event("fooEvent"));
			assertEquals(1, execCount);
		}
		
		public function testReactionInvokesHandlerOnManualFulfil():void {
			var source:EventDispatcher = new EventDispatcher();
			var execCount:int = 0;
			var expectedHandler:Function = function(event:Event):void {
				assertEquals("fooEvent", event.type);
				execCount++;
			};
			
			reaction = new Reaction(source, "fooEvent", expectedHandler);
			reaction.start();
			
			reaction.fulfil(new Event("fooEvent"));
			assertEquals(1, execCount);
		}
		
		public function testReactionResetsOnDisposal():void {
			var source:EventDispatcher = new EventDispatcher();
			var expectedHandler:Function = function(event:Event):void {
			};
			
			reaction = new Reaction(source, "fooEvent", expectedHandler);
			reaction.start();
			
			assertTrue(source.hasEventListener("fooEvent"));
			reaction.dispose();
			
			assertNull(reaction.source);
			assertNull(reaction.handler);
			assertNull(reaction.eventType);
			assertFalse(source.hasEventListener("fooEvent"));
		}
		
	}
}
