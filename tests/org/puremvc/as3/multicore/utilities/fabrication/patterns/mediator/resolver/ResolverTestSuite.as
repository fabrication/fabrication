package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver {
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.ComponentResolverTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.ComponentRouteMapperTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.ComponentRouteTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.ExpressionIteratorTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.ExpressionTest;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test.MediatorRegistrarTest;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class ResolverTestSuite {

        public var expressionTest:ExpressionTest;
        public var mediatorRegistrarTest:MediatorRegistrarTest;
        public var componentRouteTest:ComponentRouteTest;
        public var expressionIteratorTest:ExpressionIteratorTest;
        public var componentResolverTest:ComponentResolverTest;
        public var componentRouteMapperTest:ComponentRouteMapperTest;


    }
}