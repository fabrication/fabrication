package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;

    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
    import org.puremvc.as3.multicore.utilities.fabrication.utils.ClassInfo;

    public class ClassInfoTest extends BaseTestCase {

        private var classInfo:ClassInfo;
        public var ba:ByteArray;

        [Before]
        public function setUp():void
        {

            classInfo = new ClassInfo(InjectionClientClass);

        }

        [Test]
        public function classInfoGetClass():void
        {

            assertEquals(ByteArray, ( new ClassInfo("flash.utils.ByteArray")).clazz);
            assertEquals(ByteArray, ( new ClassInfo("flash.utils::ByteArray")).clazz);

        }

        [Test]
        public function classInfoCheckTypeIsInterface():void
        {

            assertFalse(ClassInfo.checkTypeIsIneterface(ByteArray));
            assertTrue(ClassInfo.checkTypeIsIneterface(IEventDispatcher));
            assertTrue(ClassInfo.checkTypeIsIneterface(IProxy));

        }

        [Test(expects="Error")]
        public function classInfoInvalidClass():void
        {

            new ClassInfo(null);
            new ClassInfo("classNotFound");

        }

    }
}