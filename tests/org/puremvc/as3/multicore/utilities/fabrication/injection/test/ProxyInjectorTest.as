package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionField;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.mock.ProxyInjectorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

    public class ProxyInjectorTest extends BaseTestCase {

        private var facade:FacadeMock;
        private var context:InjectionClientClass;
        private var proxyInjector:ProxyInjectorMock;


        [Before]
        public function setUp():void
        {

            facade = new FacadeMock(instanceName);
            context = new InjectionClientClass();
            proxyInjector = new ProxyInjectorMock(facade, context);

        }

        [After]
        public function tearDown():void
        {

            facade = null;
            context = null;
            proxyInjector = null;

        }

        [Test]
        public function proxyInjectorElementExist():void
        {

            assertFalse(proxyInjector.elementExistMethod(null));
            assertTrue(proxyInjector.elementExistMethod("element"));


        }

        [Test]
        public function proxyInjectorGetPatternElementForInjection():void
        {

            proxyInjector.getPatternElementForInjectionMethod( "element", FabricationProxy );
            assertNull( proxyInjector.getPatternElementForInjectionMethod( "element", Object ) );            

        }

        [Test]
        public function proxyInjectorGetElementName():void {

            var field:InjectionField = new InjectionField();
            field.elementClass = InjectionClientClass;
            field.elementName = "elementName";
            assertEquals( "elementName", proxyInjector.getElementNameMethod( field ) );
            field.elementName = null;
            assertEquals( InjectionClientClass.NAME, proxyInjector.getElementNameMethod( field ) );


            
        }


    }
}