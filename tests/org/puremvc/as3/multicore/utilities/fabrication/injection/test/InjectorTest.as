package org.puremvc.as3.multicore.utilities.fabrication.injection.test {
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.addons.InjectionClientClass;
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


        [Test]
        public function injectionTest():void
        {

            proxyInjector.mock.method("elementExist").withArgs("MyProxy").returns(true);
            proxyInjector.mock.method("getPatternElementForInjection").withArgs("MyProxy", IProxy).returns(new FabricationProxy());
            proxyInjector.mock.method("getPatternElementForInjection").withArgs(null, FabricationProxy).returns(new FabricationProxy());
            var proxyInjections:Vector.<String> = proxyInjector.inject();
            assertNotNull(context.proxyByClass);
            assertNotNull(context.proxyByNameAndType);
            assertEquals(2, proxyInjections.length);

            verifyMock(proxyInjector.mock);

            mediatorInjector.mock.method("elementExist").withArgs("MyMediator").returns(true);
            mediatorInjector.mock.method("getPatternElementForInjection").withArgs("MyMediator", IMediator).returns(new FabricationMediator());
            proxyInjector.mock.method("getPatternElementForInjection").withArgs(null, FabricationMediator).returns(new FabricationMediator());
            var mediatorInjections:Vector.<String> = mediatorInjector.inject();
            assertNotNull(context.proxyByClass);
            assertNotNull(context.proxyByNameAndType);
            assertEquals(2, mediatorInjections.length);

            verifyMock(mediatorInjector.mock);


        }


    }
}