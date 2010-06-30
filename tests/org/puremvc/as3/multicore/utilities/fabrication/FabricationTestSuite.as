package org.puremvc.as3.multicore.utilities.fabrication {
    import org.puremvc.as3.multicore.utilities.fabrication.components.ComponentsTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.core.CoreTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.events.EventsTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.InjectionTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.PatternsTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.plumbing.PlumbingTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.routing.RoutingTestSuite;
    import org.puremvc.as3.multicore.utilities.fabrication.vo.ValueObjectTestsSuite;

    [Suite]
    [RunWith( "org.flexunit.runners.Suite" )]
    public class FabricationTestSuite {



        // components
        public var componentsTestSuite:ComponentsTestSuite;

        // core
        public var coreActorsTestSuite:CoreTestSuite;

        // events
        public var eventsTestSuite:EventsTestSuite;

        // injection
        public var injectionTestSuite:InjectionTestSuite;

        // patterns
        public var patternsTestSuite:PatternsTestSuite;

        // plumbing
        public var plumbingTestSuite:PlumbingTestSuite;

        // routing
        public var routingTestSuite:RoutingTestSuite;

        // vo
        public var valueobjectTestSuite:ValueObjectTestsSuite;

    }
}