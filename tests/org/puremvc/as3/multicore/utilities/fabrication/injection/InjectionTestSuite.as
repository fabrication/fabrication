package org.puremvc.as3.multicore.utilities.fabrication.injection {
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.MediatorInjectorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.ProxyInjectorTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class InjectionTestSuite {


        public var proxyInjectorTest:ProxyInjectorTest;
        public var mediatorInjectorTest:MediatorInjectorTest;

    }
}