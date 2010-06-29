package org.puremvc.as3.multicore.utilities.fabrication.plumbing {
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.test.DynamicJunctionTest;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.test.NamedPipeTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class PlumbingTestSuite {

        public var namedPipeTest:NamedPipeTest;
        public var dynamicJunctionTest:DynamicJunctionTest;
    }
}