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

package org.puremvc.as3.multicore.utilities.fabrication.vo.test {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.mock.EventDispatcherMock;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.*;

    /**
     * @author Darshan Sawardekar
     */
    public class ReactionTest extends BaseTestCase {

        public var reaction:Reaction;

        [Before]
        public function setUp():void
        {
            reaction = new Reaction(null, null, null);
        }

        [After]
        public function tearDown():void
        {

            reaction = null;

        }

        [Test]
        public function reactionHasValidType():void
        {

            assertType(Reaction, reaction);
            assertType(IDisposable, reaction);
        }

        [Test]
        public function reactionStoresEventSource():void
        {
            assertProperty(reaction, "source", IEventDispatcher, null, new EventDispatcher());
        }

        [Test]
        public function reactionStoresEventType():void
        {
            assertProperty(reaction, "eventType", String, null, "click");
        }

        [Test]
        public function reactionStoresEventHandler():void
        {
            assertProperty(reaction, "handler", Function, null, function():void
                {
            });
        }

        [Test]
        public function reactionStoreCapturePhase():void
        {
            assertProperty(reaction, "capture", Boolean, false, true);
        }

        [Test]
        public function reactionConstructorStoresPropertiesCorrectly():void
        {
            var expectedSource:IEventDispatcher = new EventDispatcher();
            var expectedEventType:String = "click";
            var expectedHandler:Function = function():void
                {
            };
            var expectedCapturePhase:Boolean = true;

            reaction = new Reaction(expectedSource, expectedEventType, expectedHandler, expectedCapturePhase);

            assertEquals(expectedSource, reaction.source);
            assertEquals(expectedEventType, reaction.eventType);
            assertEquals(expectedHandler, reaction.handler);
            assertEquals(expectedCapturePhase, reaction.capture);
        }

        [Test]
        public function reactionSubscribesToSourceOnStart():void
        {
            var source:EventDispatcherMock = new EventDispatcherMock();
            var expectedHandler:Function = function(event:Event):void
                {
            };

            source.mock.method("addEventListener").withArgs("fooEvent", expectedHandler, false).once;

            assertFalse(source.mock.hasEventListener("fooEvent"));

            reaction = new Reaction(source, "fooEvent", expectedHandler);
            reaction.start();

            assertTrue(source.mock.hasEventListener("fooEvent"));
        }

        [Test]
        public function reactionUnsubscribesFromSourceOnStop():void
        {
            var source:EventDispatcherMock = new EventDispatcherMock();
            var expectedHandler:Function = function(event:Event):void
                {
            };

            source.mock.method("addEventListener").withArgs("fooEvent", expectedHandler, false).once;

            reaction = new Reaction(source, "fooEvent", expectedHandler);
            reaction.start();

            assertTrue(source.mock.hasEventListener("fooEvent"));
            reaction.stop();
            assertFalse(source.mock.hasEventListener("fooEvent"));
        }

        [Test]
        public function reactionInvokesHandlerOnFulfil():void
        {
            var source:EventDispatcher = new EventDispatcher();
            var execCount:int = 0;
            var expectedHandler:Function = function(event:Event):void
                {
                assertEquals("fooEvent", event.type);
                execCount++;
            };

            reaction = new Reaction(source, "fooEvent", expectedHandler);
            reaction.start();

            source.dispatchEvent(new Event("fooEvent"));
            assertEquals(1, execCount);
        }

        [Test]
        public function reactionInvokesHandlerOnManualFulfil():void
        {
            var source:EventDispatcher = new EventDispatcher();
            var execCount:int = 0;
            var expectedHandler:Function = function(event:Event):void
                {
                assertEquals("fooEvent", event.type);
                execCount++;
            };

            reaction = new Reaction(source, "fooEvent", expectedHandler);
            reaction.start();

            reaction.fulfil(new Event("fooEvent"));
            assertEquals(1, execCount);
        }

        [Test]
        public function reactionResetsOnDisposal():void
        {
            var source:EventDispatcher = new EventDispatcher();
            var expectedHandler:Function = function(event:Event):void
                {
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

        [Test]
        public function reactionCompare():void
        {
            var ed:EventDispatcher = new EventDispatcher();
            var handler:Function = function():void
                {
            };
            var r:Reaction = new Reaction(ed, "event", handler);

            var r1:Reaction = new Reaction(ed, "event", handler );
            var r2:Reaction = new Reaction(ed, "event", null);
            var r3:Reaction = new Reaction(ed, "event", handler, true);
            var r4:Reaction = new Reaction(ed, "event", null, true);

            assertTrue( r.compare( r1 ) );
            assertTrue( r.compare( r2 ) );
            assertFalse( r.compare( r3 ) );
            assertTrue( r.compare( r4 ) );

        }


    }
}
