package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import flash.utils.getDefinitionByName;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionField;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.Injector;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.mock.InjectorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

    public class InjectorTest extends BaseTestCase {

        private var context:InjectionClientClass;
        private var mediatorInjector:InjectorMock;
        private var proxyInjector:InjectorMock;
        private var facade:Facade;


        [Before]
        public function setUp():void
        {

            facade = new FacadeMock( instanceName );
            context = new InjectionClientClass();
            proxyInjector = new InjectorMock( facade, context, Injector.INJECT_PROXY);
            mediatorInjector = new InjectorMock( facade, context, Injector.INJECT_MEDIATOR);

        }

        public function tearDown():void
        {

            facade = null;
            context = null;
            proxyInjector = null;
            mediatorInjector = null;

        }


//        [Test]
//        public function injectionTest():void
//        {
//
//            proxyInjector.mock.method("elementExist").withArgs("MyProxy").returns(true);
//            proxyInjector.mock.method("elementExist").withArgs("FabricationProxy").returns(true);
//            proxyInjector.mock.method("getPatternElementForInjection").withArgs("MyProxy", IProxy).returns(new FabricationProxy());
//            proxyInjector.mock.method("getPatternElementForInjection").withArgs(null, FabricationProxy).returns(new FabricationProxy());
//            var proxyInjections:Vector.<String> = proxyInjector.inject();
//            assertNotNull(context.proxyByClass);
//            assertNotNull(context.proxyByNameAndType);
//            assertEquals(2, proxyInjections.length);
//
//            verifyMock(proxyInjector.mock);
//
//            mediatorInjector.mock.method("elementExist").withArgs("MyMediator").returns(true);
//            mediatorInjector.mock.method("getPatternElementForInjection").withArgs("MyMediator", IMediator).returns(new FabricationMediator());
//            proxyInjector.mock.method("getPatternElementForInjection").withArgs(null, FabricationMediator).returns(new FabricationMediator());
//            var mediatorInjections:Vector.<String> = mediatorInjector.inject();
//            assertNotNull(context.proxyByClass);
//            assertNotNull(context.proxyByNameAndType);
//            assertEquals(2, mediatorInjections.length);
//
//            verifyMock(mediatorInjector.mock);
//
//
//        }

        [Test]
        public function injectorFieldCount():void
        {


            var proxies:Vector.<InjectionField> = proxyInjector.getInjectionFieldsByInjectionType(Injector.INJECT_PROXY);
            assertEquals(2, proxies.length);

            var mediators:Vector.<InjectionField> = mediatorInjector.getInjectionFieldsByInjectionType(Injector.INJECT_MEDIATOR);
            assertEquals(2, mediators.length);


        }

        [Test]
        public function classInfoByNameAndTypeTest():void
        {

            var injectedField:InjectionField;
            var proxies:Vector.<InjectionField> = proxyInjector.getInjectionFieldsByInjectionType(Injector.INJECT_PROXY);

            var proxyByNameAndType:InjectionField = new InjectionField();
            proxyByNameAndType.fieldName = "proxyByNameAndType";
            proxyByNameAndType.elementClass = getDefinitionByName( "org.puremvc.as3.multicore.interfaces.IProxy" ) as Class;
            proxyByNameAndType.elementTypeIsInterface = true;
            proxyByNameAndType.elementName = "MyProxy";

            var exists:Boolean;
            for each(injectedField in proxies) {

                exists = comapreFields(proxyByNameAndType, injectedField);
                if (exists) break;

            }
            assertTrue(exists);

            var mediators:Vector.<InjectionField> = mediatorInjector.getInjectionFieldsByInjectionType(Injector.INJECT_MEDIATOR);

            var mediatorByNameAndType:InjectionField = new InjectionField();
            mediatorByNameAndType.fieldName = "mediatorByNameAndType";
            mediatorByNameAndType.elementClass = getDefinitionByName( "org.puremvc.as3.multicore.interfaces.IMediator" ) as Class;
            mediatorByNameAndType.elementTypeIsInterface = true;
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
            var proxies:Vector.<InjectionField> = proxyInjector.getInjectionFieldsByInjectionType(Injector.INJECT_PROXY);

            var proxyByClass:InjectionField = new InjectionField();
            proxyByClass.fieldName = "proxyByClass";
            proxyByClass.elementClass = getDefinitionByName( "org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy" ) as Class;
            proxyByClass.elementTypeIsInterface = false;

            var exists:Boolean;
            for each(injectedField in proxies) {

                exists = comapreFields(proxyByClass, injectedField);
                if (exists) break;

            }
            assertTrue(exists);

            var mediators:Vector.<InjectionField> = mediatorInjector.getInjectionFieldsByInjectionType(Injector.INJECT_MEDIATOR);

            var mediatorByClass:InjectionField = new InjectionField();
            mediatorByClass.fieldName = "mediatorByClass";
            mediatorByClass.elementClass = getDefinitionByName( "org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator" ) as Class;
            mediatorByClass.elementTypeIsInterface = false;

            exists = false;
            for each(injectedField in mediators) {

                exists = comapreFields(mediatorByClass, injectedField);
                if (exists) break;

            }
            assertTrue(exists);


        }

        private function comapreFields(field1:InjectionField, field2:InjectionField):Boolean
        {
            return field1.fieldName == field2.fieldName &&
                   field1.elementClass == field2.elementClass &&
                   field1.elementName == field2.elementName &&
                   field1.elementTypeIsInterface == field2.elementTypeIsInterface;
        }


    }
}