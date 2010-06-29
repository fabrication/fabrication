package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.test {
    import org.flexunit.async.Async;
    import org.puremvc.as3.multicore.patterns.observer.Notification;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.events.NotificationProcessorEvent;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.*;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.mock.InterceptorMock;

    /**
     * @author Darshan Sawardekar
     */
    public class NotificationProcessorTest extends BaseTestCase {

        public var processor:NotificationProcessor;
        public var note:Notification;


        [Before]
        public function setUp():void
        {
            note = new Notification(instanceName + "note");
            processor = new NotificationProcessor(note);
        }

        [After]
        public function tearDown():void
        {
            processor.dispose();

            note = null;
            processor = null;
        }

        [Test]
        public function testNotificationProcessorHasValidType():void
        {
            assertType(NotificationProcessor, processor);
            assertType(IDisposable, processor);
        }

        [Test]
        public function testNotificationProcessorConstructorSavesNotification():void
        {
            assertEquals(note, processor.getNotification());
        }

        [Test]
        public function testNotificationProcessorCanStoreInterceptors():void
        {
            var interceptor:InterceptorMock = new InterceptorMock();
            interceptor.mock.property("processor").withArgs(processor).once;
            interceptor.mock.method("intercept").withNoArgs.once;

            processor.addInterceptor(interceptor);
            processor.run();

            verifyMock(interceptor.mock);
        }

        [Test]
        public function testNotificatonProcessorCanRemoveInterceptors():void
        {
            var interceptor:InterceptorMock = new InterceptorMock();
            interceptor.mock.property("intercept").withNoArgs.never;
            interceptor.mock.method("dispose").withNoArgs.once;

            processor.addInterceptor(interceptor);
            processor.removeInterceptor(interceptor);
            processor.run();

            verifyMock(interceptor.mock);
        }

        [Test]
        public function testNotificationProcessorRunsOnAllRegisteredInterceptors():void
        {
            var sampleSize:int = 25;
            var interceptor:InterceptorMock;
            var interceptors:Array = new Array();
            var i:int;

            for (i = 0; i < sampleSize; i++) {
                interceptor = new InterceptorMock();
                interceptor.mock.property("notification").withArgs(note);
                interceptor.mock.method("intercept").withNoArgs.once;

                interceptors.push(interceptor);
                processor.addInterceptor(interceptor);
            }

            processor.run();

            for (i = 0; i < sampleSize; i++) {
                interceptor = interceptors[i];
                verifyMock(interceptor.mock);
            }
        }

        [Test(async)]
        public function testNotificationProcessorSendsProceedEventOnProceed():void
        {

            var verifyProceedEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {
                assertNotNull(event.notification);
                assertTrue(event.notification == note);
            };

            Async.handleEvent(this, processor, NotificationProcessorEvent.PROCEED, verifyProceedEvent, 100);
            processor.proceed(note);
        }

        [Test(async)]
        public function testNotificationProcessorDoesNotSendProceedEventOnFinish():void
        {
            var verifyProceedEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {

            };
            var noProceed:Boolean = true;
            var verifyNoProceedEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {
                noProceed = false;
            };

            Async.handleEvent(this, processor, NotificationProcessorEvent.PROCEED, verifyProceedEvent, 100);
            processor.proceed(note);

            processor.addEventListener(NotificationProcessorEvent.PROCEED, verifyNoProceedEvent);
			processor.proceed(note);

            assertTrue(noProceed);
        }

        [Test(async)]
        public function testNotificationProcessorSendsFinishEventOnProceed():void
        {
            var verifyFinishEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {
                assertTrue(NotificationProcessorEvent.FINISH == event.type);
            };

            Async.handleEvent(this, processor, NotificationProcessorEvent.FINISH, verifyFinishEvent, 100);
            processor.proceed(note);
        }

        [Test(async)]
        public function testNotificationProcessorSendsAbortEventOnAbort():void
        {
            var verifyAbortEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {
                assertTrue(NotificationProcessorEvent.ABORT == event.type);
            };

            Async.handleEvent(this, processor, NotificationProcessorEvent.ABORT, verifyAbortEvent, 100);
            processor.abort();
        }

        [Test(async)]
        public function testNotificationProcessorSendsFinishAfterAllInterceptorsHaveSkipped():void
        {
            var sampleSize:int = 20;
            var i:int;
            var count:int = 0;
            var verifyFinishEvent:Function = function(event:NotificationProcessorEvent, passThroughData:Object = null):void
            {
                assertEquals(NotificationProcessorEvent.FINISH, event.type);
                count++;
            };

            Async.handleEvent(this, processor, NotificationProcessorEvent.FINISH, verifyFinishEvent, 100);

            for (i = 0; i < sampleSize; i++) {
                processor.addInterceptor(new InterceptorMock());
            }

            for (i = 0; i < sampleSize - 1; i++) {
                processor.skip();
            }

            assertEquals(0, count);

            processor.skip();
            assertEquals(1, count);
        }

        [Test]
        public function testNotificationProcessorResetsOnDisposal():void
        {
            var processor:NotificationProcessor = new NotificationProcessor(note);
            var sampleSize:int = 20;
            var interceptors:Array = new Array();
            var interceptor:InterceptorMock;
            var i:int;

            for (i = 0; i < sampleSize; i++) {
                interceptor = new InterceptorMock();
                interceptor.mock.method("dispose").withNoArgs.once;

                interceptors.push(interceptor);
                processor.addInterceptor(interceptor);
            }

            processor.dispose();

            assertNull(processor.getNotification());

            for (i = 0; i < sampleSize; i++) {
                interceptor = interceptors[i];
                verifyMock(interceptor.mock);
            }
        }

    }
}
