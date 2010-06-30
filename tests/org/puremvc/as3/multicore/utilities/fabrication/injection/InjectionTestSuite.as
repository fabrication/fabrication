package org.puremvc.as3.multicore.utilities.fabrication.injection {
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.ClassInfoTest;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.InjectorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.MediatorInjectorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.test.ProxyInjectorTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class InjectionTestSuite {


        public var classInfoTest:ClassInfoTest;
        public var injectorTest:InjectorTest;
        public var proxyInjectorTest:ProxyInjectorTest;
        public var mediatorInjectorTest:MediatorInjectorTest;

    }
}