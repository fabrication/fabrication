package org.puremvc.as3.multicore.utilities.fabrication.patterns {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.CommandTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FacadeTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.InterceptorTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.MediatorTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.ObserverTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.ProxyTestSuite;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class PatternsTestSuite {


        // facade
        public var facadeTestSuite:FacadeTestSuite;

        // mediator
        public var mediatorTestSuite:MediatorTestSuite;

        // proxy
        public var proxyTestSuite:ProxyTestSuite;

        // observer
        public var observerTestSuite:ObserverTestSuite;

        // interceptor
        public var interceptorTestSuite:InterceptorTestSuite;

        // command
        public var commandTestSuite:CommandTestSuite;

    }
}