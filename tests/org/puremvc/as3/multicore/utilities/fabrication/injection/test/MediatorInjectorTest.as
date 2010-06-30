package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionField;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.mock.MediatorInjectorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.mock.ProxyInjectorMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

    public class MediatorInjectorTest extends BaseTestCase {

        private var facade:FacadeMock;
        private var context:InjectionClientClass;
        private var mediatorInjector:MediatorInjectorMock;


        [Before]
        public function setUp():void
        {

            facade = new FacadeMock(instanceName);
            context = new InjectionClientClass();
            mediatorInjector = new MediatorInjectorMock(facade, context);

        }

        [After]
        public function tearDown():void
        {

            facade = null;
            context = null;
            mediatorInjector = null;

        }

        [Test]
        public function medistorInjectorElementExist():void
        {
            var elementName1:String = "element1";
            var elementName2:String = "element2";
            facade.mock.method( "hasMediator" ).withArgs( elementName1 ).returns( true );
            assertFalse(mediatorInjector.elementExistMethod(null));
            assertTrue(mediatorInjector.elementExistMethod( elementName1 ));
            facade.mock.method( "hasMediator" ).withArgs( elementName2 ).returns( false );
            assertFalse(mediatorInjector.elementExistMethod(null));
            assertFalse(mediatorInjector.elementExistMethod( elementName2 ));
            verifyMock( facade.mock );


        }

        [Test]
        public function mediatorInjectorGetPatternElementForInjection():void
        {
            var elementName1:String = "element1";
            var elementName2:String = "element2";
            facade.mock.method( "retrieveMediator").withArgs( elementName1 ).returns( null );
            assertNull( mediatorInjector.getPatternElementForInjectionMethod( elementName1, FabricationMediator ) );
            facade.mock.method( "retrieveMediator").withArgs( elementName2 ).returns( new FabricationMediator() );
            assertType( IMediator, mediatorInjector.getPatternElementForInjectionMethod( elementName2, FabricationMediator ) );
            assertType( FabricationMediator, mediatorInjector.getPatternElementForInjectionMethod( elementName2, FabricationMediator ) );
            assertNull( mediatorInjector.getPatternElementForInjectionMethod( elementName2, FlexMediator ) );
            verifyMock( facade.mock );
        }



    }
}