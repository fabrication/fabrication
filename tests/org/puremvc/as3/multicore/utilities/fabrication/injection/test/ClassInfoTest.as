package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.ClassInfo;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionField;

    public class ClassInfoTest extends BaseTestCase {
        private var clientInstance:InjectionClientClass;
        private var classInfo:ClassInfo;

        [Before]
        public function setUp():void
        {

            classInfo = new ClassInfo(InjectionClientClass);

        }

        [Test]
        public function classInfoFieldCount():void
        {


            var proxies:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_PROXY);
            assertEquals(2, proxies.length);

            var mediators:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_MEDIATOR);
            assertEquals(2, mediators.length);


        }

        [Test]
        public function classInfoByNameAndTypeTest():void
        {

            var injectedField:InjectionField;
            var proxies:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_PROXY);

            var proxyByNameAndType:InjectionField = new InjectionField();
            proxyByNameAndType.fieldName = "proxyByNameAndType";
            proxyByNameAndType.fieldType = "org.puremvc.as3.multicore.interfaces::IProxy";
            proxyByNameAndType.fieldTypeIsInterface = true;
            proxyByNameAndType.elementName = "MyProxy";

            var exists:Boolean;
            for each(injectedField in proxies) {

                exists = comapreFields(proxyByNameAndType, injectedField);
                if (exists) break;

            }
            assertTrue(exists);

            var mediators:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_MEDIATOR);

            var mediatorByNameAndType:InjectionField = new InjectionField();
            mediatorByNameAndType.fieldName = "mediatorByNameAndType";
            mediatorByNameAndType.fieldType = "org.puremvc.as3.multicore.interfaces::IMediator";
            mediatorByNameAndType.fieldTypeIsInterface = true;
            mediatorByNameAndType.elementName = "MyMediator";

            exists = false;
            for each(injectedField in mediators) {

                exists = comapreFields(mediatorByNameAndType, injectedField);
                if (exists) break;

            }
            assertTrue(exists);


        }


        [Test]
        public function classInfoByClassTest():void
        {

            var injectedField:InjectionField;
            var proxies:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_PROXY);

            var proxyByClass:InjectionField = new InjectionField();
            proxyByClass.fieldName = "proxyByClass";
            proxyByClass.fieldType = "org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy::FabricationProxy";
            proxyByClass.fieldTypeIsInterface = false;

            var exists:Boolean;
            for each(injectedField in proxies) {

                exists = comapreFields(proxyByClass, injectedField);
                if (exists) break;

            }
            assertTrue(exists);

            var mediators:Vector.<InjectionField> = classInfo.getInjectionFieldsByInjectionType(ClassInfo.INJECT_MEDIATOR);

            var mediatorByClass:InjectionField = new InjectionField();
            mediatorByClass.fieldName = "mediatorByClass";
            mediatorByClass.fieldType = "org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator::FabricationMediator";
            mediatorByClass.fieldTypeIsInterface = false;

            exists = false;
            for each(injectedField in mediators) {

                exists = comapreFields(mediatorByClass, injectedField);
                if (exists) break;

            }
            assertTrue(exists);


        }

        [Test(expects="Error")]
        public function classInfoInvalidClass():void {

            new ClassInfo( null );
            new ClassInfo( "classNotFound" );

        }

        private function comapreFields(field1:InjectionField, field2:InjectionField):Boolean
        {
            return field1.fieldName == field2.fieldName &&
                   field1.fieldType == field2.fieldType &&
                   field1.elementName == field2.elementName &&
                   field1.fieldTypeIsInterface == field2.fieldTypeIsInterface;
        }

    }
}