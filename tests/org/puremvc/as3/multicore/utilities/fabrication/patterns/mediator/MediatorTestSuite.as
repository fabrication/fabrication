package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.ResolverTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.test.FlexMediatorTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class MediatorTestSuite {

        public var flexMediatorTest:FlexMediatorTest;

        // resolver
        public var resolverTestSuite:ResolverTestSuite;

    }
}